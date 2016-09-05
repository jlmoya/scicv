function matplot(I)   
    sz = size(I);
    // multi channels ? 
    if size(sz, 'c') > 2 & sz(1, 3) > 1 then        
        // Convert BGR to RBG
        J(:,:,1) = I(:,:,3);
        J(:,:,2) = I(:,:,2);
        J(:,:,3) = I(:,:,1);
        Matplot(uint8(J));
    else        
        Matplot(uint8(I));
    end    
endfunction
