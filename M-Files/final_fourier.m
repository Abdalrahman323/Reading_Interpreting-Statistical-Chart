function [ digit_val ] = final_fourier( digit )

%%%%%%%%%%%%%%%%
%box_digit=
%%%%%%%%%%%%%%%%

t0=digit;
%t0=imread('0_1.bmp');
t0=im2bw(t0);
t0=imresize(t0,[200,200]);
%%%%%%%%%%%
%figure,imshow(t0);
%%%%%%%%%%%
t0=centerobject(t0);
FD_t0= gfd(t0,3,12);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 0
im_0=imread('0_f.jpg');
im_0=im2bw(im_0);
im_0=centerobject(im_0);
FD_0 = gfd(im_0,3,12);
%%%%%%%%%%%%%%%%%%%%%%
im_0_m=imread('0_my.jpg');
im_0_m=im2bw(im_0_m);
im_0_m=centerobject(im_0_m);
FD_0_m = gfd(im_0_m,3,12);
%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  1
im_1=imread('1.bmp');
im_1=im2bw(im_1);
im_1=centerobject(im_1);
FD_1 = gfd(im_1,3,12);
%%%%%%%%%%%%%%%%%%%%%%%
im_1_m=imread('1.bmp');
im_1_m=im2bw(im_1_m);
im_1_m=centerobject(im_1_m);
FD_1_m = gfd(im_1_m,3,12);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 2
im_2=imread('2.bmp');
im_2=im2bw(im_2);
im_2=centerobject(im_2);
FD_2 = gfd(im_2,3,12);
%%%%%%%%%%%%%%%%%%%%%%
im_2_m=imread('2_my.jpg');
im_2_m=im2bw(im_2_m);
im_2_m=centerobject(im_2_m);
FD_2_m = gfd(im_2_m,3,12);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 3
im_3=imread('3.bmp');
im_3=im2bw(im_3);
im_3=centerobject(im_3);
FD_3 = gfd(im_3,3,12);
%%%%%%%%%%%%%%%%%%%%%%
im_3_m=imread('3_my.jpg');
im_3_m=im2bw(im_3_m);
im_3_m=centerobject(im_3_m);
FD_3_m = gfd(im_3_m,3,12);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 4
%%%%%%%%%%%%%%%%%
im_4=imread('4.bmp');
im_4=im2bw(im_4);
im_4=centerobject(im_4);
FD_4 = gfd(im_4,3,12);
%%%%%%%%%%%%%%%%%%%%%%
im_4_m=imread('4_my.jpg');
im_4_m=im2bw(im_4_m);
im_4_m=centerobject(im_4_m);
FD_4_m = gfd(im_4_m,3,12);
%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 5
im_5=imread('5_f.jpg');
im_5=im2bw(im_5);
im_5=centerobject(im_5);
FD_5 = gfd(im_5,3,12);
%%%%%%%%%%%%%%%%%%%%%%
im_5_m=imread('5_f2.jpg');
im_5_m=im2bw(im_5_m);
im_5_m=centerobject(im_5_m);
FD_5_m = gfd(im_5_m,3,12);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 6
%%%%%%%%%%%%%%%%%
im_6=imread('6_f.jpg');
im_6=im2bw(im_6);
im_6=centerobject(im_6);
FD_6 = gfd(im_6,3,12);
%%%%%%%%%%%%%%%%%%%%%%
im_6_m=imread('6_my.jpg');
im_6_m=im2bw(im_6_m);
im_6_m=centerobject(im_6_m);
FD_6_m = gfd(im_6_m,3,12);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 7
%%%%%%%%%%%%%%%%%
im_7=imread('7.bmp');
im_7=im2bw(im_7);
im_7=centerobject(im_7);
FD_7 = gfd(im_7,3,12);
%%%%%%%%%%%%%%%%%%%%%%
im_7_m=imread('7_my.jpg');
im_7_m=im2bw(im_7_m);
im_7_m=centerobject(im_7_m);
FD_7_m = gfd(im_7_m,3,12);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 8
%%%%%%%%%%%%%%%%%
im_8=imread('8.bmp');
im_8=im2bw(im_8);
im_8=centerobject(im_8);
FD_8 = gfd(im_8,3,12);
%%%%%%%%%%%%%%%%%%%%%%
im_8_m=imread('8_my.jpg');
im_8_m=im2bw(im_8_m);
im_8_m=centerobject(im_8_m);
FD_8_m = gfd(im_8_m,3,12);
%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
im_9=imread('9.bmp');
im_9=im2bw(im_9);
im_9=centerobject(im_9);
FD_9 = gfd(im_9,3,12);
%%%%%%%%%%%%%%%%%%%%%%
im_9_m=imread('9_my.jpg');
im_9_m=im2bw(im_9_m);
im_9_m=centerobject(im_9_m);
FD_9_m = gfd(im_9_m,3,12);
%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%get cityblock distance between all images
dist = pdist([FD_0,FD_0_m,FD_1,FD_1_m,FD_2,FD_2_m,FD_3,FD_3_m,FD_4,FD_4_m,FD_5,FD_5_m,FD_6,FD_6_m,FD_7,FD_7_m,FD_8,FD_8_m,FD_9,FD_9_m,FD_t0]','cityblock');
dist_sf = squareform(dist);
min_ind=-1;
min_dis=9999999999;

for i=1:20
dis=dist_sf(i,21);
  if(dis<min_dis)
  min_dis=dis;
  min_ind=i;
  end
end
ans_=-1;
if(1<=min_ind&&min_ind<=2)
    ans_=0;
elseif(3<=min_ind&&min_ind<=4)
    ans_=1;
elseif(5<=min_ind&&min_ind<=6)
    ans_=2;
elseif(7<=min_ind&&min_ind<=8)
    ans_=3;
elseif(9<=min_ind&&min_ind<=10)
    ans_=4;
elseif(11<=min_ind&&min_ind<=12)
    ans_=5;
elseif(13<=min_ind&&min_ind<=14)
    ans_=6;
elseif(15<=min_ind&&min_ind<=16)
    ans_=7;
elseif(17<=min_ind&&min_ind<=18)
    ans_=8;
elseif(19<=min_ind&&min_ind<=20)
    ans_=9;
end

digit_val=ans_;


end

