%{
#undef SKIP_INCLUDES
#include "opencv2/video/video.hpp"
using namespace cv;
%}



%ignore CvKalman;
%ignore DenseOpticalFlow;
%ignore cvCalcOpticalFlowFarneback;
%ignore cvEstimateRigidTransform;
%ignore cvUpdateMotionHistory;
%ignore cvCalcMotionGradient;
%ignore cvCalcGlobalOrientation;
%ignore cvSegmentMotion;
%ignore cvCamShift;
%ignore cvMeanShift;

%rename (KalmFltr) KalmanFilter;
%rename (BackgrdSub) BackgroundSubtractor;
%rename (BackgrdSubMOG) BackgroundSubtractorMOG;
%rename (BackgrdSubMOG2) BackgroundSubtractorMOG2;
%rename (BackgrdSubGMG) BackgroundSubtractorGMG;

// renommer deux methodes
%rename (measurMtx) measurementMatrix;
%rename (errCovPost) errorCovPost;

%rename(__funcall__) operator();
//%rename(__funcall__) BackgroundSubtractorMOG2::operator();

%include "opencv2/video/video.hpp"
%include "opencv2/video/tracking.hpp"
%include "opencv2/video/background_segm.hpp"

