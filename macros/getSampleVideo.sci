root_path = fullpath(get_absolute_file_path("getSampleVideo.sci") + "/..");

function video_path = getSampleVideo(video_name)
    video_path = fullfile(root_path, "data/videos", video_name);
endfunction
