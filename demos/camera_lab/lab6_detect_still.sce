// Scilab Computer Vision Module
//
// lab6_detect_still.sce -- Camera Lab 6/7: object DETECTION on a still
// image -- boxes with labels around SEVERAL objects at once, not one label
// for the whole frame. This is the beat lab3 promised was possible with
// "a different model plus a decoding step" -- this lab is that step, made
// concrete.
//
//   image file -> imread -> yolox_decode -> yolox_nms -> print every box
//
// Same shared functions demos/camera_detect/detect_image.sce already
// verified, reused here via exec (NOT copied) so this lab cannot drift from
// that verification: yolox_decode()/yolox_nms() live in exactly one place,
// demos/camera_detect/detect_common.sce.
//
//   scilab2027 -nb -f demos/camera_lab/lab6_detect_still.sce
//
// Optional overrides (set via -e before -f, same convention as lab3):
//   imgpath      -- path to the image to detect on.
//                   Default: demos/camera_detect/bus.jpg.
//   score_thresh -- per-box confidence threshold applied before NMS.
//                   Default 0.5.
//   iou_thresh   -- NMS IoU threshold, applied per class. Default 0.45.
//
// Exit status: 0 = the image''s known objects (>=1 bus, >=2 person) were
// found with every surviving box inside the image bounds, 1 = failure
// (reason printed). exit(), never quit(): quit() ignores its argument.

here = get_absolute_file_path("lab6_detect_still.sce");
if ~exists("scicv_Init") then
    exec(fullfile(here, "..", "..", "loader.sce"), -1);
end
scicv_Init();

// detect_common.sce, and the fetched model/labels/test image it loads,
// live in the SIBLING camera_detect/ directory -- this lab reuses them via
// exec rather than keeping its own copy, so it cannot drift from what
// detect_image.sce already verified there.
detect_dir = fullfile(here, "..", "camera_detect");
if ~exists("yolox_decode") then
    exec(fullfile(detect_dir, "detect_common.sce"), -1);
end

mprintf("=== Camera Lab 6/7: detect objects in a still image ===\n\n");
mprintf("lab3 classified a WHOLE image with one label. This lab finds\n");
mprintf("SEVERAL objects and WHERE each one is -- a box (x, y, width,\n");
mprintf("height) and a class label per object, not per image.\n\n");

IMAGE = fullfile(detect_dir, "bus.jpg");
if exists("imgpath") then IMAGE = imgpath; end
SCORE_THRESH = 0.5;
if exists("score_thresh") then SCORE_THRESH = score_thresh; end
IOU_THRESH = 0.45;
if exists("iou_thresh") then IOU_THRESH = iou_thresh; end

net = yolox_load_net(detect_dir);
classes = yolox_load_classes(detect_dir);
mprintf("Loaded YOLOX (80 COCO classes) -- a different model from lab3''s\n");
mprintf("MobileNetV2. Detection and classification are different tasks, not\n");
mprintf("two settings of the same model.\n\n");

if ~isfile(IMAGE) then
    mprintf("FAIL: image not found: %s\n", IMAGE);
    mprintf("      Run: cd demos/camera_detect && ./fetch-model.sh\n");
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
imgH = sz(1); imgW = sz(2);
mprintf("Read %s (%d x %d).\n\n", IMAGE, imgW, imgH);

// The teaching beat: the network's raw output is ONE tensor,
// [1 x 8400 x 85] -- not obviously "boxes" at all. The 8400 rows are THREE
// feature maps at different strides (how many pixels of the original image
// each grid cell covers), concatenated -- fine-grained stride 8 first,
// then 16, then 32. yolox_stride_layout() below is exactly that layout, so
// the 8400 is not a magic number -- it is 80x80 + 40x40 + 20x20.
layout = yolox_stride_layout();
mprintf("The raw Net_forward output is [1 x 8400 x 85] -- 8400 candidate\n");
mprintf("boxes (''anchors''), 85 numbers each (4 box + 1 objectness + 80\n");
mprintf("class scores). Where does 8400 come from? Three feature maps,\n");
mprintf("concatenated in this order:\n");
for i = 1:3
    mprintf("  stride %2d: %2d x %2d grid = %4d rows\n", layout(i,1), layout(i,2), layout(i,2), layout(i,3));
end
mprintf("  total: %d + %d + %d = %d rows\n\n", layout(1,3), layout(2,3), layout(3,3), sum(layout(:,3)));
mprintf("A coarse stride (32) covers a big patch of the image per cell, so\n");
mprintf("it tends to produce the boxes for LARGE objects (like the bus\n");
mprintf("below); a fine stride (8) covers a small patch, so it tends to\n");
mprintf("catch SMALL or nearby objects. Watch the ''stride'' column below --\n");
mprintf("it is not printed for decoration, it tells you which of the three\n");
mprintf("grids each surviving box actually came from.\n\n");

[boxes, scores, classids, strides] = yolox_decode(net, img, SCORE_THRESH);
mprintf("After decoding all 8400 rows and keeping score >= %.2f: %d candidates.\n", ..
    SCORE_THRESH, size(boxes, 1));

keep = yolox_nms(boxes, scores, classids, IOU_THRESH);
nkeep = size(keep, "*");
mprintf("After per-class NMS (drop a box if it overlaps a higher-scoring\n");
mprintf("box of the SAME class by more than iou=%.2f): %d final detections.\n\n", IOU_THRESH, nkeep);

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
    if x < 0 | y < 0 | (x + bw) > imgW | (y + bh) > imgH | bw <= 0 | bh <= 0 then
        mprintf("    ^ FAIL: box is outside the image bounds or non-positive size\n");
        bounds_ok = %f;
    end
end
mprintf("\n");

nbus = 0; nperson = 0;
for ci = 1:80
    if classes(ci) == "bus" then nbus = counts(ci); end
    if classes(ci) == "person" then nperson = counts(ci); end
end
mprintf("Sanity check against what this photo actually contains: %d bus,\n", nbus);
mprintf("%d person. A grid-order or letterbox bug tends to produce boxes\n", nperson);
mprintf("that are off-image or absurdly sized while STILL passing a naive\n");
mprintf("''did some boxes come out'' check -- this is why the numbers above\n");
mprintf("are worth reading, not just the pass/fail line below.\n\n");

delete_Mat(img);
delete_Net(net);

if ~bounds_ok then
    mprintf("FAIL: at least one surviving box failed the bounds/size check above\n");
    exit(1);
end
if nbus < 1 | nperson < 2 then
    mprintf("FAIL: expected >= 1 bus and >= 2 person in %s, found %d bus and %d person\n", ..
        IMAGE, nbus, nperson);
    exit(1);
end

mprintf("PASS: found %d bus and %d person, all boxes in-bounds.\n", nbus, nperson);
mprintf("Continue to lab7_detect_realtime.sce for the live camera version.\n");
exit(0);
