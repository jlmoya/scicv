%{
#include "opencv2/objdetect/objdetect.hpp"
using namespace cv;
using namespace std;
using std::vector;
%}

//TODO: ignorer temporairement Detector
%ignore Detector;
%ignore HOGDescriptor;
%ignore CvDataMatrixCode;
%ignore cvLatentSvmDetectObjects;
%ignore CvObjectDetection;
%ignore LatentSvmDetector;
%ignore Data;
%ignore cv::linemod::colormap;
%rename (HaarStgClsf) CvHaarStageClassifier;
%rename (HaarClsfrCasd) CvHaarClassifierCascade;
%rename (LSVMFilterPos) CvLSVMFilterPosition;
%rename (LSVMFilterObj) CvLSVMFilterObject;
%rename (LatentSvmDet) CvLatentSvmDetector;
//%rename (HOGDesc) HOGDescriptor;

%include "opencv2/objdetect/objdetect.hpp"

