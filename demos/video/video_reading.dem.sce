// Scilab Computer Vision Toolbox
// Copyright (C) 2017 - Scilab Enterprises

scicv_Init();

f = scf();
toolbar(f.figure_id, "off");
demo_viewCode("video_reading.dem.sce");

videoCapture = new_VideoCapture(getSampleVideo("video.mpg"));

while is_handle_valid(f)
    [ret, frame] = VideoCapture_read(videoCapture);
    if ret then
        if is_handle_valid(f)
            matplot(frame);
            sleep(40);
        end
        delete_Mat(frame);
    else
        break
    end
end

delete_VideoCapture(videoCapture);

if is_handle_valid(f) then
    close(f);
end


