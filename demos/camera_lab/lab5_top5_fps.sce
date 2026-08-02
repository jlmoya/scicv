// Scilab Computer Vision Module
//
// lab5_top5_fps.sce -- Camera Lab 5/5 (stretch): top-5 ranking + measured fps.
//
// Same live loop as lab4, with two additions that make the pipeline''s
// behavior easier to reason about:
//   - the top-5 ranking per frame, not just the top-1 label -- shows HOW
//     confident the model is, and what else it considered.
//   - per-frame timing via tic()/toc() -- shows the COST of one
//     classification, not just an end-of-run average.
//
//   scilab2027 -nb -f demos/camera_lab/lab5_top5_fps.sce
//
// Optional override (set via -e before -f):
//   nframes -- number of frames to capture before stopping. Default 15
//              (shorter than lab4''s 30 -- this prints more per frame).
//
// Exit status: 0 = at least one frame classified, 1 = failure (reason
// printed). exit(), never quit(): quit() ignores its argument.

here = get_absolute_file_path("lab5_top5_fps.sce");
if ~exists("scicv_Init") then
    exec(fullfile(here, "..", "..", "loader.sce"), -1);
end
scicv_Init();

classify_dir = fullfile(here, "..", "camera_classify");
if ~exists("mobilenetv2_classify") then
    exec(fullfile(classify_dir, "classify_common.sce"), -1);
end

mprintf("=== Camera Lab 5/5: top-5 + fps ===\n\n");
mprintf("Still ONE label''s worth of understanding per frame -- see lab3 and\n");
mprintf("lab4 for why this is classification, not detection. This lab just\n");
mprintf("shows more of what the model actually computed: the full ranked\n");
mprintf("list of candidates, and how long each frame cost to classify.\n\n");

NFRAMES = 15;
if exists("nframes") then NFRAMES = nframes; end
mprintf("Will capture at most %d frames, then stop on its own. Override with:\n", NFRAMES);
mprintf("  scilab2027 -nb -e ""nframes=10;"" -f demos/camera_lab/lab5_top5_fps.sce\n\n");

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
mprintf("Camera open.\n\n");

classified = 0;
fps_sum = 0;
t0 = getdate("s");
had_error = %f;
err_msg = "";
f = [];

// Same guarantee as lab4: any failure inside the loop still falls through
// to the release block below. A camera left open stays open.
try
    f = scf();
    f.figure_name = "Lab 5 - top-5 + fps";

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

        // tic()/toc() gives sub-second precision on ONE forward pass.
        // Contrast lab4''s dt = getdate("s") - t0, which only resolves to
        // the whole second and is meant for the whole-run average, not a
        // single frame''s cost.
        tic();
        [idx, conf, scores] = mobilenetv2_classify(net, frame);
        elapsed = toc();
        fps_now = 1 / max(elapsed, 0.001);
        fps_sum = fps_sum + fps_now;
        classified = classified + 1;

        [sorted, order] = gsort(scores, "g", "d");
        mprintf("frame %3d (%.3f s, %.1f fps):\n", k, elapsed, fps_now);
        for r = 1:5
            mprintf("    %d: %-40s (score %.3f)\n", r, classes(order(r)), sorted(r));
        end

        label = classes(idx);
        putText(frame, msprintf("%s (%.2f)", label, conf), [10, 20], ..
            FONT_HERSHEY_PLAIN, 1.2, [0, 255, 0], 1);
        putText(frame, msprintf("%.1f fps", fps_now), [10, 40], ..
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
mprintf("\nCamera released.\n");

if had_error then
    mprintf("FAIL: error during capture loop: %s\n", err_msg);
    exit(1);
end

if classified == 0 then
    mprintf("FAIL: no frame was classified in %d attempts\n", NFRAMES);
    exit(1);
end

mprintf("PASS: classified %d frames in %d s wall-clock (%.1f fps average\n", classified, dt, classified / max(dt, 1));
mprintf("      for the whole run); mean per-frame classify() cost was %.1f fps.\n", fps_sum / classified);
mprintf("The gap between the two numbers is everything OUTSIDE classify() --\n");
mprintf("camera read, display, console output -- not the model itself.\n");
exit(0);
