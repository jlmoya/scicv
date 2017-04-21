// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

function video_path = getSampleVideo(video_name)
    video_path = fullfile(get_scicv_path(), "data/videos", video_name);
endfunction
