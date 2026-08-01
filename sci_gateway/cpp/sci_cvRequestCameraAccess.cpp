// scicv - cvRequestCameraAccess(): trigger the macOS camera-access prompt.
//
// Scilab-glue only -- the actual AVFoundation call
// (requestAccessForMediaType:completionHandler:, dispatched asynchronously)
// lives in camera_auth_native.cpp, kept in a separate translation unit that
// never includes Scilab's own headers (see that file for why: a typedef
// clash between Scilab's BOOL.h and Apple's objc/objc.h).
//
// Asynchronous BY DESIGN: scicv_camera_request_access() dispatches the
// request onto the main queue and returns immediately with the status
// observed BEFORE dispatching (so a caller can tell whether a prompt was
// even warranted -- if status is already restricted/denied/authorized,
// nothing is dispatched at all). It deliberately does not, and cannot,
// report the human's answer -- poll cvCameraAuthStatus() afterwards.
//
// Why not block for the answer: a dispatch_semaphore_wait on the calling
// thread (the Scilab interpreter thread) starves the very run loop that
// would deliver requestAccessForMediaType:'s completion callback. This was
// measured directly with a standalone probe (see task-3-report.md): the
// handler never fired, with or without also pumping the run loop from the
// same side. dispatch_async to the MAIN queue sidesteps this -- the
// callback runs whenever that queue's run loop is next serviced, which this
// gateway call does not wait on.
//
// Why this needs a launched .app bundle: this was also measured directly.
// OpenCV's own AVFoundation backend detects it is not being called from a
// provable main-thread/run-loop context and refuses to call
// requestAccessForMediaType: at all ("can not spin main run loop from other
// thread"). Separately, TCC.db only ever holds camera rows for bundled
// .app's with a bundle identifier (12/12 apps checked on the dev machine) --
// a bare Mach-O launched from a terminal (scilab-cli, or the scilab2027 CLI
// wrapper) has no bundle for TCC to attribute a request to, so even a
// correctly-dispatched request is silently dropped there. Both conditions
// are satisfied only inside a launched Scilab.app, where LaunchServices
// supplies the responsible bundle and AppKit supplies a live main run loop.
//
// Non-Darwin: no camera-authorization gate exists on these platforms, so
// this is a no-op that unconditionally reports "authorized" and dispatches
// nothing -- see buildflags.sci's getos() == "Darwin" branching for the same
// convention applied to compiler/link flags.

extern "C" {
#include <Scierror.h>
#include <sciprint.h>
#include <api_scilab.h>
}

#ifdef __APPLE__
extern "C" double scicv_camera_request_access(void);
#endif

extern "C" int sci_cvRequestCameraAccess(char *fname, void *pvApiCtx)
{
    CheckInputArgument(pvApiCtx, 0, 0);
    CheckOutputArgument(pvApiCtx, 0, 1);

#ifdef __APPLE__
    double status = scicv_camera_request_access();
    if (status == 0.0)
    {
        sciprint("scicv: requesting camera access -- watch for a system prompt (poll cvCameraAuthStatus() for the result).\n");
    }
#else
    double status = 3.0;
#endif

    if (createScalarDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, status))
    {
        Scierror(999, "%s: unable to create the return value.\n", fname);
        return -1;
    }
    AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;
    return 0;
}
