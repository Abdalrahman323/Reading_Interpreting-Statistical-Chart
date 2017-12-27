function [ mat ] = solve_pie( img )
I=img;
%I=imread('6.png');
Orig=I;
II=I;

[H W L]=size(I);
if(L>1)
I=rgb2gray(I);
end

I=imbinarize(I);
%figure,imshow(I);title('after binarize');

% check if the image needed to be inverted after the binarization

black_pixels=0;
white_pixels=0;
for i=1:H
    for j=1:W
        if(I(i,j)==1)
            white_pixels=white_pixels+1;
        else
            black_pixels=black_pixels+1;
    end
    end
end

if(white_pixels>black_pixels)
 I=not(I);
end
%%%%%%%%%%
%figure,imshow(I);title('1 inverted correctly');
%%%%%%%%%%

% erode the letters and the lines 
se=strel('line',6,90);
I=imerode(I,se);

se=strel('line',6,0);
I=imerode(I,se);
se=strel('square',10);
I=imdilate(I,se);

%%%%%%%%%%%%%
%figure,imshow(I);title('after erode the lines of the letters');
%%%%%%%%%%%%%

% to detect the position of the circle (largest connected components after
% the latter enhancement
stats = regionprops(I,'BoundingBox');
max_area=-1;
Orig_edged=rgb2gray(Orig);
Orig_edged = medfilt2(Orig_edged,[4 4]);
Orig_edged=edge(Orig_edged,'sobel');
%%%%%%%%%%%%%
%figure,imshow(Orig_edged);title('Orig_edged sobel')
%%%%%%%%%%%%%


% get the pie circle largest connected component

for i = 1:numel(stats)
cir_xmin=ceil(stats(i).BoundingBox(1));
cir_ymin=ceil(stats(i).BoundingBox(2));
cir_width  =stats(i).BoundingBox(3);
cir_height =stats(i).BoundingBox(4);

area=cir_width*cir_height;
if(area>max_area)
 color_cir=imcrop(II,[cir_xmin-3,cir_ymin-3,cir_width+3,cir_height+3]);  % widen the cropped area to facilitate the process of edge 
 croped_edged_circle=imcrop(II,[cir_xmin,cir_ymin,cir_width,cir_height]);
 orig_color_circle=imcrop(II,[cir_xmin,cir_ymin,cir_width,cir_height]);
 max_area=area;
end

end
   
color_cir=rgb2gray(color_cir);
color_cir=edge(color_cir,'canny');
 final_edged_circle=color_cir;
 [redius,garbage]=size(croped_edged_circle);
 redius=redius/2;
 center=redius;
 %%%%%%%%%%%%%
 %color_cir=not(color_cir)
 %figure,imshow(color_cir);title('final_edged_circle');
 %%%%%%%%%%%%%
 
 
 z=final_edged_circle;
%  se=strel('sphere',4);
%   z=imdilate(z,se);
   
   se=strel('sphere',5);
   redius=redius-10;
   
 % z=imdilate(z,se);
%   se=strel('line',7,90);
%   z=imdilate(z,se);
%   se=strel('line',10,0);
  z=imdilate(z,se);
 z=not(z);
  [H W]=size(z);
 %%%%%%%%%%%%%%
 %figure,imshow(z);title('after sphere dilation and not');
 %%%%%%%%%%%%%%
 for i=1:H
     for j=1:W
       if z(i,j)==1
           dis=(i-center+3)*(i-center+3)+(j-center+3)*(j-center+3);
           dis=sqrt(dis);
           if(dis>redius)
           z(i,j)=0;
           end
     end
     end
 end
%%%%%%%%%%%%%%% 
% figure,imshow(z);title('after black any pixel outside the circle');
%%%%%%%%%%%%%%%%
%   se=strel('line',7,90)
%    z=imdilate(z,se);
     se=strel('sphere',2);
    z=imdilate(z,se);

%%%%%%%%%%%%%%%%%
%figure,imshow(z);
%%%%%%%%%%%%%%%%%


cnt_groups=20;
k=0;
%
%figure,imshow(orig_color_circle)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% labeling
num_sectors=0;
while(k<cnt_groups)
k=k+1;
    l = bwlabel(z,8);
freq_groups=zeros(1,500);
cnt_groups=0;
for i=1:H
    for j=1:W      
        x= l(i,j)+1 ; % as label give a number to each group starting from 0
        if freq_groups(x)==0
            cnt_groups=cnt_groups+1;
        end
        freq_groups(x)=freq_groups(x)+1;
    end
end

[B,I] = sort(freq_groups,'descend');

% I holds the orignal indexes corresponding to the newa sort

%  black any pixel not in the current group 
for i=1:H
    for j=1:W
        if(l(i,j)~=I(k)-1)
            l(i,j)=0;
        end
    end
end
black=0;
white=0;
first=1;
r=0;
g=0;
b=0;

    l=imfill(l,'holes');

for i=1:H
    for j=1:W
        if(l(i,j)==0)
            black=black+1;
        else
            white=white+1;
            if(first==1)
            r=orig_color_circle(i,j,1);
            g=orig_color_circle(i,j,2);
            b=orig_color_circle(i,j,3);
            end
             first=first+1;
            
        end
       
    end
end

if(abs(black-W*H)<=30) % to skip the background and any small area
 continue;
end
  

% stats=regionprops(l,'all');
% numel(stats)
% sector_xmin=stats(1).BoundingBox(1);
% sector_ymin=stats(1).BoundingBox(2);
% sector_w=stats(1).BoundingBox(3);
% sector_h=stats(1).BoundingBox(4);
% sector=imcrop(l,[sector_xmin,sector_ymin,sector_w,sector_h]);
% figure,imshow(sector);

%   se=strel('sphere',5);
%   l=imdilate(l,se);
%   se=strel('line',4,90);
%   l=imdilate(l,se);
white2=0;

for i=1:H
    for j=1:W
   
        if(l(i,j)==0)
        else
            white2=white2+1; % not used
        new_frame(i,j,1)=r;
        new_frame(i,j,2)=g;
        new_frame(i,j,3)=b;

        end
    end
end
        
num_sectors=num_sectors+1;
colors(num_sectors,1)=white;
colors(num_sectors,2)=r;
colors(num_sectors,3)=g;
colors(num_sectors,4)=b;

 
%figure,imshow(l); title('after remove (not used groups)');




min_x=1000;
max_x=-1;

% to detect minimum x and maximun x of the group 
for i=1:H
    for j=1:W
        if l(i,j)==I(k)-1
          if j<min_x
             min_x=j;
          end
           if j>max_x
             max_x=j;
          end
        
        end
    end
end

min_y=1000;
max_y=-1;

for i=1:W
    for j=1:H
        if l(j,i)==I(k)-1
          if j<min_y
             min_y=j;
          end
           if j>max_y
             max_y=j;
          end
        
        end
    end
end
      max_cnt_x=max_x-min_x+1;
      max_cnt_y=max_y-min_y+1;
   cropped = imcrop(orig_color_circle, [min_x min_y max_cnt_x max_cnt_y]);
 % figure,imshow(cropped);

end


[H,W,l]=size(orig_color_circle);
%figure,imshow(orig_color_circle);
cir_area=(H/2)*(H/2)*pi;


for k=1:num_sectors
    r=colors(k,2);
    g=colors(k,3);
    b=colors(k,4);
    num_pix=0;
    for i=1:H
      for j=1:W
         
          g_s=orig_color_circle(i,j,2);
          b_s=orig_color_circle(i,j,3);
          r_s=orig_color_circle(i,j,1);
          diff_r=abs(r_s-r);
          diff_g=abs(g_s-g);
          diff_b=abs(b_s-b);
          if((r_s==r)&&(g_s==g)&&(b_s==b))
              num_pix=num_pix+1;
          end
      end
      
    end
    tmp=colors(k,1);
    c=(num_pix/cir_area)*100
    w=(tmp/cir_area)*100
    colors(k,1)=max((num_pix/cir_area)*100,(tmp/cir_area)*100);
end
all_prob_before=sum(colors(:,1))
rest=100-all_prob_before;
add=rest/num_sectors;
for i=1:num_sectors
    colors(i,1)=colors(i,1)+add;
end
all_prob_after=sum(colors(:,1))
mat=colors
%figure,imshow(new_frame);

% [r,gar]=size(z)
% r=r/2;
% circle_area=pi*r*r;
% stats = regionprops(z,'all');
% all=0;
% for i = 1:numel(stats)
% % xmin=ceil(stats(i).BoundingBox(1));
% % ymin=ceil(stats(i).BoundingBox(2));
% % width  =stats(i).BoundingBox(3);
% % height =stats(i).BoundingBox(4);
% % out=imcrop(z,[xmin,ymin,width,height]);
% stats(i)
% area=stats(i).Area;
% (area/circle_area)*100
% all=all+(area/circle_area)*100;
% end
% all



