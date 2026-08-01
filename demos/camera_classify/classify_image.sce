// Scilab Computer Vision Module
//
// classify_image.sce -- classify a still image from a file path. This is
// the fully self-verifiable half of the camera-classification demo: no
// camera, no permission prompt, so it is the one allowed to assert
// PASS/FAIL for real.
//
//   image file -> imread -> blobFromImage -> Net_forward -> top-1 label
//
// camera_classify.sce (the live loop) calls the exact same
// mobilenetv2_classify() from classify_common.sce, so it cannot drift from
// whatever preprocessing this script verifies.
//
// Prerequisites:
//   ./fetch-model.sh          (downloads MobileNetV2 + ImageNet labels)
//
//   scilab2027 -nb -f demos/camera_classify/classify_image.sce
//
// Optional overrides (set before exec'ing, or via -e "imgpath=...;"):
//   imgpath  -- path to the image to classify.
//               Default: data/images/baboon.png, via getSampleImage().
//               ImageNet-1k has an exact "baboon" class (synset n02486410,
//               line 373 of synset.txt) and no closer alternative -- there
//               is no "mandrill" class, despite the classic USC-SIPI image
//               commonly going by that name -- so this is a clean,
//               unambiguous top-1 check, not a coin flip between two
//               near-synonyms.
//   expected -- substring the top-1 label must contain to PASS.
//               Default: "baboon".
//
// Exit status: 0 = top-1 label contains the expected substring,
//              1 = failure (reason printed).
// exit(), never quit(): quit() ignores its argument and would report
// success even on failure.

here = get_absolute_file_path("classify_image.sce");
if ~exists("scicv_Init") then
    // scicv is autoloaded under scilab2027 (etc/scicv.start, run once from
    // ~/.Scilab/scilab-app-2027/.scilab at startup). An unconditional
    // exec(loader.sce) here would re-trigger addinter() against an
    // already-loaded gateway and hang waiting on a relink prompt against
    // closed, non-interactive stdin -- hit and documented while building an
    // earlier task on this same plan (tests/camera_probe.sce).
    exec(fullfile(here, "..", "..", "loader.sce"), -1);
end
scicv_Init();
if ~exists("mobilenetv2_classify") then
    exec(fullfile(here, "classify_common.sce"), -1);
end

IMAGE = getSampleImage("baboon.png");
if exists("imgpath") then IMAGE = imgpath; end

EXPECTED = "baboon";
if exists("expected") then EXPECTED = expected; end

net = mobilenetv2_load_net(here);
classes = mobilenetv2_load_labels(here);

if ~isfile(IMAGE) then
    mprintf("FAIL: image not found: %s\n", IMAGE);
    delete_Net(net);
    exit(1);
end

img = imread(IMAGE);
sz = size(img);              // [rows, cols] == [height, width], %Mat_size.sci
if sz(1) == 0 | sz(2) == 0 then
    mprintf("FAIL: imread produced an empty image for %s\n", IMAGE);
    delete_Mat(img);
    delete_Net(net);
    exit(1);
end

[idx, conf, scores] = mobilenetv2_classify(net, img);

[sorted, order] = gsort(scores, "g", "d");
mprintf("image: %s\n", IMAGE);
mprintf("--- top 5 ---\n");
for k = 1:5
    mprintf("%d: %-40s (score %.4f)\n", k, classes(order(k)), sorted(k));
end

top1 = classes(idx);
mprintf("\ntop-1: %s (score %.4f)\n", top1, conf);

delete_Mat(img);
delete_Net(net);

// A model wired up with wrong normalization still emits a label, and
// emits it confidently -- a nonzero exit alone would not catch broken
// preprocessing. This checks the label is the specific one expected for
// the chosen sample image, not merely that some label came out.
if isempty(strindex(top1, EXPECTED)) then
    mprintf("FAIL: top-1 label ''%s'' does not contain expected substring ''%s''\n", top1, EXPECTED);
    mprintf("      A wrong-but-confident label usually means the preprocessing\n");
    mprintf("      (mean/scale/channel order/resize) is off, not that the model\n");
    mprintf("      or the gateway wiring is broken.\n");
    exit(1);
end

mprintf("PASS: top-1 label is plausible for %s\n", IMAGE);
exit(0);
