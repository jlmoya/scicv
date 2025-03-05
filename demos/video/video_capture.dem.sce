// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

scicv_Init();

// video capture from the camera
videoCapture = new_VideoCapture(0);
if ~VideoCapture_isOpened(videoCapture)
    messagebox("Cannot open capture device #0. Please plug a camera.", ..
        "sciCV - Video capture demo");
    return
end

f = scf();
toolbar(f.figure_id, "off");
demo_viewCode("video_capture.dem.sce");

clsf = new_CascadeClassifier();
CascadeClassifier_load(clsf, "data/haarcascades/haarcascade_frontalface_alt.xml");

h_checkbox = uicontrol(f, "style", "checkbox", "string", "Face detection", ..
    "backgroundColor", [1,1,1], "position", [10,10,150,20]);

while is_handle_valid(f)
    [ret, frame] = VideoCapture_read(videoCapture);
    if ret then
        if h_checkbox.value == 1 then
            faces = CascadeClassifier_detectMultiScale(clsf, frame, 1.3, 2, CASCADE_SCALE_IMAGE, [10 10]);
            for i=1:size(faces)
                face = faces(i);
                leftTopPt = [face(1), face(2)];
                rightBottomPt = [face(1)+face(4), face(2)+face(3)];
                rectangle(frame, leftTopPt, rightBottomPt, [0, 255, 0], 2, 8, 0);
            end
        end
        if is_handle_valid(f) then
            matplot(frame);
        end
        delete_Mat(frame);
    else
        break
    end

end

VideoCapture_release(videoCapture);



