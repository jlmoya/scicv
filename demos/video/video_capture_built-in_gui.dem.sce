// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

if getos() == "Darwin" then
    if messagebox("This demo does not work well on Mac OSx, do you want to continue ?", ..
        "sciCV - Video capture built-in GUI demo", "warning", ["OK", "Cancel"], "modal") <> 1 then
        return
    end
end

scicv_Init();

// Video capture from the first device, supposed a camera
videoCapture = new_VideoCapture(0);
if ~VideoCapture_isOpened(videoCapture)
    messagebox("Cannot open capture device #0. Please plug a camera.", ..
        "sciCV - Video capture built-in GUI demo");
    return
end

clsf = new_CascadeClassifier();
CascadeClassifier_load(clsf, "data/haarcascades/haarcascade_frontalface_alt.xml");

startWindowThread();
namedWindow("Capture");

faceDetection = %f;

while %t
    [ret, frame] = VideoCapture_read(videoCapture);
    if ret then
        if faceDetection then
            faces = CascadeClassifier_detectMultiScale(clsf, frame, 1.3, 2, CASCADE_SCALE_IMAGE, [10 10]);
            for i=1:size(faces)
                face = faces(i);
                leftTopPt = [face(1), face(2)];
                rightBottomPt = [face(1)+face(4), face(2)+face(3)];
                rectangle(frame, leftTopPt, rightBottomPt, [0, 255, 0], 2, 8, 0);
            end
        end
        putText(frame, "Press ''d'' to enable/disable face detection, and ''q'' to quit", ..
            [10, 10], FONT_HERSHEY_PLAIN, 1.0, [0,255,0], 1);
        imshow("Capture", frame);
        delete_Mat(frame);
    else
        break;
    end
    b = waitKey(1);
    if b == ascii('q') then
        break
    elseif b == ascii('d') then
        faceDetection = ~faceDetection;
    end
end

destroyWindow("Capture");
VideoCapture_release(videoCapture);
