// Scilab Computer Vision Toolbox
// Copyright (C) 2017 - Scilab Enterprises

scicv_Init();

f = scf();
toolbar(f.figure_id, "off");
demo_viewCode("face_detection.dem.sce");

img = imread(getSampleImage("faces.jpg"));

clsf = new_CascadeClassifier();
haarcades_file_path = fullfile(get_scicv_path(), "data", "haarcascades", "haarcascade_frontalface_alt.xml");
CascadeClassifier_load(clsf, haarcades_file_path);
faces = CascadeClassifier_detect(clsf, img, 1.2, 2, CV_HAAR_SCALE_IMAGE, [30 30]);

s = [0, 255, 0]; // BGR
for i=1:size(faces)
    face = faces(i);
    leftTop = [face(1), face(2)] // x,y
    rightBottom = [face(1)+face(4), face(2)+face(3)] //x+height, y+width
    rectangle(img, leftTop, rightBottom, s, 2, 8, 0);
end

matplot(img);
title("face detection");

delete_CascadeClassifier(clsf);
delete_Mat(img);
