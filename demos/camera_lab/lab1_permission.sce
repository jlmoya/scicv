// Scilab Computer Vision Module
//
// lab1_permission.sce -- Camera Lab 1/5: camera permission on macOS.
//
// Nothing else in this lab works until this passes. Run this FIRST.
//
//   scilab2027 -nb -f demos/camera_lab/lab1_permission.sce
//
// What this teaches:
//   - cvCameraAuthStatus() and the 4 values it can return.
//   - cvRequestCameraAccess() and why it never blocks.
//   - Why the FIRST grant has to happen from inside the GUI app, never a
//     terminal CLI invocation -- this script included.
//
// Exit status: 0 = camera access is authorized (status 3) by the time this
// script ends, 1 = not authorized yet, with next steps printed.
// exit(), never quit(): quit() ignores its argument and would report
// success even while access is still blocked.

here = get_absolute_file_path("lab1_permission.sce");
if ~exists("scicv_Init") then
    // scicv is autoloaded under scilab2027 (etc/scicv.start, run once from
    // ~/.Scilab/scilab-app-2027/.scilab at startup). An unconditional
    // exec(loader.sce) here would re-trigger addinter() against an
    // already-loaded gateway and hang waiting on a relink prompt against
    // closed, non-interactive stdin.
    exec(fullfile(here, "..", "..", "loader.sce"), -1);
end
scicv_Init();

// Apple's AVAuthorizationStatus ordinals, read verbatim by the gateway --
// index with status+1 since Scilab vectors are 1-based.
STATUS_NAMES = ["notDetermined"; "restricted"; "denied"; "authorized"];

mprintf("=== Camera Lab 1/5: permission ===\n\n");
mprintf("Before any camera code can run, macOS has to have already granted\n");
mprintf("THIS PROCESS camera access. cvCameraAuthStatus() reads that\n");
mprintf("decision; cvRequestCameraAccess() asks for it. Both are scicv''s\n");
mprintf("own verbs -- there is no cv::CameraAuthStatus in OpenCV itself, so\n");
mprintf("do not go looking for one in the OpenCV docs.\n\n");

mprintf("cvCameraAuthStatus() return values:\n");
mprintf("  0 notDetermined -- never asked yet. cvRequestCameraAccess() is\n");
mprintf("                     meaningful here and will raise the system\n");
mprintf("                     prompt (conditions below).\n");
mprintf("  1 restricted    -- blocked system-wide (parental controls / an\n");
mprintf("                     MDM profile). No in-app request changes this.\n");
mprintf("  2 denied        -- a human already said No. Only System Settings\n");
mprintf("                     can undo this, not another request call.\n");
mprintf("  3 authorized    -- granted. new_VideoCapture(0) can open the\n");
mprintf("                     device. This is what lab2 onward needs.\n\n");

status = cvCameraAuthStatus();
mprintf("Current status: %d (%s)\n\n", status, STATUS_NAMES(status + 1));

if status == 3 then
    mprintf("AUTHORIZED. Someone already completed the GUI grant described\n");
    mprintf("below on this machine -- nothing more to do here.\n\n");
    mprintf("Continue to lab2_one_frame.sce.\n");
    exit(0);
end

mprintf("Not authorized yet. Here is the constraint that makes fixing this\n");
mprintf("from a plain terminal invocation unreliable:\n\n");
mprintf("  The camera-access prompt is attributed by macOS to the\n");
mprintf("  RESPONSIBLE PROCESS, and TCC (the privacy database) only ever\n");
mprintf("  assigns that to an app bundle launched through LaunchServices --\n");
mprintf("  a Finder double-click, or `open -a Scilab-2027.0.0` -- never to a\n");
mprintf("  bare executable exec''d from a terminal, which is exactly what\n");
mprintf("  `scilab2027 -nb -f ...` (this very invocation) is. Separately,\n");
mprintf("  OpenCV''s own AVFoundation backend refuses to even ask when it is\n");
mprintf("  not being called from a provable main-thread/run-loop context, so\n");
mprintf("  a terminal-launched Scilab fails BOTH conditions at once.\n\n");
mprintf("  So the FIRST grant must happen from inside the GUI app: launch\n");
mprintf("  the app itself (not scilab2027), then in ITS own console run\n");
mprintf("      exec(""%slab1_permission.sce"", -1);\n", here);
mprintf("  Once granted, the decision is remembered for the app bundle, and\n");
mprintf("  ordinary `scilab2027 -nb -f ...` runs -- like this one -- will\n");
mprintf("  see status 3 from then on. No GUI needed again after that.\n\n");

if status == 1 | status == 2 then
    mprintf("Status %s cannot be changed by asking again. Fix it in System\n", STATUS_NAMES(status + 1));
    mprintf("Settings > Privacy & Security > Camera -- enable the Scilab\n");
    mprintf("entry there (denied), or check for an MDM/parental-control\n");
    mprintf("profile (restricted). Then re-run this script.\n");
    exit(1);
end

// status == 0 (notDetermined): asking is meaningful. cvRequestCameraAccess()
// dispatches the request onto the main queue and returns immediately with
// the status observed BEFORE dispatching -- it never blocks and never
// reports what the human decided directly, by design (a blocking wait was
// measured to starve the very run loop that delivers the answer). Poll
// cvCameraAuthStatus() afterward instead.
mprintf("Status is notDetermined: calling cvRequestCameraAccess() now.\n");
mprintf("This returns immediately -- it does NOT wait for a click. Watch\n");
mprintf("for the system dialog. If none appears, this process is not\n");
mprintf("running inside the GUI app; see above.\n\n");

cvRequestCameraAccess();

mprintf("Polling cvCameraAuthStatus() for up to 20 s, in case this same run\n");
mprintf("is fast enough to see the answer...\n");
for k = 1:10
    sleep(2000);
    status = cvCameraAuthStatus();
    if status <> 0 then
        mprintf("  status changed to %s (%d) after %d s\n", STATUS_NAMES(status + 1), status, k * 2);
        break;
    end
    mprintf("  still notDetermined after %d s\n", k * 2);
end

if status == 3 then
    mprintf("\nAUTHORIZED. Continue to lab2_one_frame.sce.\n");
    exit(0);
end

mprintf("\nNot authorized yet (%s, %d). If a click landed after this script\n", STATUS_NAMES(status + 1), status);
mprintf("stopped polling, just re-run it -- cvCameraAuthStatus() alone (no\n");
mprintf("new request) is enough to pick up the change.\n");
exit(1);
