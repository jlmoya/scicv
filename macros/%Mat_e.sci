// Scilab Computer Vision Toolbox
// Copyright (C) 2017 - Scilab Enterprises

function ret = %Mat_e(varargin)
    mat = varargin($);

    nind = size(varargin)-1;
    if nind > 2 then
        error("multi dimensional extraction not supported");
    end

    M = cvMatExtract(mat);

    arg1 = varargin(1);
    if nind > 1 then
        arg2 = varargin(2);
        // subscripts (rows, cols coordinates) are given
        ret = M(arg1,arg2,:);
    else
        // indexs are given
        nb_channels = Mat_channels(mat);
        if nb_channels > 1
            for c=1:nb_channels
                Mc = M(:,:,c);
                ret(:,c) = Mc(arg1);
            end
        else
            ret = M(arg1);
        end
    end
endfunction
