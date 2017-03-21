scicv_Init();

cap = new_VideoCapture(getSampleVideo("pedestrian.avi"));

clsf = new_CascadeClassifier();
CascadeClassifier_load(clsf, fullfile(get_scicv_path(), "haarcascades", "haarcascade_fullbody.xml"));

videoWriter = new_VideoWriter("Sci_Pedestrian_detection.avi", CV_FOURCC('D', 'I', 'V', '3'), 10, [768 576]);

s = [0, 255, 0]; //BGR
frame = new_Mat();
while %t
    VideoCapture_read(cap, frame); // stock video images in a frame
    if (~Mat_empty(frame))
        pedestrians = CascadeClassifier_detect(clsf, frame, 1.1, 2, CV_HAAR_SCALE_IMAGE, [20 40])
        numberOfpedestrians = size(pedestrians);
        disp(numberOfpedestrians, "number of pedestrians:");
        for i=1:numberOfpedestrians
            pedestrian = pedestrians(i);
            point_1 = [pedestrian(1), pedestrian(2)]; // x,y
            point_2 = [pedestrian(1)+pedestrian(3), pedestrian(2)+pedestrian(4)]; //x+height, y+width
            rectangle(frame, point_1, point_2, s, 2, 8, 0);
        end

        VideoWriter_write(videoWriter, frame);

    else
        disp("video end");
        VideoWriter_release(videoWriter);
        break;
    end
end

delete_VideoCapture(videoCapture);
delete_Mat(frame);
delete_CascadeClassifier(clsf);

