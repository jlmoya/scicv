scicv_Init();

img = imread("data/images/street.png");

clsf = new_CascadeClassifier();
CascadeClassifier_load(clsf, "data/hogcascades/hogcascade_pedestrians.xml");

pedestrians = CascadeClassifier_detect(clsf,img, 1.2,6,1,[90 120]);
numberOfpedestrians = size(pedestrians);
s = new_Scalar(0, 255, 0); //(B,G,R)

for i=1:numberOfpedestrians
    pedestrian = pedestrians(i);
    point_1 = [pedestrian(1), pedestrian(2)]; // x,y
    point_2 = [pedestrian(1)+pedestrian(3), pedestrian(2)+pedestrian(4)]; //x+height, y+width
    rectangle(img, point_1, point_2, s, 2, 8, 0);
end

matplot(img);
title('full body detection using hogcascade');
