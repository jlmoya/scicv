// scicv - AVFoundation-only implementation backing the camera-authorization
// gateway verbs (cvCameraAuthStatus / cvRequestCameraAccess).
//
// Deliberately isolated from Scilab's own headers: this file never includes
// api_scilab.h or anything that drags in Scilab's modules/core/includes/
// BOOL.h. That typedef and Apple's own <objc/objc.h> "typedef bool BOOL;"
// collide the instant both are visible in the same translation unit
// ("typedef redefinition with different types ('bool' vs 'enum BOOL')") --
// measured directly while first building this gateway with both header
// worlds in one file. sci_cvCameraAuthStatus.cpp and
// sci_cvRequestCameraAccess.cpp stay on the Scilab side of that boundary and
// only ever see the two extern "C" double-returning functions declared here;
// they never see AVFoundation/Foundation.
//
// Whole file is a no-op (empty translation unit) on non-Darwin -- see
// sci_gateway/c/buildflags.sci's getos() == "Darwin" branching for the same
// convention applied to the SWIG side's compile/link flags.

#ifdef __APPLE__

#import <AVFoundation/AVFoundation.h>
#include <dispatch/dispatch.h>

// Apple's own AVAuthorizationStatus ordinals already match the verb
// contract documented in sci_cvCameraAuthStatus.cpp (0 notDetermined,
// 1 restricted, 2 denied, 3 authorized) -- decoded via a switch rather than
// a raw cast so this stays correct even if that ever changed.
static double statusToDouble(AVAuthorizationStatus s)
{
    switch (s)
    {
        case AVAuthorizationStatusNotDetermined: return 0.0;
        case AVAuthorizationStatusRestricted:     return 1.0;
        case AVAuthorizationStatusDenied:         return 2.0;
        case AVAuthorizationStatusAuthorized:     return 3.0;
        default:                                  return 0.0;
    }
}

extern "C" double scicv_camera_auth_status(void)
{
    @autoreleasepool
    {
        return statusToDouble([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]);
    }
}

extern "C" double scicv_camera_request_access(void)
{
    @autoreleasepool
    {
        AVAuthorizationStatus s = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        double status = statusToDouble(s);

        if (s == AVAuthorizationStatusNotDetermined)
        {
            // Do NOT block here: a dispatch_semaphore_wait on the calling
            // thread (the Scilab interpreter thread) starves the very run
            // loop that would deliver requestAccessForMediaType:'s
            // completion callback -- measured directly with a standalone
            // probe (see task-3-report.md): the handler never fired, with or
            // without also pumping the run loop from this side. Fire-and-
            // forget onto the MAIN queue instead; only a launched .app
            // bundle (never scilab-cli/scilab2027 run from a terminal) has a
            // live Cocoa main run loop to actually service it.
            dispatch_async(dispatch_get_main_queue(), ^{
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                          completionHandler:^(BOOL granted) {
                    // Deliberately empty: this runs later, on the main
                    // thread, asynchronously with respect to the gateway
                    // call that triggered it (which has already returned by
                    // then) -- there is no safe way to hand a result back
                    // into the Scilab interpreter from here. The caller
                    // polls cvCameraAuthStatus() instead.
                    (void)granted;
                }];
            });
        }

        return status;
    }
}

#endif /* __APPLE__ */
