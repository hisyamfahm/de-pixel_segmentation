function [image,y,x,file] = open_pic()
%Memilih citra image grayscale yang akan digunakan
[file, folder]=uigetfile(...
    {'*.gif;','File Image(*.gif;)';'*.png;','File Image(*.png;)';...
     '*.bmp;','File Image(*.bmp;)';'*.tif;','File Image(*.tif;)';...
     '*.jpg;','File Image(*.jpg;)';'*.*','Semua File(*.*)'}, 'Pilih Gambar',...
     'C:\Users\hisyam_fahm\Documents\MATLAB\TAq');
if file ~= 0
    img = [folder file];
    image = double(imread(img));
%     address = fullfile(folder,file);
    
    %Membedakan citra 2D atau 3D
    if length(size(image))== 3
        image = image/255;
        image = rgb2gray(image);   
        image = round(image*255);
    end
    %Mendapatkan image input
%     image = imread([folder '/' file]);
    [y,x]=size(image);
else
    file = 0;
end