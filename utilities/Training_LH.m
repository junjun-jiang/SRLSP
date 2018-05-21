function [YH YL] = Training_LH(upscale,BlurWindow,nTraining,impat_flag,impat_pixel)
%%% construct the HR and LR training pairs from the FEI face database
disp('Constructing the HR-LR training set...');
for i=1:nTraining
    %%% read the HR face images from the HR training set
    strh = strcat('.\trainingFaces\',num2str(i),'_h.jpg');    
    HI = double(imread(strh)); 
    if impat_flag == 1
        [HIP] = imrepat(HI,impat_pixel);
        YH(:,:,i) = HIP;
    else
        YH(:,:,i) = HI;
    end
    
    %%% generate the LR face image by smooth and down-sampling
    LI = imresize(HI,1/upscale,'nearest');
    if impat_flag == 1
        [LI] = imrepat(LI,impat_pixel/2);
    end
    YL(:,:,i) = LI;
end

disp('done.');