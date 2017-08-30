// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

%inline %{

void cvGetPtList(PtLists& ptListsIn, int index, PtList* ptList) {
    *ptList = ptListsIn.at(index);
}

int cvGetPtListsSize(PtLists& ptListsIn) {
    return ptListsIn.size();
}

void cvPtListExtract(PtList& ptListIn, PtList* ptListOut) {
    *ptListOut = ptListIn;
}

%}
