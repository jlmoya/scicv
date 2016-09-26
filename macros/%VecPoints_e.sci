function ret = %VecPoints_e(indexs, vecPoints)
  if size(indexs) == [-1, -1]
    ret = cvGetVectorPoints(vecPoints);    
  else
    if size(indexs, '*') <= 1
      ret = cvGetPoints(vecPoints, indexs);
    else
      ret = list();
      for i=1:idx
        ret(i) = cvGetPoints(vecPoints, i);
      end
    end
  end
endfunction
