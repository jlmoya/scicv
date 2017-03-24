// Scilab Computer Vision Toolbox
// Copyright (C) 2017 - Scilab Enterprises

scicv_Init();

f = scf();
toolbar(f.figure_id, "off");
demo_viewCode("video_analysis_background_substraction.dem.sce");

videoCapture = new_VideoCapture(getSampleVideo("pedestrian.avi"));
backMog = new_BackgrdSubMOG();

while is_handle_valid(f)
    [ret, frame] = VideoCapture_read(videoCapture);
    if ret then
        if is_handle_valid(f) then
            subplot(1,2,1);
            matplot(frame);
            title("pedestrians with background");
        else
            break
        end

        img_out = BackgrdSubMOG___funcall_(backMog, frame);
        delete_Mat(frame);

        if is_handle_valid(f) then
            subplot(1,2,2);
            matplot(img_out);
            title("pedestrians only");
        end
        delete_Mat(img_out);
    else
        break
    end
end

delete_BackgrdSubMOG(backMog);
delete_VideoCapture(videoCapture);
