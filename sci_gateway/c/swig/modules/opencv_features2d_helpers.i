// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

%inline %{

void cvGetKeyPoints(KeyPoints& keyPointsIn, KeyPoints* keyPointsMatrixOut) {
    *keyPointsMatrixOut = keyPointsIn;
}

%}
