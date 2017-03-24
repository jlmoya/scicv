// Scilab Computer Vision Toolbox
// Copyright (C) 2017 - Scilab Enterprises

// <-- CLI SHELL MODE -->
// <-- NOT FIXED -->

scicv_Init();

img = imread(getSampleImage("blobs.jpg"));

detector = new_SimpleBlobDetector();

keyPoints = FeatureDetector_detect(detector, img);

// TODO fix KeyPoints extract operator
assert_checkfalse(isempty(cvGetKeyPoints(keyPoints)));

delete_SimpleBlobDetector(detector);

delete_Mat(img);
