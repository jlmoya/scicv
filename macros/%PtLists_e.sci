function ret = %PtLists_e(indexs, ptLists)
  if size(indexs) == [-1, -1]
    ret = cvGetPtLists(ptLists);    
  else
    if size(indexs, '*') <= 1
      ret = cvGetPtList(ptLists, indexs);
    else
      ret = list();
      for i=1:idx
        ret(i) = cvGetPtLists(vecPoints, i);
      end
    end
  end
endfunction
