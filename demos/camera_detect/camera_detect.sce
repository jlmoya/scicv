// Scilab Computer Vision Module
//
// camera_detect.sce -- live object DETECTION from the camera: boxes with
// labels around multiple objects at once, updating frame by frame.
//
//   camera -> VideoCapture_read -> yolox_decode -> yolox_nms -> yolox_draw -> display
//
// A thin wrapper around detect_image.sce's verified path: frames come from
// VideoCapture_read instead of imread, but both scripts call the exact same
// yolox_decode() / yolox_nms() / yolox_draw() in detect_common.sce, so this
// loop cannot drift from what detect_image.sce already proved correct on a
// still image (position accuracy included -- see detect_image.sce and
// detection-report.md for how that was checked against bus.jpg''s known
// contents, not just "did it return something").
//
// Prerequisites:
//   1. ./fetch-model.sh          (downloads YOLOX + COCO labels + bus.jpg)
//   2. camera permission -- the first run raises the macOS privacy prompt
//
//   scilab2027 -nb -f demos/camera_detect/camera_detect.sce
//
// Optional overrides (set before exec'ing, or via -e "nframes=...;"):
//   nframes      -- number of frames to capture before stopping. Default
//                   15 -- lower than camera_classify.sce''s 60: decoding
//                   8400 anchors plus per-class NMS is heavier per frame
//                   than a single 1x1000 argmax, so fewer frames keeps a
//                   run's wall-clock time reasonable. Close the preview
//                   window to stop earlier either way.
//   score_thresh -- per-box confidence threshold applied before NMS.
//                   Default 0.5.
//   iou_thresh   -- NMS IoU threshold, applied per class. Default 0.45.
//
// Exit status: 0 = at least one frame was detected on, 1 = failure (reason
// printed). exit(), never quit(): quit() ignores its argument and would
// report success even on failure.

here = get_absolute_file_path("camera_detect.sce");
if ~exists("scicv_Init") then
    // scicv is autoloaded under scilab2027 (etc/scicv.start, run once from
    // ~/.Scilab/scilab-app-2027/.scilab at startup). An unconditional
    // exec(loader.sce) here would re-trigger addinter() against an
    // already-loaded gateway and hang waiting on a relink prompt against
    // closed, non-interactive stdin.
    exec(fullfile(here, "..", "..", "loader.sce"), -1);
end
scicv_Init();
if ~exists("yolox_decode") then
    exec(fullfile(here, "detect_common.sce"), -1);
end

NFRAMES = 15;
if exists("nframes") then NFRAMES = nframes; end
SCORE_THRESH = 0.5;
if exists("score_thresh") then SCORE_THRESH = score_thresh; end
IOU_THRESH = 0.45;
if exists("iou_thresh") then IOU_THRESH = iou_thresh; end

net = yolox_load_net(here);
classes = yolox_load_classes(here);

// Constructor is new_VideoCapture, not a bare VideoCapture(...); read is
// 1-in/2-out: [ok, frame] = VideoCapture_read(cap). Same conventions as
// demos/camera_classify/camera_classify.sce and tests/camera_probe.sce.
cap = new_VideoCapture(0);
if VideoCapture_isOpened(cap) <> %T then
    mprintf("FAIL: camera did not open. Check System Settings > Privacy &\n");
    mprintf("      Security > Camera, and that a camera is attached.\n");
    delete_VideoCapture(cap);
    delete_Net(net);
    exit(1);
end

detected = 0;
t0 = getdate("s");
had_error = %f;
err_msg = "";
f = [];   // set inside try; guarded before use in cleanup below

// The whole capture section is guarded so ANY failure inside it still falls
// through to VideoCapture/Net cleanup below rather than leaking the camera
// device on an early return -- a camera left open stays open.
//
// Display is Scilab's own scf()/matplot(), NOT OpenCV HighGUI
// (namedWindow/imshow/waitKey): those hard-crash Scilab on macOS (an
// uncaught NSException -- HighGUI allocates a real NSWindow off the main
// thread under -nw, which AppKit refuses -- uncatchable even with
// try/catch). Same reasoning as camera_classify.sce; see that file's
// header for the full measured crash detail. rectangle/putText are
// unaffected either way -- they draw into the Mat's own pixel buffer and
// never touch a window, which is what yolox_draw uses them for.
try
    f = scf();
    f.figure_name = "camera_detect - live object detection";

    for k = 1:NFRAMES
        if ~is_handle_valid(f) then
            mprintf("stopped early: preview window closed\n");
            break;
        end
        [ok, frame] = VideoCapture_read(cap);
        if ok <> %T then
            continue;
        end
        sz = size(frame);   // [rows, cols] == [height, width]
        if sz(1) == 0 | sz(2) == 0 then
            delete_Mat(frame);
            continue;
        end

        [boxes, scores, classids, strides] = yolox_decode(net, frame, SCORE_THRESH);
        keep = yolox_nms(boxes, scores, classids, IOU_THRESH);
        nkeep = size(keep, "*");
        detected = detected + 1;

        mprintf("frame %3d: %d box(es)", k, nkeep);
        if nkeep > 0 then
            mprintf(" ->");
            for j = 1:nkeep
                i = keep(j);
                mprintf(" %s(%.2f)", classes(classids(i)), scores(i));
            end
        end
        mprintf("\n");

        yolox_draw(frame, boxes, scores, classids, classes, keep);
        if is_handle_valid(f) then
            matplot(frame);
        end
        // Every native object needs its own destructor. clear would drop
        // only the Scilab variable and leak the native Mat -- in a loop
        // that runs many times per run, that leak adds up fast.
        delete_Mat(frame);
    end
catch
    had_error = %t;
    err_msg = lasterror();
end

dt = getdate("s") - t0;
delete_VideoCapture(cap);
delete_Net(net);
if ~isempty(f) then
    if is_handle_valid(f) then
        close(f);
    end
end

if had_error then
    mprintf("FAIL: error during capture loop: %s\n", err_msg);
    exit(1);
end

if detected == 0 then
    mprintf("FAIL: no frame was processed in %d attempts\n", NFRAMES);
    exit(1);
end

mprintf("PASS: ran detection on %d frames in %d s (%.1f fps)\n", detected, dt, detected / max(dt, 1));
exit(0);
