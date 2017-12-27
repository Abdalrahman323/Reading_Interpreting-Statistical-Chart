function [ val ] = get_seg_val( segment ,mat )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
ori=segment;
i=ori;
i=rgb2gray(i);
i=imbinarize(i,0.93);
i=not(i);

se=strel('line',5,90);
i=imerode(i,se);

se=strel('line',5,0);
i=imerode(i,se);
%%%%%%%%%%%%%%%%%%%%
%figure,imshow(i);
%%%%%%%%%%%%%%%%%%%%%
stats = regionprops(i,'BoundingBox');
hold on;
for i = 1:1
xmin=ceil(stats(i).BoundingBox(1));
ymin=ceil(stats(i).BoundingBox(2));
width  =stats(i).BoundingBox(3);
height =stats(i).BoundingBox(4);

out=imcrop(ori,[xmin,ymin,width,height]);
 
%%%%%%%%%%%%%%%%%
 %figure,imshow(out);
%%%%%%%%%%%%%%%%%

end

    red=mean(mean(out(:,:,1)));  % get the avg of the red channel
    green=mean(mean(out(:,:,2)));
    blue=mean(mean(out(:,:,3)));
    
  [H,W]=size(mat);
  minn=9999999;
  
  for i=1:H
     m_r=mat(i,2);
     m_g=mat(i,3);
     m_b=mat(i,4);
     x= (red-m_r)*(red-m_r)+(green-m_g)*(green-m_g)+(blue-m_b)*(blue-m_b);
%     x=sqrt(x);
     if(x<minn)
     minn=x;
     cur_val=mat(i,1);
     end
  
  end
  
 val= cur_val;
  
end

