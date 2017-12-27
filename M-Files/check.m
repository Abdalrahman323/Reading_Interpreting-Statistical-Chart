function [y] = check(im)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes he
[h,w]=size(im);

im=rgb2gray(im);
im=imbinarize(im,0.97);
im=not(im); 
se=strel('line',4,90);
im=imerode(im,se);
se=strel('line',4,0);
im=imerode(im,se);
im=imcrop(im,[10,10,w-10,h-15]);
%figure,imshow(im);
%ythd
[h w]=size(im);
maxw=0;
maxh=0;
k=0;
for i=1:w
    for j=1:h
        if(im(j,i)==1)
            k=k+1;
        end
        
    end
    if(k>maxh)
        maxh=k;
    end
    k=0;
end
k=0;
for j=1:h
    for i=1:w
        if(im(j,i)==1)
            k=k+1;
        end
        
    end
    if(k>maxw)
        maxw=k;
    end
    k=0;
end
%maxh
%maxw
%ytr
if(maxh>maxw)
    y='vertical';
else
    y='horizontal';
end
end

