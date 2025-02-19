// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT

function cflags = getCompilationFlags()
    os = getos();
    [version, opts] = getversion();
    arch = opts(2);
    thirdparty_include = fullpath(fullfile("../../thirdparty", os, arch, "include"));

    cflags = ilib_include_flag(thirdparty_include);

    if os <> "Windows" then
        cflags = cflags + " -D_GLIBCXX_USE_CXX11_ABI=1" + " -Wno-narrowing";
    end
endfunction



function ldflags = getLinkFlags()
    os = getos();
    [version, opts] = getversion();
    arch = opts(2);
    thirdparty_lib = fullpath(fullfile("../../thirdparty", os, arch, "lib"));

    libs = "opencv_" + ["core"; "highgui"; "imgproc"; "photo"; "video"; "objdetect"; "flann"; "features2d"; "contrib"];

    if os == "Windows" then
        if findmsvccompiler() <> "unknown" then
            // Visual Studio
            ldflags = strcat(fullfile(thirdparty_lib, libs + "2413.lib"), " ");
        else
            // MinGW
            ldflags = "-L" + thirdparty_lib + " -l" + strcat(libs, " -l");
        end
    else
        libs = "opencv_world";
        ldflags = "-L" + thirdparty_lib + " -l" + strcat(libs, " -l");
    end
endfunction

