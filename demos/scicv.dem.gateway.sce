
// Copyright (C) 2016 - Scilab Enterprises -

demopath = get_absolute_file_path("scicv.dem.gateway.sce");

subdemolist = [ ..
_("Blur"), "medianBlur.dem.sce"; ..
_("Pyramids"), "pyramids.dem.sce"; ..
_("Morphological filters"), "morphologyEx.dem.sce"; ..
_("Canny"), "Canny.dem.sce"; ..
_("Sobel"), "Sobel.dem.sce"; ..
_("Contour extaction"), "findContours.dem.sce"; ..
_("Thresholding"), "threshold.dem.sce"; ..
_("Histogram"), "histogram.dem.sce"; ..
_("Watershed"), "watershed.dem.sce"; ..
_("Image reconstruction"), "imageReconstruction.dem.sce"; ..
_("Face detection"), "faceDetection.dem.sce"; ..
_("Template matching"), "matchingTemplate.dem.sce"; ..
_("Body detection"), "full_body_detection.dem.sce"; ..
_("Video capture"), "videoCapture.dem.sce"];

subdemolist(:,2) = demopath + subdemolist(:,2);
clear demopath;
