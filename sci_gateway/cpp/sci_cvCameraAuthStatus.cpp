// scicv - cvCameraAuthStatus(): read the macOS camera-authorization status.
//
// Scilab-glue only -- the actual AVFoundation call
// ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]) lives
// in camera_auth_native.cpp, kept in a separate translation unit that never
// includes Scilab's own headers (see that file for why: a typedef clash
// between Scilab's BOOL.h and Apple's objc/objc.h). That class method only
// reads the cached TCC determination -- it is safe to call from any thread
// and never triggers a prompt by itself (unlike requestAccessForMediaType:,
// see sci_cvRequestCameraAccess.cpp).
//
// Background (see .superpowers/sdd/2026-08-01-camera-and-opencv-dnn/
// task-3b-report.md and task-3-report.md in the scilab repo for the full
// measured chain): OpenCV's own AVFoundation VideoCapture backend refuses to
// call requestAccessForMediaType: when invoked off the main thread ("can not
// spin main run loop from other thread"), so new_VideoCapture(0) can succeed
// while VideoCapture_isOpened stays false forever with authorization stuck
// at notDetermined. This verb (plus cvRequestCameraAccess) exists so a
// script can drive and observe the authorization prompt explicitly, once,
// from inside a launched Scilab.app bundle -- never from the scilab-cli/
// scilab2027 terminal wrapper, which has no bundle for TCC to attribute a
// request to and no live main run loop to service one.
//
// Return: 0 notDetermined, 1 restricted, 2 denied, 3 authorized -- the exact
// ordinal values of Apple's own AVAuthorizationStatus enum.
//
// Non-Darwin: no camera-authorization gate exists on these platforms, so
// this is a no-op that unconditionally reports "authorized" -- see
// buildflags.sci's getos() == "Darwin" branching for the same convention.

extern "C" {
#include <Scierror.h>
#include <api_scilab.h>
}

#ifdef __APPLE__
extern "C" double scicv_camera_auth_status(void);
#endif

extern "C" int sci_cvCameraAuthStatus(char *fname, void *pvApiCtx)
{
    CheckInputArgument(pvApiCtx, 0, 0);
    CheckOutputArgument(pvApiCtx, 0, 1);

#ifdef __APPLE__
    double status = scicv_camera_auth_status();
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
