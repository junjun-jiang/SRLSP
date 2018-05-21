function subImg = ExtrSubImg(img,center_flag,impat_pixel)

img(1:2:end,1:2:end) = -1;
if center_flag == 1
    img([1:impat_pixel/2 end-(impat_pixel/2-1):end],:) = -1;img(:,[1:impat_pixel/2 end-(impat_pixel/2-1):end]) = -1;
end
index = find(img~=-1);
subImg = img(index);