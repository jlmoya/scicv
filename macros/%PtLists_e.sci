// Scilab Computer Vision Toolbox
// Copyright (C) 2017 - Scilab Enterprises

function ret = %PtLists_e(varargin)
    ptLists = varargin($);
    sizePtList = cvGetPtListsSize(ptLists);
    subscript = varargin(1);
    if type(subscript) == 1 then
        if min(size(subscript)) <0 then
            // subscript is colon : (in Scilab 5)
            idxs = 1:cvGetPtListSize(ptLists);
        else
            // subscript is a matrix
            idxs = round(subscript);
            if (min(idxs) <= 0) | max(idxs) > sizePtList then
                error(_("Invalid index."), 21);
            end
        end
    elseif type(subscript) == 129 then
        // subscript is interval n:s:m
        // Bug in Scilab 6, cannot evaluate the interval, return the whole ptLists
        //idxs = round(horner(subscript(:), sizePtList));
        idxs = 1:sizePtList;
    else
        error(_("Invalid index."), 21);
    end

    if size(idxs, '*') > 1 then
        ret = list();
        for idx=idxs'
            ret($+1) = cvGetPtList(ptLists, idx-1);
        end
    else
        ret = cvGetPtList(ptLists, idxs);
    end
endfunction
