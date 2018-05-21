function Y = ExtrImg3D(X,BlockSize,center_flag,impat_pixel)

X1 = [];
tX = X(BlockSize(1):BlockSize(2),BlockSize(3):BlockSize(4),:);
for i = 1:size(tX,3)       
    X1 = [X1 ExtrSubImg(tX(:,:,i),center_flag,impat_pixel)];           
end
Y = double(X1); 