// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

%rename (KalmFltr) KalmanFilter;
%rename (BackgrdSub) BackgroundSubtractor;
%rename (BackgrdSubMOG) BackgroundSubtractorMOG;
%rename (BackgrdSubMOG2) BackgroundSubtractorMOG2;
%rename (BackgrdSubGMG) BackgroundSubtractorGMG;

%rename(update) cv::BackgroundSubtractorMOG::operator();
%rename(update) cv::BackgroundSubtractorMOG2::operator();
%rename(update) cv::BackgroundSubtractorGMG::operator();

%rename (measurMtx) measurementMatrix;
%rename (errCovPost) errorCovPost;
