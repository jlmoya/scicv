// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2016 - Scilab Enterprises -


demopath = get_absolute_file_path("scicv.dem.gateway.sce");

subdemolist = [                                   ..
_("canny")      , "canny.dem.sce"    ; ..
_("faceDetection")    , "faceDetection.dem.sce"       ; ..
_("histogram")    , "histogram.dem.sce"       ; 
_("threshold")    , "threshold.dem.sce"       ;
_("medianBlur")    , "medianBlur.dem.sce"  ;
_("matchingTemplate")    , "matchingTemplate.dem.sce"  ;
_("sobel_laplacien")    , "sobel_laplacien.dem.sce"  ;
_("imageReconstruction")    , "imageReconstruction.dem.sce"  ;
_("fullBody_detection")     , "full_body_detection.dem.sce" ;
_("pyramids")    , "pyramids.dem.sce"       ];

subdemolist(:,2) = demopath + subdemolist(:,2);
clear demopath;
