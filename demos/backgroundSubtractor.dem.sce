cap=new_VideoCapture("Data/videos/pedestrian.avi");
s=new_Scalar(0,255,0); //BGR 
myVideo=new_VideoWriter("Sci_BackgroundSubPedes.avi",CV_FOURCC('D', 'I', 'V', '3'),10,[1536 576]);   
merged_frame=new_Mat(576,1536,CV_8UC3);
rect_1=[0,0,768,576]; // Rect(x,y,width,height)
rect_2=[768,0,768,576];
backMog=new_BackgrdSubMOG();
         
while (1) 
    frame=new_Mat();
    image=new_Mat();
    out=new_Mat(576,768,CV_8UC3);
    VideoCapture_read(cap,frame); // stock video images in a frame
    if (~Mat_empty(frame))
     BackgrdSubMOG___funcall_(backMog,frame,out,0.1);// BackgrdSubMOG()
     cvtColor(out,image,CV_GRAY2RGB);
     
     roi_1=new_Mat(merged_frame,rect_1);
     Mat_copyTo(frame,roi_1); 
    
     roi_2=new_Mat(merged_frame,rect_2);
     Mat_copyTo(image,roi_2); 
    
     
     VideoWriter_write(myVideo,merged_frame);// Writing the final video      
     
    else 
        disp('fin de la video')
        VideoWriter_release(myVideo);
        abort
    end
  
end
