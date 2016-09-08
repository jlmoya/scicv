cap=new_VideoCapture("../image_video_samples/pedestrian.avi");

s=new_Scalar(0,255,0); //BGR 
clsf=new_CascadeClassifier();
CascadeClassifier_load(clsf,'../MyFilter/haarcascade_fullbody.xml');

myVideo=new_VideoWriter("Sci_Pedestrian_detection.avi",CV_FOURCC('D', 'I', 'V', '3'),10,[768 576]);    
while (1) 
    frame=new_Mat();
    VideoCapture_read(cap,frame); // stock video images in a frame
    
    
    if (~Mat_empty(frame))
      
      pedestrians=CascadeClassifier_detect(clsf, frame, 1.1, 2, CV_HAAR_SCALE_IMAGE,[20 40])
      numberOfpedestrians=size(pedestrians);
      disp(numberOfpedestrians,"nombre de péiton detecté: ")
      for i=1 : numberOfpedestrians
        pedestrian = pedestrians(i);
        point_1=[pedestrian(1), pedestrian(2)] // x,y
        point_2=[pedestrian(1)+pedestrian(3), pedestrian(2)+pedestrian(4)] //x+height, y+width
        rectangle(frame, point_1, point_2, s, 2, 8, 0);
       end
       
      VideoWriter_write(myVideo,frame);      
       
    else 
        disp('fin de la video')
        VideoWriter_release(myVideo);
        abort
    end
end



  
    
