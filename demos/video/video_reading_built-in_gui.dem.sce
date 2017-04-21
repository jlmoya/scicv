// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

scicv_Init();

videoCapture = new_VideoCapture(getSampleVideo("video.mpg"));
startWindowThread();
namedWindow("video.mpg");

while %t
    [ret, frame] = VideoCapture_read(videoCapture);
    if ret then
        imshow("video.mpg", frame);
        if waitKey(40) <> -1 then
            break;
        end
        delete_Mat(frame);
    else
        break
    end
end

destroyWindow("video.mpg");
delete_VideoCapture(videoCapture);
