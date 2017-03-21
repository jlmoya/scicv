// Copyright (C) 2016 - Scilab Enterprises -

demopath = get_absolute_file_path("object_detection.dem.gateway.sce");

subdemolist = [ ..
_("Face detection"), "face_detection.dem.sce"; ..
_("Template matching"), "template_matching.dem.sce"; ..
_("Body detection"), "body_detection.dem.sce"; ..
];

subdemolist(:,2) = demopath + subdemolist(:,2);
clear demopath;
