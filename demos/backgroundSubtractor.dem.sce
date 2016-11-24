scicv_Init();

cap = new_VideoCapture(getSampleVideo("pedestrian.avi"));

videoWriter = new_VideoWriter("Sci_BackgroundSubPedes.avi",CV_FOURCC('D', 'I', 'V', '3'), 10, [1536 576]);
merged_frame = new_Mat(576, 1536, CV_8UC3);
rect_1 = [0,0,768,576]; // Rect(x,y,width,height)
rect_2 = [768,0,768,576];
backMog = new_BackgrdSubMOG();

while %t
    frame = new_Mat();
    img = new_Mat();
    img_gray = (576, 768, CV_8UC3);
    VideoCapture_read(cap, frame); // stock video images in a frame
    if ~Mat_empty(frame)
        BackgrdSubMOG___funcall_(backMog, frame, out, 0.1);// BackgrdSubMOG()
        img_gray = cvtColor(img, CV_GRAY2RGB);

        roi_1 = new_Mat(merged_frame, rect_1);
        Mat_copyTo(frame, roi_1);

        roi_2 = new_Mat(merged_frame, rect_2);
        Mat_copyTo(img, roi_2);

        VideoWriter_write(myVideo, merged_frame); // Writing the final video
    else
        disp("video end")
        VideoWriter_release(myVideo);
        break;
    end
end
