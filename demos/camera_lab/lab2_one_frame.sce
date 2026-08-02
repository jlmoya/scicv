// Scilab Computer Vision Module
//
// lab2_one_frame.sce -- Camera Lab 2/5: the capture lifecycle, in isolation.
//
// Opens the camera, grabs exactly ONE frame, displays it, releases
// everything. No classification, no loop -- just the calls every camera
// script in this lab (and camera_classify.sce) is built from:
//   new_VideoCapture -> VideoCapture_isOpened -> VideoCapture_read -> delete_VideoCapture
//
//   scilab2027 -nb -f demos/camera_lab/lab2_one_frame.sce
//
// Prerequisite: lab1_permission.sce reports status 3 (authorized).
//
// Exit status: 0 = one frame captured and shown, 1 = failure (reason
// printed). exit(), never quit(): quit() ignores its argument.

here = get_absolute_file_path("lab2_one_frame.sce");
if ~exists("scicv_Init") then
    exec(fullfile(here, "..", "..", "loader.sce"), -1);
end
scicv_Init();

mprintf("=== Camera Lab 2/5: one frame ===\n\n");

mprintf("Trap: the constructor is new_VideoCapture(...), never a bare\n");
mprintf("VideoCapture(...) -- that name is not wired into the gateway at\n");
mprintf("all, so calling it fails with an undefined-function error. Same\n");
mprintf("new_/delete_ family as new_Mat/new_Net elsewhere in scicv.\n\n");

cap = new_VideoCapture(0);   // 0 = first camera device

if VideoCapture_isOpened(cap) <> %T then
    mprintf("FAIL: camera did not open. Check:\n");
    mprintf("  1) lab1_permission.sce reports status 3;\n");
    mprintf("  2) a camera is actually attached;\n");
    mprintf("  3) no other app is holding it exclusively.\n");
    delete_VideoCapture(cap);
    exit(1);
end
mprintf("Camera opened (device 0).\n\n");

mprintf("Trap: VideoCapture_read takes ONE input (the capture object) and\n");
mprintf("returns TWO outputs: [ok, frame] = VideoCapture_read(cap). Writing\n");
mprintf("`ok = VideoCapture_read(cap, frame)`, as if frame were an in/out\n");
mprintf("parameter you pre-allocate and pass in, fails confusingly instead\n");
mprintf("of doing what it looks like it should.\n\n");

// Everything from here down is guarded: on ANY failure -- an empty frame,
// a thrown error, whatever -- execution still falls through to the release
// block below rather than leaving the device open for the next run to find
// busy. frame_owned tracks whether `frame` currently holds a live native
// Mat this script still needs to delete_Mat -- without it, an exhausted
// retry loop would try to delete_Mat the same already-deleted frame twice.
had_error = %f;
err_msg = "";
ok = %f;
frame_owned = %f;
frame = [];
f = [];

try
    // AVFoundation''s first frame or two after opening is routinely empty
    // while exposure settles -- retry rather than failing on attempt 1.
    for attempt = 1:10
        [ok, frame] = VideoCapture_read(cap);
        frame_owned = %t;
        if ok then
            sz = size(frame);   // [rows, cols] == [height, width]
            if sz(1) > 0 & sz(2) > 0 then
                break;           // keep this one -- displayed and freed below
            end
        end
        delete_Mat(frame);
        frame_owned = %f;
        ok = %f;
    end

    if ok then
        sz = size(frame);
        mprintf("Captured one %d x %d frame.\n\n", sz(1), sz(2));

        mprintf("Trap: imshow/namedWindow/waitKey HARD-CRASH Scilab on\n");
        mprintf("macOS -- an uncaught NSException (''NSWindow should only be\n");
        mprintf("instantiated on the main thread''), not even catchable with\n");
        mprintf("try/catch, since it is an Objective-C-level abort, not a\n");
        mprintf("Scilab error. This lab uses Scilab''s own graphics instead --\n");
        mprintf("scf() + matplot() -- exactly like camera_classify.sce does.\n\n");

        f = scf();
        f.figure_name = "Lab 2 - one frame (closes in 3s)";
        matplot(frame);
        mprintf("Displaying for 3 seconds...\n");
        sleep(3000);
    else
        mprintf("FAIL: no non-empty frame in 10 attempts.\n");
    end
catch
    had_error = %t;
    err_msg = lasterror();
end

// Release on every path, including this one: a camera left open by a
// crashed or erroring script stays open, and the NEXT run finds the device
// busy. delete_VideoCapture, not clear -- clear only drops the Scilab
// variable and leaks the native VideoCapture object; same for delete_Mat
// and the frame.
if frame_owned then
    delete_Mat(frame);
end
delete_VideoCapture(cap);
if ~isempty(f) then
    if is_handle_valid(f) then
        close(f);
    end
end
mprintf("Camera released.\n");

if had_error then
    mprintf("FAIL: error during capture: %s\n", err_msg);
    exit(1);
end
if ~ok then
    exit(1);
end

mprintf("\nPASS. Continue to lab3_classify_still.sce.\n");
exit(0);
