// Scilab Computer Vision Module
//
// camera_classify.sce -- live object identification from the camera.
//
//   camera -> VideoCapture_read -> blobFromImage -> Net_forward -> top-1 label
//
// A thin wrapper around classify_image.sce's verified path: frames come
// from VideoCapture_read instead of imread, but both scripts call the exact
// same mobilenetv2_classify() in classify_common.sce, so this loop cannot
// drift from what classify_image.sce already proved correct on a still
// image. What THIS script adds on top -- VideoCapture lifecycle, the
// on-screen overlay, the capture loop -- has no camera-independent way to
// verify itself and has NOT been run against a live camera as part of this
// task (camera authorization is still pending a human click through the
// macOS privacy prompt). Treat this file as reviewed-correct-by-inspection
// against the same conventions as tests/camera_probe.sce and
// demos/video/video_capture_built-in_gui.dem.sce, not as tested.
//
// Prerequisites:
//   1. ./fetch-model.sh          (downloads MobileNetV2 + ImageNet labels)
//   2. camera permission -- the first run raises the macOS privacy prompt
//
//   scilab2027 -nb -f demos/camera_classify/camera_classify.sce
//
// Optional override (set before exec'ing, or via -e "nframes=...;"):
//   nframes -- number of frames to capture before stopping. Default 60.
//              Close the preview window to stop early (see the display note
//              further down for why this is a Scilab graphics window and
//              not an OpenCV highgui one).
//
// Exit status: 0 = at least one frame classified, 1 = failure (reason
// printed). exit(), never quit(): quit() ignores its argument and would
// report success even on failure.

here = get_absolute_file_path("camera_classify.sce");
if ~exists("scicv_Init") then
    // scicv is autoloaded under scilab2027 (etc/scicv.start, run once from
    // ~/.Scilab/scilab-app-2027/.scilab at startup). An unconditional
    // exec(loader.sce) here would re-trigger addinter() against an
    // already-loaded gateway and hang waiting on a relink prompt against
    // closed, non-interactive stdin.
    exec(fullfile(here, "..", "..", "loader.sce"), -1);
end
scicv_Init();
if ~exists("mobilenetv2_classify") then
    exec(fullfile(here, "classify_common.sce"), -1);
end

NFRAMES = 60;
if exists("nframes") then NFRAMES = nframes; end

net = mobilenetv2_load_net(here);
classes = mobilenetv2_load_labels(here);

// Constructor is new_VideoCapture, not a bare VideoCapture(...) -- confirmed
// absent from the generated gateway table; new_Mat/new_Net follow the same
// pattern. VideoCapture_read takes only the capture object and returns TWO
// outputs, [ok, frame] = VideoCapture_read(cap); frame is not an in/out
// parameter the caller pre-allocates.
cap = new_VideoCapture(0);
if VideoCapture_isOpened(cap) <> %T then
    mprintf("FAIL: camera did not open. Check System Settings > Privacy &\n");
    mprintf("      Security > Camera, and that a camera is attached.\n");
    delete_VideoCapture(cap);
    delete_Net(net);
    exit(1);
end

classified = 0;
t0 = getdate("s");
had_error = %f;
err_msg = "";
f = [];   // set inside try; guarded before use in cleanup below

// The whole capture section is guarded so ANY failure inside it still falls
// through to VideoCapture/Net cleanup below rather than leaking the camera
// device on an early return.
//
// Display is Scilab's own scf()/matplot(), NOT OpenCV HighGUI
// (namedWindow/imshow/waitKey), even though that is what was specified.
// MEASURED, not assumed: a minimal `scicv_Init(); namedWindow("t");` run
// through exactly this file's own documented invocation --
// `scilab2027 -nb -f ...`, no camera, no mocking -- hard-crashes the whole
// process every time:
//   *** Terminating app due to uncaught exception
//   'NSInternalInconsistencyException', reason: 'NSWindow should only be
//   instantiated on the main thread!'
// followed by libc++abi terminate / SIGABRT. -nw (which the scilab2027
// launcher always passes) runs the interpreter off the real Cocoa main
// thread, and OpenCV HighGUI's namedWindow unconditionally allocates a real
// NSWindow on whatever thread calls it -- AppKit aborts the process rather
// than allow that. This is an Objective-C-level uncaught exception, not a
// Scilab/cv::Exception: wrapping the call in try/catch (as below) does NOT
// protect against it -- confirmed by reproducing it with the try/catch
// already in place. A crash here would also be the one failure mode that
// defeats "release the camera on every exit path", since the process dies
// before delete_VideoCapture below ever runs.
// demos/video/video_capture_built-in_gui.dem.sce's own "does not work well
// on Mac OSx" messagebox is the same HighGUI-on-macOS fragility, from the
// GUI app rather than -nw. demos/video/video_capture.dem.sce sidesteps it
// entirely with scf()/matplot() -- Scilab's native graphics, confirmed
// working under this same -nb invocation -- which is the path used here.
// putText is unaffected either way: it draws into the Mat's own pixel
// buffer and never touches a window.
try
    f = scf();

    for k = 1:NFRAMES
        if ~is_handle_valid(f) then
            mprintf("stopped early: preview window closed\n");
            break;
        end
        [ok, frame] = VideoCapture_read(cap);
        if ok <> %T then
            continue;
        end
        sz = size(frame);   // [rows, cols] == [height, width], %Mat_size.sci
        if sz(1) == 0 | sz(2) == 0 then
            delete_Mat(frame);
            continue;
        end

        [idx, conf, scores] = mobilenetv2_classify(net, frame);
        label = classes(idx);
        classified = classified + 1;
        mprintf("frame %3d: %-40s (score %.3f)\n", k, label, conf);

        putText(frame, msprintf("%s (%.2f)", label, conf), [10, 20], ..
            FONT_HERSHEY_PLAIN, 1.2, [0, 255, 0], 1);
        if is_handle_valid(f) then
            matplot(frame);
        end
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

if classified == 0 then
    mprintf("FAIL: no frame was classified in %d attempts\n", NFRAMES);
    exit(1);
end

mprintf("PASS: classified %d frames in %d s (%.1f fps)\n", classified, dt, classified / max(dt, 1));

// NEXT: bounding-box detection. OpenCV 5 dropped the Darknet and Caffe
// importers, so it needs an ONNX detector (NanoDet-Plus-m from opencv_zoo, or
// YOLOv8n) plus its decoding -- generalized-focal-loss distributions for the
// former, an 84x8400 transposed head for the latter -- then NMSBoxes, which
// is already wrapped.
exit(0);
