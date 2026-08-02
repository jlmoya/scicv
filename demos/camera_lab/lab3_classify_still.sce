// Scilab Computer Vision Module
//
// lab3_classify_still.sce -- Camera Lab 3/5: the inference chain, no camera.
//
// Classifies ONE still image from data/images/ with the exact same
// function camera_classify.sce and lab4/lab5 use per live frame --
// mobilenetv2_classify() from demos/camera_classify/classify_common.sce.
// No camera, no permission prompt, fully deterministic: this is the one
// lab file that can assert PASS/FAIL for real, same reasoning as
// classify_image.sce.
//
//   scilab2027 -nb -f demos/camera_lab/lab3_classify_still.sce
//
// Optional overrides (set via -e before -f, same convention as
// classify_image.sce), to try it on a different picture:
//   imgpath  -- path to the image to classify. Default: data/images/baboon.png.
//   expected -- substring the top-1 label must contain to PASS. Default: "baboon".
//
// Exit status: 0 = top-1 label contains the expected substring, 1 =
// failure (reason printed). exit(), never quit(): quit() ignores its
// argument.

here = get_absolute_file_path("lab3_classify_still.sce");
if ~exists("scicv_Init") then
    exec(fullfile(here, "..", "..", "loader.sce"), -1);
end
scicv_Init();

// classify_common.sce, and the fetched model + labels it loads, live in the
// SIBLING camera_classify/ directory -- this lab reuses them via exec
// rather than keeping its own copy, so it cannot drift from what
// classify_image.sce already verified there.
classify_dir = fullfile(here, "..", "camera_classify");
if ~exists("mobilenetv2_classify") then
    exec(fullfile(classify_dir, "classify_common.sce"), -1);
end

mprintf("=== Camera Lab 3/5: classify a still image ===\n\n");
mprintf("The inference chain, with no camera in the way:\n");
mprintf("  image file -> imread -> blobFromImage -> Net_forward -> argmax -> label\n\n");
mprintf("lab4 and lab5 run this SAME chain per camera frame -- imread is\n");
mprintf("simply replaced by VideoCapture_read. Nothing about the model or\n");
mprintf("the preprocessing changes between a file and a live frame, because\n");
mprintf("both call the one shared mobilenetv2_classify() function.\n\n");

IMAGE = getSampleImage("baboon.png");
if exists("imgpath") then IMAGE = imgpath; end
EXPECTED = "baboon";
if exists("expected") then EXPECTED = expected; end

net = mobilenetv2_load_net(classify_dir);
classes = mobilenetv2_load_labels(classify_dir);
mprintf("Loaded MobileNetV2 (1000 ImageNet classes).\n\n");

if ~isfile(IMAGE) then
    mprintf("FAIL: image not found: %s\n", IMAGE);
    delete_Net(net);
    exit(1);
end

img = imread(IMAGE);
sz = size(img);   // [rows, cols] == [height, width]
if sz(1) == 0 | sz(2) == 0 then
    mprintf("FAIL: imread produced an empty image for %s\n", IMAGE);
    delete_Mat(img);
    delete_Net(net);
    exit(1);
end
mprintf("Read %s (%d x %d).\n\n", IMAGE, sz(1), sz(2));

mprintf("Trap: blobFromImage resizes to a target Size, and scicv''s Size is\n");
mprintf("[height, width] -- the OPPOSITE of OpenCV C++''s (width, height).\n");
mprintf("classify_common.sce uses [224, 224], where the order happens to be\n");
mprintf("unobservable because both sides are equal. Get it backwards on a\n");
mprintf("non-square size and the blob is silently transposed -- no error,\n");
mprintf("just a confidently wrong answer.\n\n");

[idx, conf, scores] = mobilenetv2_classify(net, img);
top1 = classes(idx);

mprintf("top-1: %s (score %.4f)\n\n", top1, conf);

mprintf("Scope: this is ONE label for the WHOLE image -- the model never\n");
mprintf("looked for individual objects and produced no box, no count, no\n");
mprintf("location. That is detection, a different model plus a decoding\n");
mprintf("step scicv does not currently wrap. lab4''s live demo draws one\n");
mprintf("label over the whole frame for exactly this reason -- do not read\n");
mprintf("it as finding multiple objects. lab5 shows the top-5 candidates\n");
mprintf("afterward, which is the closest this pipeline gets to expressing\n");
mprintf("uncertainty about what is in the frame.\n\n");

delete_Mat(img);
delete_Net(net);

if isempty(strindex(top1, EXPECTED)) then
    mprintf("FAIL: top-1 label ''%s'' does not contain expected substring ''%s''\n", top1, EXPECTED);
    exit(1);
end

mprintf("PASS: top-1 label is plausible for %s\n", IMAGE);
mprintf("Continue to lab4_realtime.sce.\n");
exit(0);
