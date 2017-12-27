function varargout = Mil_1(varargin)
% MIL_1 MATLAB code for Mil_1.fig
%      MIL_1, by itself, creates a new MIL_1 or raises the existing
%      singleton*.
%
%      H = MIL_1 returns the handle to a new MIL_1 or the handle to
%      the existing singleton*.
%
%      MIL_1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MIL_1.M with the given input arguments.
%
%      MIL_1('Property','Value',...) creates a new MIL_1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Mil_1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Mil_1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Mil_1

% Last Modified by GUIDE v2.5 13-Dec-2017 17:06:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Mil_1_OpeningFcn, ...
                   'gui_OutputFcn',  @Mil_1_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Mil_1 is made visible.
function Mil_1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Mil_1 (see VARARGIN)

% Choose default command line output for Mil_1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Mil_1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Mil_1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Open_Image.
function Open_Image_Callback(hObject, eventdata, handles)
% hObject    handle to Open_Image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
warning('off','all')
warning
[filename pathname] = uigetfile({'*.jpg;*.png'},'File Selector');
I  = imread(filename);
handles.Image=I;
bw_I = rgb2gray(I);
BW = edge(bw_I,'canny');
[centers, radii] = imfindcircles(I,[40 190], 'ObjectPolarity','dark', ...
          'Sensitivity',0.95);
[centers2, radii] = imfindcircles(I,[40 190], 'ObjectPolarity','bright', ...
          'Sensitivity',0.95);    
     cla(handles.axes1,'reset');
axes(handles.axes1);
imshow(I);
%viscircles(handles.axes1,centers,radii);
centers;
radii;
c=length(centers);
c2=length(centers2);

if(c==0&&c2==0)
    set(handles.Type,'string','Bar Chart');
else
   set(handles.Type,'string','Pie Chart');
end
guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
function Type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
BW=handles.Image;

original_img=handles.Image;
i=handles.Image;

[H W L]=size(i);
if(L>1)
i=rgb2gray(i);
end

i=imbinarize(i,0.95);
i=not(i);

se=strel('line',6,90);
i=imerode(i,se);

se=strel('line',6,0);
i=imerode(i,se);
    se=strel('rectangle',[12 30]);
   i=imdilate(i,se);


eroded_img=i;
%%%%%%%%%%%%%%%%%%
%figure,imshow(eroded_img);
%%%%%%%%%%%%%%%%%%
k=crop_box(eroded_img,original_img);
axes(handles.axes2);
imshow(k);
handles.orig=original_img;
handles.Image=k;
guidata(hObject, handles);
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in CutBox.
function CutBox_Callback(hObject, eventdata, handles)
% hObject    handle to CutBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%[filename pathname] = uigetfile({'*.jpg;*.png'},'File Selector');
im  = handles.Image;
I=handles.orig;
I=imresize(I,[750 1000]);

figure,imshow(I);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% if else according to the graph type
original_image=handles.orig;

txt_type = get(handles.Type, 'String')
if(strcmp(txt_type, 'Bar Chart')==1)
mat=solve_bar(original_image);
else
mat=solve_pie(original_image);
end

or=im;
%figure,imshow(im);

l=check(im);
l

num=0;
x=1;



if(strcmp(l,'vertical'))
    im=rgb2gray(im);

    im=imbinarize(im,0.97);
    im=not(im);


    se=strel('line',4,90);

    im=imerode(im,se);

    se=strel('line',4,0);
    im=imerode(im,se);
    [h,w]=size(im);
      im=imcrop(im,[10,10,w-10,h-15]);
    %  figure,imshow(im);
    % gsd
    white_p_x=1;
    br=0;
    E=im;
    [H W]=size(im);

    for i=1:W
      for j=1:H

           if E(j,i)==1
               if E(j,i+2)==1
                white_p_x=i+2;
               elseif E(j,i+1)==1
                   white_p_x=i+1;
               else
                   white_p_x=i;
               end
               br=1;
               break;
           end

      end
      if br==1
          break;
      end

    end
    minx=1;
    miny=1;
    h=0;
    first=0;
    white=0;
     % to count the number of the subplots

     for i=1:H
        if (E(i,white_p_x)==1)
          if (first==0)
          miny=i-10; first =1; white=1;
          else
             h=h+1; 
          end

        else if (E(i,white_p_x)==0)
           if (white==1)
            white=0; first=0;
            num=num+1;
            h=0;

           end
        end
    end
     end
   
    for i=1:H
        if (E(i,white_p_x)==1)
          if (first==0)
          miny=i-10; first =1; white=1;
          else
             h=h+1; 
          end

        else if (E(i,white_p_x)==0)
           if (white==1)
            white=0; first=0;
            res=imcrop(or,[1,miny+10,W,h+20]);
          
            s(x)=subplot(num,1,x);
            values(x)=get_seg_val(res,mat);
            
             res=imresize(res,[ floor(750/num) 350]);
           imshow(res);
            x=x+1; 
            
        
            h=0;

           end
        end
    end
    end
    for i=1:num
        tmp=values(i);
    t=title(s(i),num2str(tmp));

   pos = get ( t, 'position' );
   new_position=pos;
   new_position(1)=new_position(1)+250;
   new_position(2)=new_position(2)+95;
 
    set(t,'Position',new_position);
    end
    
else
    im=rgb2gray(im);

    im=imbinarize(im,0.93);
    im=not(im);


    se=strel('line',6,90);

    im=imerode(im,se);

    se=strel('line',6,0);
    im=imerode(im,se);


    white_p_x=1;
    br=0;
    E=im;
    [H W]=size(im);

    for j=1:H
      for i=1:W

           if E(j,i)==1
               if E(j+2,i)==1
                white_p_x=j+2;
               elseif E(j+1,i)==1
                   white_p_x=j+1;
               else
                   white_p_x=j;
               end
               br=1;
               break;
           end

      end
      if br==1
          break;
      end

    end
    %white_p_x
    minx=1;
    miny=1;
    h=0;
    first=0;
    white=0;
  
     
     % to count the number of the subplots
     for i=1:W
        if (E(white_p_x,i)==1)
            
          if (first==0)
              minx=i-10; first =1; white=1;
          end

        else if (E(white_p_x,i)==0)
           l=W;
           if (white==1)
               for k=i:W
                   if (E(white_p_x,k)==1)
                       l=k-1;
                       break;
                   end
               end
                white=0; first=0;
                num=num+1;
           end
        end
        end
     end
    
    for i=1:W
        if (E(white_p_x,i)==1)
            
          if (first==0)
              minx=i-10; first =1; white=1;
          end

        else if (E(white_p_x,i)==0)
           l=W;
           if (white==1)
               for k=i:W
                   if (E(white_p_x,k)==1)
                       l=k-1;
                       break;
                   end
               end
                white=0; first=0;
                res=imcrop(or,[minx,1,l-i+5,H]);
           % figure,imshow(res);
          
                 s(x)=subplot(1,num,x);
                 values(x)=get_seg_val(res,mat);
                   res=imresize(res,[100 floor(1000/num)]);
                 imshow(res);
     
                x=x+1;
               
           end
        end
        end
    end
    
    for i=1:num
        tmp=values(i);
   t= title(s(i),num2str(tmp));
   pos = get ( t, 'position' )
   new_position=pos;
   new_position(1)=new_position(1)+150;
   new_position(2)=new_position(2)+75;
 
    set(t,'Position',new_position)
    end
end
