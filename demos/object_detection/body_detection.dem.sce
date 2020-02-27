// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

scicv_Init();

f = scf();
toolbar(f.figure_id, "off");
demo_viewCode("body_detection.dem.sce");

img = imread(getSampleImage("street.png"));

clsf = new_CascadeClassifier();
hogcascades_file = fullfile(get_scicv_path(), "data", "hogcascades", "hogcascade_pedestrians.xml")
CascadeClassifier_load(clsf, hogcascades_file);

pedestrians = CascadeClassifier_detectMultiScale(clsf, img, 1.2, 6, 1, [120 90]);
numberOfpedestrians = size(pedestrians);
s = [0, 255, 0]; // BGR

for i=1:numberOfpedestrians
    pedestrian = pedestrians(i);
    point_1 = [pedestrian(1), pedestrian(2)]; // x,y
    point_2 = [pedestrian(1)+pedestrian(3), pedestrian(2)+pedestrian(4)]; //x+height, y+width
    rectangle(img, point_1, point_2, s, 2, 8, 0);
end

matplot(img);
title("full body detection using hogcascade");

delete_CascadeClassifier(clsf);
delete_Mat(img);
