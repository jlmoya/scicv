// Scilab Computer Vision Module
//
// detect_image.sce -- detect objects in a still image from a file path.
// This is the fully self-verifiable half of the camera-detection demo: no
// camera, no permission prompt, so it is the one allowed to assert
// PASS/FAIL for real.
//
//   image file -> imread -> yolox_decode -> yolox_nms -> print every box
//
// camera_detect.sce (the live loop) calls the exact same yolox_decode() /
// yolox_nms() / yolox_draw() from detect_common.sce, so it cannot drift
// from whatever preprocessing and decode math this script verifies.
//
// Prerequisites:
//   ./fetch-model.sh          (downloads YOLOX + COCO labels + bus.jpg)
//
//   scilab2027 -nb -f demos/camera_detect/detect_image.sce
//
// Optional overrides (set before exec'ing, or via -e "imgpath=...;"):
//   imgpath      -- path to the image to detect on.
//                   Default: <here>/bus.jpg (fetched by fetch-model.sh).
//                   Deliberately NOT a scicv data/images/ sample -- those
//                   (baboon.png, peppers.png, ...) are single-subject
//                   textures with no COCO-class content, so they cannot
//                   exercise multi-object detection or a class check.
//   score_thresh -- per-box confidence threshold applied before NMS.
//                   Default 0.5.
//   iou_thresh   -- NMS IoU threshold, applied per class. Default 0.45.
//   want_class   -- substring a detection''s class must contain for the
//                   "expected object present" check. Default "bus".
//   want_count   -- minimum number of want_class detections required.
//                   Default 1.
//   want_class2  -- a second class to check for. Default "person".
//   want_count2  -- minimum count for want_class2. Default 2 (bus.jpg is
//                   ultralytics'' standard test photo: one bus, several
//                   people waiting to board).
//
// Exit status: 0 = both expected classes found in at least the expected
// counts, and every surviving box is inside the image bounds with positive
// size; 1 = failure (reason printed). exit(), never quit(): quit() ignores
// its argument and would report success even on failure.

here = get_absolute_file_path("detect_image.sce");
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
if ~exists("yolox_decode") then
    exec(fullfile(here, "detect_common.sce"), -1);
end

IMAGE = fullfile(here, "bus.jpg");
if exists("imgpath") then IMAGE = imgpath; end

SCORE_THRESH = 0.5;
if exists("score_thresh") then SCORE_THRESH = score_thresh; end
IOU_THRESH = 0.45;
if exists("iou_thresh") then IOU_THRESH = iou_thresh; end

WANT_CLASS = "bus"; WANT_COUNT = 1;
if exists("want_class") then WANT_CLASS = want_class; end
if exists("want_count") then WANT_COUNT = want_count; end
WANT_CLASS2 = "person"; WANT_COUNT2 = 2;
if exists("want_class2") then WANT_CLASS2 = want_class2; end
if exists("want_count2") then WANT_COUNT2 = want_count2; end

net = yolox_load_net(here);
classes = yolox_load_classes(here);

if ~isfile(IMAGE) then
    mprintf("FAIL: image not found: %s\n", IMAGE);
    delete_Net(net);
    exit(1);
end

img = imread(IMAGE);
sz = size(img);              // [rows, cols] == [height, width]
if sz(1) == 0 | sz(2) == 0 then
    mprintf("FAIL: imread produced an empty image for %s\n", IMAGE);
    delete_Mat(img);
    delete_Net(net);
    exit(1);
end
imgH = sz(1); imgW = sz(2);
mprintf("image: %s (%d x %d)\n\n", IMAGE, imgW, imgH);

[boxes, scores, classids, strides] = yolox_decode(net, img, SCORE_THRESH);
mprintf("candidates after score >= %.2f: %d (of 8400 raw anchors)\n", SCORE_THRESH, size(boxes, 1));

keep = yolox_nms(boxes, scores, classids, IOU_THRESH);
nkeep = size(keep, "*");
mprintf("survivors after per-class NMS (iou > %.2f suppressed): %d\n\n", IOU_THRESH, nkeep);

mprintf("--- detections ---\n");
mprintf("%-16s %8s %8s %8s %8s %8s %8s\n", "class", "score", "x", "y", "w", "h", "stride");
counts = zeros(1, 80);
bounds_ok = %t;
for k = 1:nkeep
    i = keep(k);
    x = boxes(i, 1); y = boxes(i, 2); bw = boxes(i, 3); bh = boxes(i, 4);
    label = classes(classids(i));
    mprintf("%-16s %8.3f %8.1f %8.1f %8.1f %8.1f %8d\n", ..
        label, scores(i), x, y, bw, bh, strides(i));
    counts(classids(i)) = counts(classids(i)) + 1;

    // A decode/grid-order bug typically produces boxes off-image or
    // absurdly sized -- assert every surviving box is a real sub-rectangle
    // of the image, not just "some numbers came out".
    if x < 0 | y < 0 | (x + bw) > imgW | (y + bh) > imgH then
        mprintf("    ^ FAIL: box is outside the image bounds (%d x %d)\n", imgW, imgH);
        bounds_ok = %f;
    end
    if bw <= 0 | bh <= 0 then
        mprintf("    ^ FAIL: non-positive box size\n");
        bounds_ok = %f;
    end
    // "Absurdly sized" guard: a box covering (almost) the entire frame is
    // the classic symptom of a wrong stride multiplier or a grid transposed
    // against the wrong axis.
    if bw > 0.98 * imgW & bh > 0.98 * imgH then
        mprintf("    ^ FAIL: box covers ~the whole frame -- looks like a decode bug, not a real detection\n");
        bounds_ok = %f;
    end
end
mprintf("\n");

delete_Mat(img);
delete_Net(net);

if ~bounds_ok then
    mprintf("FAIL: at least one surviving box failed the bounds/size sanity check above\n");
    exit(1);
end

want1_ok = %f;
for ci = 1:80
    if ~isempty(strindex(classes(ci), WANT_CLASS)) then
        if counts(ci) >= WANT_COUNT then want1_ok = %t; end
    end
end
want2_ok = %f;
for ci = 1:80
    if ~isempty(strindex(classes(ci), WANT_CLASS2)) then
        if counts(ci) >= WANT_COUNT2 then want2_ok = %t; end
    end
end

if ~want1_ok then
    mprintf("FAIL: expected at least %d detection(s) of class containing ''%s'', found fewer\n", ..
        WANT_COUNT, WANT_CLASS);
    mprintf("      A wrong-but-plausible-looking box list usually means the grid order or\n");
    mprintf("      letterbox math is off, not that the model or gateway wiring is broken.\n");
    exit(1);
end
if ~want2_ok then
    mprintf("FAIL: expected at least %d detection(s) of class containing ''%s'', found fewer\n", ..
        WANT_COUNT2, WANT_CLASS2);
    exit(1);
end

mprintf("PASS: found >= %d ''%s'' and >= %d ''%s'' in %s, all boxes in-bounds and sanely sized\n", ..
    WANT_COUNT, WANT_CLASS, WANT_COUNT2, WANT_CLASS2, IMAGE);
exit(0);
