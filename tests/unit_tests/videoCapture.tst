// <-- CLI SHELL MODE -->
exec ('loader.sce')
scicv_Init
cap=new_VideoCapture("Data/videos/video.mpg");
assert_checktrue(VideoCapture_isOpened(cap));
frame=new_Mat();
//fps_video=VideoCapture_get(cap,CV_CAP_PROP_FPS);
//assert_checkequal(fps_video,25);
