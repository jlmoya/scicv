// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

function cflags = getCompilationFlags()
    os = getos();
    if os <> "Darwin" then
        [version, opts] = getversion();
        arch = opts(2);
        thirdparty_include = fullpath(fullfile("../../thirdparty", os, arch, "include"));
    else
        thirdparty_include = fullpath(fullfile("../../thirdparty/Mac/include"));
    end

    cflags = ilib_include_flag(thirdparty_include);

    if os <> "Windows" then
        cflags = cflags + " -g" + " -D_GLIBCXX_USE_CXX11_ABI=0";
    end
endfunction


function ldflags = getLinkFlags()
    os = getos();
    if os <> "Darwin" then
        [version, opts] = getversion();
        arch = opts(2);
        thirdparty_lib = fullpath(fullfile("../../thirdparty", os, arch, "lib"));
    else
        thirdparty_lib = fullpath(fullfile("../../thirdparty/Mac/lib"));
    end

    libs = "opencv_" + ["core"; "highgui"; "imgproc"; "photo"; "video"; "objdetect"; "flann"; "features2d"; "contrib"];

    if os == "Windows" then
        if findmsvccompiler() <> "unknown" then
            // Visual Studio
            ldflags = strcat(fullpath(thirdparty_lib + "\" + libs + "2413.lib"), " ");
        else
            // MinGW
            ldflags = "-L" + thirdparty_lib + " -l" + strcat(libs, " -l");
        end
    else
        ldflags = "-L" + thirdparty_lib + " -l" + strcat(libs, " -l");
    end
endfunction

