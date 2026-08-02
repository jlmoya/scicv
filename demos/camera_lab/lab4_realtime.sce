// Scilab Computer Vision Module
//
// lab4_realtime.sce -- Camera Lab 4/5: live frames + label, in real time.
//
// The payoff: camera -> VideoCapture_read -> mobilenetv2_classify -> label
// drawn on screen, in a loop, live from the camera. Same per-frame chain
// lab3 just proved on a single file, same shared mobilenetv2_classify()
// from classify_common.sce -- nothing here can drift from what lab3
// already verified.
//
//   scilab2027 -nb -f demos/camera_lab/lab4_realtime.sce
//
// Optional override (set via -e before -f):
//   nframes -- number of frames to capture before stopping. Default 30.
//              Close the preview window to stop earlier.
//
// Exit status: 0 = at least one frame classified, 1 = failure (reason
// printed). exit(), never quit(): quit() ignores its argument.

here = get_absolute_file_path("lab4_realtime.sce");
if ~exists("scicv_Init") then
    exec(fullfile(here, "..", "..", "loader.sce"), -1);
end
scicv_Init();

classify_dir = fullfile(here, "..", "camera_classify");
if ~exists("mobilenetv2_classify") then
    exec(fullfile(classify_dir, "classify_common.sce"), -1);
end

mprintf("=== Camera Lab 4/5: realtime ===\n\n");

mprintf("SCOPE -- read this before watching the window: every frame gets\n");
mprintf("ONE label for the WHOLE image. This is classification, not\n");
mprintf("detection. Nothing draws a box around an object, and nothing\n");
mprintf("counts or locates multiple objects in the frame -- it answers\n");
mprintf("what-is-this-picture-mostly, once per frame, the same way lab3\n");
mprintf("did on a single file. Bounding-box detection needs a different\n");
mprintf("model plus a decoding step scicv does not currently wrap.\n\n");

NFRAMES = 30;
if exists("nframes") then NFRAMES = nframes; end
mprintf("Will capture at most %d frames, then stop on its own -- never an\n", NFRAMES);
mprintf("infinite loop a learner cannot stop. Close the preview window to\n");
mprintf("stop earlier. Override the count with:\n");
mprintf("  scilab2027 -nb -e ""nframes=10;"" -f demos/camera_lab/lab4_realtime.sce\n\n");

net = mobilenetv2_load_net(classify_dir);
classes = mobilenetv2_load_labels(classify_dir);

cap = new_VideoCapture(0);
if VideoCapture_isOpened(cap) <> %T then
    mprintf("FAIL: camera did not open. Run lab1_permission.sce and\n");
    mprintf("lab2_one_frame.sce first if you have not already.\n");
    delete_VideoCapture(cap);
    delete_Net(net);
    exit(1);
end

mprintf("Camera open. Displaying with scf()/matplot(), not OpenCV''s\n");
mprintf("imshow/namedWindow/waitKey -- those HARD-CRASH Scilab on macOS\n");
mprintf("(an uncaught NSException, uncatchable even with try/catch) because\n");
mprintf("HighGUI allocates a real NSWindow off the main thread, which\n");
mprintf("AppKit refuses. That also means there is no waitKey(''q'') to quit\n");
mprintf("early -- closing the preview window is this lab''s early-quit\n");
mprintf("affordance instead.\n\n");

classified = 0;
t0 = getdate("s");
had_error = %f;
err_msg = "";
f = [];

// The whole loop is guarded: ANY failure inside still falls through to the
// VideoCapture/Net release below instead of leaving the camera open for
// the next run to find busy. A camera left open stays open.
try
    f = scf();
    f.figure_name = "Lab 4 - realtime classification";

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

        [idx, conf, scores] = mobilenetv2_classify(net, frame);
        label = classes(idx);
        classified = classified + 1;
        mprintf("frame %3d: %-40s (score %.3f)\n", k, label, conf);

        putText(frame, msprintf("%s (%.2f)", label, conf), [10, 20], ..
            FONT_HERSHEY_PLAIN, 1.2, [0, 255, 0], 1);
        if is_handle_valid(f) then
            matplot(frame);
        end
        // Every native object needs its own destructor. clear would drop
        // only the Scilab variable and leak the native Mat -- in a loop
        // that runs dozens of times per second, that leak adds up fast.
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
mprintf("\nCamera released.\n");

if had_error then
    mprintf("FAIL: error during capture loop: %s\n", err_msg);
    exit(1);
end

if classified == 0 then
    mprintf("FAIL: no frame was classified in %d attempts\n", NFRAMES);
    exit(1);
end

mprintf("PASS: classified %d frames in %d s (%.1f fps)\n", classified, dt, classified / max(dt, 1));
mprintf("Continue to lab5_top5_fps.sce for the top-5 view and per-frame fps.\n");
exit(0);
