// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

scicv_Init();

f = scf();
toolbar(f.figure_id, "off");
demo_viewCode("video_analysis_background_substraction.dem.sce");

videoCapture = new_VideoCapture(getSampleVideo("pedestrian.avi"));
backSubMog = new_BackgrdSubMOG();

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

        img_out = BackgrdSubMOG_update(backSubMog, frame);
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

delete_BackgrdSubMOG(backSubMog);
delete_VideoCapture(videoCapture);
