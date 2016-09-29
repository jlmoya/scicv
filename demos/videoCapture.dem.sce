scicv_Init();

function closed = closeFigure()
    close(f);
	closed = %t;
endfunction

// video capture from the camera
videoCapture = new_VideoCapture(0);

if ~VideoCapture_isOpened(videoCapture)
    error("Cannot open camera.");
end

clsf = new_CascadeClassifier();
CascadeClassifier_load(clsf, "data/haarcascades/haarcascade_frontalface_alt.xml");

s = new_Scalar(0,255,0);

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
			point_1 = [face(1), face(2)] // x,y
			point_2 = [face(1)+face(4), face(2)+face(3)] //x+height, y+width
			rectangle(frame, point_1, point_2, s, 2, 8, 0);
		end

		matplot(frame, h);
		delete_Mat(frame);
    else
		disp("Capture is closed.");
		break;
	end
end

VideoCapture_release(videoCapture);

