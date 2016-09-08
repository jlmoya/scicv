m=imread("../Data/images/ScilabTeam.png");

clsf=new_CascadeClassifier();

CascadeClassifier_load(clsf,'../Data/haarcascades/haarcascade_frontalface_alt.xml');

faces = CascadeClassifier_detect(clsf, m, 1.3, 2,CV_HAAR_SCALE_IMAGE,[30 30]); // detecter les visages  et les stocker dans v

numberOfFaces=size(faces);

s=new_Scalar(0,255,0); //BGR

for i=1 : numberOfFaces
    face = faces(i);
    point_1=[face(1), face(2)] // x,y
    point_2=[face(1)+face(4), face(2)+face(3)] //x+height, y+width
    rectangle(m, point_1, point_2, s, 2, 8, 0);  
    
end
mat=cvMatExtract(m)
matplot(mat)
title('face detection')
