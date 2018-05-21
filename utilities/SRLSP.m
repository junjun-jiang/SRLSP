
function im_SR = SRLSP(im_l,YH,YL,upscale,patch_size,overlap,alpha,center_flag,impat_pixel)

[imrow imcol nTraining] = size(YH);

Img_SUM      = zeros(imrow,imcol);
overlap_FLAG = zeros(imrow,imcol);

U = ceil((imrow-overlap)/(patch_size-overlap));  
V = ceil((imcol-overlap)/(patch_size-overlap)); 

sub_flag = zeros(patch_size-1);
% super-resolve the HR image patch by patch
for i = 1:U
   fprintf('.');
   for j = 1:V      

        BlockSize = GetCurrentBlockSize(imrow,imcol,patch_size,overlap,i,j);
        BlockSize(1) = BlockSize(1)+1; BlockSize(3) = BlockSize(3)+1;
        BlockSizeS = GetCurrentBlockSize(imrow/upscale,imcol/upscale,patch_size/upscale,overlap/upscale,i,j);  
        
        im_l_patch = im_l(BlockSizeS(1):BlockSizeS(2),BlockSizeS(3):BlockSizeS(4));           % extract the patch at position£¨i,j£©of the input LR face     
        im_l_patch = im_l_patch(:);   % Reshape 2D image patch into 1D column vectors   
        
        XF = ExtrImg3D(YH,BlockSize,center_flag,impat_pixel);    % reshape each patch of HR face image to one column
        X  = Reshape3D(YL,BlockSizeS);   % reshape each patch of LR face image to one column
    
        % smooth regression
        Dis = sum((repmat(im_l_patch,1,size(X,2))-X).^2);    
        Dis = 1./(Dis+1e-6).^alpha;
        P = XF*diag(Dis)*X'*pinv(X*diag(Dis)*X'+1e-9*eye(size(X,1)));       
        P_patch = P*im_l_patch;        
      
        % obtain the HR patch
        Img_flag = zeros(patch_size-1,patch_size-1);
        Img_flag(1:2:end,1:2:end) = -1;
        Img(find(Img_flag==-1)) = im_l_patch;
        sub_flag(find(Img_flag==-1)) = 1;
        if center_flag == 1
            Img_flag([1:impat_pixel/2 end-(impat_pixel/2-1):end],:) = -1;Img_flag(:,[1:impat_pixel/2 end-(impat_pixel/2-1):end]) = -1;
        end
        Img(find(Img_flag~=-1)) = P_patch;
        sub_flag(find(Img_flag~=-1)) = 1;
        
        % integrate all the LR patch
        Img = reshape(Img,patch_size-1,patch_size-1);
        Img_SUM(BlockSize(1):BlockSize(2),BlockSize(3):BlockSize(4))      = Img_SUM(BlockSize(1):BlockSize(2),BlockSize(3):BlockSize(4))+Img;
        overlap_FLAG(BlockSize(1):BlockSize(2),BlockSize(3):BlockSize(4)) = overlap_FLAG(BlockSize(1):BlockSize(2),BlockSize(3):BlockSize(4))+sub_flag;
    end
end
%  averaging pixel values in the overlapping regions
im_SR = Img_SUM./overlap_FLAG;
im_SR = uint8(im_SR);
