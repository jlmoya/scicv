// <-- CLI SHELL MODE -->

scicv_Init();

img = imread(getSampleImage("ScilabTeam.png"));
cascadeClassifier = new_CascadeClassifier();

res = CascadeClassifier_load(cascadeClassifier, "data/haarcascades/haarcascade_frontalface_alt.xml");
assert_checktrue(res);

faces = CascadeClassifier_detect(cascadeClassifier, img, 1.3, 2, CV_HAAR_SCALE_IMAGE, [30 30]);
assert_checkequal(size(faces), 15);

delete_CascadeClassifier(cascadeClassifier);

delete_Mat(img);
