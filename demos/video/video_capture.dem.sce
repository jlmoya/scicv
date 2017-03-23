scicv_Init();

function closed = closeFigure()
    closed = %t;
endfunction

// video capture from the camera
videoCapture = new_VideoCapture(0);

if ~VideoCapture_isOpened(videoCapture)
    messagebox("Cannot open capture device #0. Please plug a camera.");
    return
end

clsf = new_CascadeClassifier();
CascadeClassifier_load(clsf, "data/haarcascades/haarcascade_frontalface_alt.xml");

closed = %f;
f = figure("closerequestfcn", "closed = closeFigure();");

[ret, frame] = VideoCapture_read(videoCapture);
matplot(frame);
delete_Mat(frame);
a = gca();
h = a.children(1);

while ~closed
    [ret, frame] = VideoCapture_read(videoCapture);
    if ret then
        faces = CascadeClassifier_detect(clsf, frame, 1.3, 2, CV_HAAR_SCALE_IMAGE, [10 10]);
        for i=1:size(faces)
            face = faces(i);
            leftTopPt = [face(1), face(2)];
            rightBottomPt = [face(1)+face(4), face(2)+face(3)];
            rectangle(frame, leftTopPt, rightBottomPt, [0, 255, 0], 2, 8, 0);
        end
        matplot(frame, h);
        delete_Mat(frame);
    else
        break
    end
end

close(f);
VideoCapture_release(videoCapture);

