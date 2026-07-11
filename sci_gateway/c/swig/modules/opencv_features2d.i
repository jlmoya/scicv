// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT

%{
#undef SKIP_INCLUDES
#include "opencv2/features.hpp" // OpenCV 5 canonical name (features2d.hpp is a shim)
#include "opencv2/xfeatures2d.hpp"
using namespace cv;
%}

%include opencv_features2d_ignore.i

%apply KeyPoints* { vector<cv::KeyPoint>& keypoints };

// create() factories return Ptr<T>; the smartptr typemaps (macro from
// opencv_video.i) unwrap them so Feature2D_* methods apply directly.
%cv_ptr(cv::SimpleBlobDetector)

%include "opencv2/features.hpp" // BOWKMeansTrainer, ...
%include "opencv2/xfeatures2d.hpp" // StarDetector

// create() returns a smart pointer that the base-class Feature2D_* wrappers do
// not accept (Ptr<Derived> has no registered upcast); give the class its own
// forwarding detect() so the wrapped surface stays usable.
%extend cv::SimpleBlobDetector {
    void detect(cv::InputArray image, KeyPoints* keyPointsMatrixOut) {
        $self->detect(image, *keyPointsMatrixOut);
    }
}

%include opencv_features2d_helpers.i
