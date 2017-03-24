// Scilab Computer Vision Toolbox
// Copyright (C) 2017 - Scilab Enterprises

function ret = %PtList_e(varargin)
    ptList = varargin($);
    ptListMat = cvPtListExtract(ptList);
    subscript = varargin(1);
    ret = ptListMat(:,subscript);
endfunction
