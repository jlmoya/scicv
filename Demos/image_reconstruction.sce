image=imread('../Data/images/OpenCV_Logo_B.png');
mat_image=cvMatExtract(image);
image_mask=imread('../Data/images/OpenCV_Logo_C.png',CV_LOAD_IMAGE_GRAYSCALE); // must be one channal image
mat_image_mask=cvMatExtract(image_mask);
out_TELEA=inpaint(image,image_mask,3,INPAINT_TELEA); // reconstruction de l'image (first algorithm)

out_NS=inpaint(image,image_mask,3,INPAINT_NS); // reconstruction de l'image ()second algorithm)

image_mask_out=cvtColor(image_mask,CV_GRAY2BGR);

merged_frame=new_Mat(504,572,CV_8UC3);
    
    rect_1=[0,0,286,252]; // image bruitée
    rect_2=[286,0,286,252]; // le mask
    rect_3=[0,252,286,252]; // reconstruction INPAINT_TELEA
    rect_4=[286,252,286,252]; // reconstruction INPAINT_NS
    
    roi_1=new_Mat(merged_frame,rect_1);
    image=Mat_copyTo(roi_1); 
   
   
    roi_2=new_Mat(merged_frame,rect_2);
    image_mask_out=Mat_copyTo(roi_2); 
   
    roi_3=new_Mat(merged_frame,rect_3);
    out_TELEA=Mat_copyTo(roi_3); 
    mat_out_TELEA=cvMatExtract(out_TELEA);
    
    roi_4=new_Mat(merged_frame,rect_4);
    out_NS=Mat_copyTo(roi_4); 
    mat_out_NS=cvMatExtract(out_NS);

      
      //merged_frame=Mat_convertTo( merged_frame, CV_8UC3 ,3,0);
      //merged_frame=cvtColor(merged_frame,CV_BGR2RGB);
      mat_merged_frame=cvMatExtract(merged_frame);
      matplot(image)  

//    subplot(221)
//    matplot(mat_image)  
//    
//    subplot(222)
//    matplot(mat_image_mask)  
//    
//    subplot(223)
//    matplot(mat_out_TELEA)  
//    
//    subplot(224)
//    matplot(mat_out_NS)  


