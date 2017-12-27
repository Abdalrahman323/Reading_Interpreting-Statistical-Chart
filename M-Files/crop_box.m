function [ box ] = crop_box( eroded_img , orignal )
%UNTITLED5 Summary of this function goes here

img=eroded_img;

bw=img;
%imshow(bw);
% find both black and white regions
stats = regionprops(bw,'BoundingBox');
% show the image and draw the detected rectangles on it
%figure,imshow(bw); 
hold on;
smallest_Area=10000000;
for i = 1:numel(stats)
% xmin=ceil(stats(i).BoundingBox(1));
% ymin=ceil(stats(i).BoundingBox(2));
width  =stats(i).BoundingBox(3);
height =stats(i).BoundingBox(4);
if(width*height<smallest_Area)
  smallest_Area=width*height;
end

end
% this loop the cut the box get minx ,maxx, miny ,maxy
minx=10000;
maxx=-1;
miny=10000;
maxy=-1;
cnt=0;
for i = 1:numel(stats)
cur_xmin=ceil(stats(i).BoundingBox(1));
cur_ymin=ceil(stats(i).BoundingBox(2));
cur_width=stats(i).BoundingBox(3);
cur_height=stats(i).BoundingBox(4);

cur_maxx=cur_xmin+cur_width;
cur_maxy=cur_ymin+cur_height;
%z=abs((cur_width*cur_height)-smallest_Area)
if(abs((cur_width*cur_height)-smallest_Area)<=170)  % if it nearly a square 
    cnt=cnt+1;
    if (cur_xmin<minx)
        minx=cur_xmin;
    end
    if(cur_ymin<miny)
        miny=cur_ymin;
    end
    if(cur_maxx>maxx)
        maxx=cur_maxx;
    end
    if(cur_maxy>maxy)
        maxy=cur_maxy;
    end
end
end

o=imcrop(orignal,[minx-10,miny-10,maxx-minx+1+300,maxy-miny+1+30]);

  %smallest_Area
  %cnt
box=o;


end

