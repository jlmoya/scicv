
// Copyright (C) 2016 - Scilab Enterprises -

demopath = get_absolute_file_path("scicv.dem.gateway.sce");

subdemolist = [ ..
_("Blur"), "blur.dem.sce"; ..
_("Pyramids"), "pyramids.dem.sce"; ..
_("Morphological filters"), "morphologyEx.dem.sce"; ..
_("Canny"), "canny.dem.sce"; ..
_("Sobel"), "sobel.dem.sce"; ..
_("Contour extraction"), "findContours.dem.sce"; ..
_("Thresholding"), "threshold.dem.sce"; ..
_("Watershed"), "watershed.dem.sce"; ..
_("Image reconstruction"), "imageReconstruction.dem.sce"; ..
_("Face detection"), "faceDetection.dem.sce"; ..
_("Template matching"), "templateMatching.dem.sce"; ..
_("Body detection"), "fullBodyDetection.dem.sce"; ..
_("Video capture"), "videoCapture.dem.sce"];

subdemolist(:,2) = demopath + subdemolist(:,2);
clear demopath;
