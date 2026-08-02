// Scilab Computer Vision Module
//
// lab7_detect_realtime.sce -- Camera Lab 7/7: the payoff. Live camera,
// several objects found and boxed every frame, updating in real time.
//
//   camera -> VideoCapture_read -> yolox_decode -> yolox_nms -> yolox_draw -> display
//
// Same per-frame chain lab6 just proved on bus.jpg, same shared
// yolox_decode()/yolox_nms()/yolox_draw() from
// demos/camera_detect/detect_common.sce (reused via exec, not copied) --
// nothing here can drift from what lab6 already verified, position
// accuracy included.
//
//   scilab2027 -nb -f demos/camera_lab/lab7_detect_realtime.sce
//
// Optional overrides (set via -e before -f):
//   nframes      -- number of frames to process before stopping. Default
//                   15 -- lower than lab4/lab5''s 30/15: decoding 8400
//                   anchors plus per-class NMS is heavier per frame than a
//                   single classification argmax. Close the preview window
//                   to stop earlier.
//   score_thresh -- per-box confidence threshold applied before NMS.
//                   Default 0.5.
//   iou_thresh   -- NMS IoU threshold, applied per class. Default 0.45.
//
// Exit status: 0 = at least one frame was processed, 1 = failure (reason
// printed). exit(), never quit(): quit() ignores its argument.

here = get_absolute_file_path("lab7_detect_realtime.sce");
if ~exists("scicv_Init") then
    exec(fullfile(here, "..", "..", "loader.sce"), -1);
end
scicv_Init();

detect_dir = fullfile(here, "..", "camera_detect");
if ~exists("yolox_decode") then
    exec(fullfile(detect_dir, "detect_common.sce"), -1);
end

mprintf("=== Camera Lab 7/7: realtime detection ===\n\n");
mprintf("SCOPE -- read this before watching the window: every frame now\n");
mprintf("gets ZERO OR MORE boxes, each with its own label and location --\n");
mprintf("the opposite of lab4''s one-label-per-frame. A box means ''this\n");
mprintf("class, roughly here''; no box for a class means the model did not\n");
mprintf("clear the score threshold for it this frame, not that it is\n");
mprintf("certain the class is absent.\n\n");

NFRAMES = 15;
if exists("nframes") then NFRAMES = nframes; end
SCORE_THRESH = 0.5;
if exists("score_thresh") then SCORE_THRESH = score_thresh; end
IOU_THRESH = 0.45;
if exists("iou_thresh") then IOU_THRESH = iou_thresh; end
mprintf("Will process at most %d frames, then stop on its own -- never an\n", NFRAMES);
mprintf("infinite loop a learner cannot stop. Close the preview window to\n");
mprintf("stop earlier. Override the count with:\n");
mprintf("  scilab2027 -nb -e ""nframes=10;"" -f demos/camera_lab/lab7_detect_realtime.sce\n\n");

net = yolox_load_net(detect_dir);
classes = yolox_load_classes(detect_dir);

cap = new_VideoCapture(0);
if VideoCapture_isOpened(cap) <> %T then
    mprintf("FAIL: camera did not open. Run lab1_permission.sce and\n");
    mprintf("lab2_one_frame.sce first if you have not already.\n");
    delete_VideoCapture(cap);
    delete_Net(net);
    exit(1);
end

mprintf("Camera open. Displaying with scf()/matplot(), not OpenCV''s\n");
mprintf("imshow/namedWindow/waitKey -- see lab4''s output for why those\n");
mprintf("hard-crash Scilab on macOS. rectangle()/putText() are unaffected:\n");
mprintf("they draw into the frame''s own pixel buffer, never a window.\n\n");

detected = 0;
t0 = getdate("s");
had_error = %f;
err_msg = "";
f = [];

// Same guarantee as lab4: any failure inside the loop still falls through
// to the VideoCapture/Net release below instead of leaving the camera open
// for the next run to find busy. A camera left open stays open.
try
    f = scf();
    f.figure_name = "Lab 7 - realtime detection";

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
        // only the Scilab variable and leak the native Mat.
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

if detected == 0 then
    mprintf("FAIL: no frame was processed in %d attempts\n", NFRAMES);
    exit(1);
end

mprintf("PASS: ran detection on %d frames in %d s (%.1f fps)\n", detected, dt, detected / max(dt, 1));
mprintf("\nThat is the whole lab: lab1-2 got a frame from the camera,\n");
mprintf("lab3-5 answered ''what is this picture, mostly'' with one label,\n");
mprintf("lab6-7 answered ''what things are here, and where'' with boxes.\n");
mprintf("Same camera plumbing throughout -- only the model and the\n");
mprintf("decoding step changed.\n");
exit(0);
