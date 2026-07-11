// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

// <-- CLI SHELL MODE -->
// <-- NOT FIXED -->

scicv_Init();

img = imread(getSampleImage("blobs.jpg"));

detector = SimpleBlobDetector_create(); // OpenCV 5: ctor is factory-only

keyPoints = SimpleBlobDetector_detect(detector, img); // OpenCV 5: create() smart ptr; class-own detect

// detect() returns the keypoints matrix directly (OpenCV-5 port)
assert_checkfalse(isempty(keyPoints));

delete_SimpleBlobDetector(detector);

delete_Mat(img);
