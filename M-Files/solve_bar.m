function [ mat ] = solve_bar( img )

I=img;
%I=imread('2.png');
I_original=I;
I=imresize(I,[750 1000]);
orig=I;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%% resize the image
II=imresize(I_original,[1000 750]);
II=imcrop(II,[2,3,120, 500]);
rotII = imrotate(II,0,'crop');
bw_II = rgb2gray(rotII);

BW = not(imbinarize(bw_II,0.9));
BW = edge(BW,'canny');
%figure,imshow(BW);

[H,T,R] = hough(BW);

P  = houghpeaks(H,4,'threshold',ceil(0.2*max(H(:))));
x = T(P(:,2)); y = R(P(:,1));
% Find lines and plot them
lines = houghlines(BW,T,R,P,'FillGap',2,'MinLength',50);
%figure, imshow(rotII), hold on;
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
 
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end

xy=xy_long;
Y_vertical_bar=xy(1,2);
% highlight the longest line segment
%figure,imshow(II),hold on;
%plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','green');

digit_box=imcrop(II,[xy(1,1)-59,xy(1,2)-27,50, 52]);

%digit_box=imresize(digit_box,[1000 750]);
%%%%
%figure,imshow(digit_box);
%%%%
digit_box=rgb2gray(digit_box);
digit_box=imbinarize(digit_box,0.57);
digit_box=not(digit_box);

l=digit_box;
%figure,imshow(l);
label=bwlabel(l);

% to pares the str to int from left to write
factor=1;
cal_val=0;
n=max(max(label));

for i=1:n-1
factor=factor*10;
end


for j=1:n
    [row,col]=find(label==j);
    len=max(row)-min(row)+20;
    breadth=max(col)-min(col)+20;
    target=(zeros([len breadth]));
    sy=min(col)-10;
    sx=min(row)-10;
    for i=1:size(row,1)
        x=row(i,1)-sx;
        y=col(i,1)-sy;
        target(x,y)=l(row(i,1),col(i,1));
        
    end
    target=imbinarize(target);
     di=final_fourier(target);
     di=di*factor;
     cal_val=cal_val+di;
     factor=factor/10;
   % figure,imshow(target);
    
end

X=cal_val;

%t = ocr(digit_box, 'CharacterSet', '0123456789', 'TextLayout','Block');
%X = str2double(t.Text)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%t = ocr(digit_box, 'CharacterSet', '0123456789', 'TextLayout','Block');
%X = str2double(t.Text)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[H W L]=size(I);
if(L>1)
I=rgb2gray(I);
end
I = medfilt2(I,[10 10]);
i=imbinarize(I,0.93);

i=not(i);

se=strel('square',55);
i=imerode(i,se);
%%%%%%%%%%%%%%%%%
%figure,imshow(i);
%%%%%%%%%%%%%%%%%

E=i;
cnt=0;

for i=1:H
    for j=1:W
        if(E(i,j)==1)
            cnt=cnt+1;
        end
    end
    if(cnt==W)
    E(i,:)=0;
    end
          cnt =0;     
end
i=E;

%figure,imshow(i);

stats = regionprops(i,'BoundingBox');
hold on;
k=1;
for i = 1:numel(stats)
xmin=ceil(stats(i).BoundingBox(1));
ymin=ceil(stats(i).BoundingBox(2));
width  =stats(i).BoundingBox(3);
height =stats(i).BoundingBox(4);
test_borders=xmin+width-1;

if(xmin~=1 &&ymin~=1&&test_borders~=W)
  
out=imcrop(orig,[xmin,ymin,width,height]);
  bottom=ymin+height;
    vertical_bar=bottom-Y_vertical_bar+1; % height of the vertical bar
   values(k,1)= ceil((height/vertical_bar)*X);
   values(k,2)=mean(mean(out(:,:,1)));  % get the avg of the red channel
   values(k,3)=mean(mean(out(:,:,2)));
   values(k,4)=mean(mean(out(:,:,3)));
    k=k+1;
%%%%%%%%%%%%%%%%%
 %figure,imshow(out);
%%%%%%%%%%%%%%%%%
end
end

mat=values
end

