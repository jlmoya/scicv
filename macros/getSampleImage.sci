root_path = fullpath(get_absolute_file_path("getSampleImage.sci") + "/..");

function img_path = getSampleImage(img_name)
    img_path = fullfile(root_path, "data/images", img_name);
endfunction
