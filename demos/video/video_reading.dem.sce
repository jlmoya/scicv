scicv_Init();

videoCapture = new_VideoCapture(getSampleVideo("video.mpg"));

f = scf();

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


