// Scilab Computer Vision Module
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT

exec("versions.sce", -1);

os = getos();
[_, opts] = getversion();
arch = opts(2);

archive = "opencv-" + OPENCV_VERSION + "-ffmpeg-" + FFMPEG_VERSION + "-" + os + "-" + arch + ".tar.gz"

[result, status, headers] = http_get("https://oos.eu-west-2.outscale.com/scilab-toolboxes/prerequirements/" + archive, archive);

decompress(archive);

mdelete(archive);
