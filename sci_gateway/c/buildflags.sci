function cflags = getCompilationFlags()
    os = getos();
    [version, opts] = getversion();
    arch = opts(2);
    cflags = "-I" + fullpath(fullfile("../../thirdparty", os, arch, "include"));
    if os <> "Windows" then
        cflags = cflags + " -g";
    end
endfunction


function ldflags = getLinkFlags()
    os = getos();
    [version, opts] = getversion();
    arch = opts(2);
    thirdparty_lib = fullpath(fullfile("../../thirdparty", os, arch, "lib"));
    libs = "opencv_" + ["core"; "highgui"; "imgproc"; "photo"; "video"; "objdetect"; "flann"; "features2d"; "contrib"];
    if getos() == "Windows" then
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

