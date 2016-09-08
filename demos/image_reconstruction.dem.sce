image=imread('../Data/images/OpenCV_Logo_B.png');
mat_image=cvMatExtract(image);
image_mask=imread('../Data/images/OpenCV_Logo_C.png',CV_LOAD_IMAGE_GRAYSCALE); // must be one channal image
mat_image_mask=cvMatExtract(image_mask);
out_TELEA=inpaint(image,image_mask,3,INPAINT_TELEA); // image reconstruction  (first algorithm)

out_NS=inpaint(image,image_mask,3,INPAINT_NS); // image reconstruction  (second algorithm)

image_mask_out=cvtColor(image_mask,CV_GRAY2BGR);

merged_frame=new_Mat(504,572,CV_8UC1);
    
    rect_1=[0,0,286,252]; // image with noise
    rect_2=[286,0,286,252]; //  mask
    rect_3=[0,252,286,252]; // INPAINT_TELEA reconstruction 
    rect_4=[286,252,286,252]; // INPAINT_NS reconstruction 
    
    roi_1=new_Mat(merged_frame,rect_1);
    roi_1=Mat_copyTo( image ); 
   
   
    roi_2=new_Mat(merged_frame,rect_2);
    roi_2=Mat_copyTo( image_mask_out); 
   
    roi_3=new_Mat(merged_frame,rect_3);
    roi_3=Mat_copyTo(out_TELEA ); 
    mat_out_TELEA=cvMatExtract(out_TELEA);
    
    roi_4=new_Mat(merged_frame,rect_4);
    roi_4 =Mat_copyTo(out_NS ); 
    mat_out_NS=cvMatExtract(roi_4);

    
    subplot(221)
    title('image with noise')
    matplot(mat_image)  
    
    subplot(222)
    title('mask')
    matplot(mat_image_mask)  
    
    subplot(223)
    title('TELEA reconstruction algorithm')
    matplot(mat_out_TELEA)  
    
    subplot(224)
    title('NS reconstruction algorithm')
    matplot(mat_out_NS)  
       


