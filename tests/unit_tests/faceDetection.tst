// <-- CLI SHELL MODE -->
//exec ('loader.sce')
scicv_Init
img=imread("Data/images/ScilabTeam.png");
clsf=new_CascadeClassifier();
loadFilter=CascadeClassifier_load(clsf,"Data/haarcascades/haarcascade_frontalface_alt.xml")

assert_checkequal(loadFilter, %t); // on verifie si on a bien chargé le filtre 

faces = CascadeClassifier_detect(clsf, img, 1.3, 2,CV_HAAR_SCALE_IMAGE,[30 30]); // detecter les visages  et les stocker dans v
numberOfFaces=size(faces);

assert_checkequal(numberOfFaces,15);

