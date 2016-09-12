videoCapture = new_VideoCapture(0);// video capture from a camera

global stop;
global f;

function stopAcquisition()
    global stop;
    global f;
    stop = %t;
    close(f);
endfunction

if ~VideoCapture_isOpened(videoCapture) 
    error("Could not open camera");
end

clsf=new_CascadeClassifier();
CascadeClassifier_load(clsf,'data/haarcascades/haarcascade_frontalface_alt.xml');

s = new_Scalar(0,255,0); 

f = figure("closerequestfcn", "stopAcquisition();");

stop = %f;
while ~stop
  frame = new_Mat();
  VideoCapture_read(videoCapture, frame);
  
  faces = CascadeClassifier_detect(clsf, frame, 1.5, 2,CV_HAAR_SCALE_IMAGE,[10 10]); 
  for i=1:size(faces)
    face = faces(i);
    point_1=[face(1), face(2)] // x,y
    point_2=[face(1)+face(4), face(2)+face(3)] //x+height, y+width
    rectangle(frame, point_1, point_2, s, 2, 8, 0);
  end
  
  mat = cvMatExtract(frame);
  Mat_release(frame); //delete_Mat(frame);
  matplot(mat);  
end

VideoCapture_release(videoCapture);


