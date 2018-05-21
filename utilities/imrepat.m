function [ImgOut] = imrepat(img,num)

if num>0
    img = [img(1:num,:); img; img(end-num+1:end,:)];
    img = [img(:,1:num) img img(:,end-num+1:end)];
    ImgOut = img;
else
    num = -num;
    img = img(num+1:end-num,:);
    img = img(:,num+1:end-num);
    ImgOut = img;
end 