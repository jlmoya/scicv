// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

demopath = get_absolute_file_path("object_detection.dem.gateway.sce");

subdemolist = [ ..
_("Face detection"), "face_detection.dem.sce"; ..
_("Template matching"), "template_matching.dem.sce"; ..
];

subdemolist(:,2) = demopath + subdemolist(:,2);
clear demopath;
