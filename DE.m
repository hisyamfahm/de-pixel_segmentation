clear all;
clc;
close all;
%Memilih citra image grayscale yang akan digunakan
% [image,y,x,file]=open_pic();

[file, folder]=uigetfile(...
    {'*.gif;','File Image(*.gif;)';'*.png;','File Image(*.png;)';...
     '*.bmp;','File Image(*.bmp;)';'*.tif;','File Image(*.tif;)';...
     '*.jpg;','File Image(*.jpg;)';'*.*','Semua File(*.*)'}, 'Pilih Gambar',...
     'C:\Users\hisyam_fahm\Documents\MATLAB\TAq');
if file ~= 0
    img = [folder file];
    img_input = double(imread(img));
%     address = fullfile(folder,file);
    
    %Membedakan citra 2D atau 3D
    if length(size(img_input))== 3
        img_input = img_input/255;
        img_input = rgb2gray(img_input);   
        img_input = round(img_input*255);
    end
    %Mendapatkan image input
end
h = fspecial('gaussian');
img_input = uint8(imfilter(img_input, h));
imshow(img_input);
testing(:,:) = [0 0 0 1 2 1 2 1 2 0 1 2];
% testing = ['' '' '' 'PS_DE' 'PS_FCM' 'DB_DE' 'DB_FCM' 'D_DE' 'D_FCM'];
% Cmax = 3;
% pop_size = 10;
% t_max = 10;
shift_c = 5:5:15;
shift_pop = 10:10:30;
shift_t = 10:10:30;
cr_min = 0.5;
cr_max = 1;
% for loop=1:20
for idx_c=1:length(shift_c)
    Cmax = shift_c(idx_c)
    for idx_pop=1:length(shift_pop)
        pop_size = shift_pop(idx_pop)
        for idx_t=1:length(shift_t)
            t_max = shift_t(idx_t)
tic
%=======================Tahap 1: Inisialisasi kromosom=====================
Z = initial(pop_size,Cmax);
%=======================Tahap 2: Clusterisasi==============================
%Perulangan untuk tiap kromosom pada populasi
for i=1:pop_size
    [class,group,Z] = clustering(Z,i,img_input);
    Z = cek_aktif(Z,Cmax,i);
%     figure; imshow(class);
end
%=======================Tahap 3: Operasi genetik===========================
Y = Z;
R = zeros(3,Cmax,pop_size);
F = 0.5*(1+rand(1));
for t=1:t_max
    %==============================Mutasi==================================
    Cr = cr_max-(cr_max-cr_min)*(t/t_max);
    r1 = ceil(pop_size.*rand(1));
    r2 = ceil(pop_size.*rand(1));
    while r2==r1
        r2 = ceil(pop_size.*rand(1));
    end
    r3 = ceil(pop_size.*rand(1));
    while r3==r2 || r3==r1
        r3 = ceil(pop_size.*rand(1));
    end
    %============================Crossover=================================
    for i=1:pop_size
        for j=1:Cmax
            Y(1,j,i) = abs(Z(1,j,r1)+F*(Z(1,j,r2)-Z(1,j,r3)));
            if rand(1)<=Cr
                R(:,j,i) = Y(:,j,i);
            else
                R(:,j,i) = Z(:,j,i);
            end
        end
        R = cek_aktif(R,Cmax,i);
        while length(find(R(3,:,i)))<=2
            r1 = ceil(pop_size.*rand(1));
            r2 = ceil(pop_size.*rand(1));
            while r2==r1
                r2 = ceil(pop_size.*rand(1));
            end
            r3 = ceil(pop_size.*rand(1));
            while r3==r2 || r3==r1
                r3 = ceil(pop_size.*rand(1));
            end
            for j=1:Cmax
                Y(1,j,i) = abs(Z(1,j,r1)+F*(Z(1,j,r2)-Z(1,j,r3)));
                if rand(1)<=Cr
                    R(:,j,i) = Y(:,j,i);
                else
                    R(:,j,i) = Z(:,j,i);
                end
            end
            R = cek_aktif(R,Cmax,i);
        end
    end
    for i=1:pop_size
            [class,group,R] = clustering(R,i,img_input);
            R = cek_aktif(R,Cmax,i);
    end
%     figure; imshow(class);
    for i=1:pop_size
        ps1 = fit_de(Z,img_input,i,group);
        ps2 = fit_de(R,img_input,i,group);
        if ps1<=ps2
            Z(:,:,i) = R(:,:,i);
        end
    end
end
ff = -1;
best = 1;
for i=1:pop_size
    ps = fit_de(Z,img_input,i,group);
    if ps>=ff && length(find(Z(3,:,i)))>2
        ff = ps;
        best = i;
    end
end
kromosom = Z(:,:,best);
toc
kromosom = cek_aktif(kromosom,Cmax,1);
[class,group1,kromosom] = clustering(kromosom,1,img_input);
% u1 = double(u1(:)');
time1 = toc;
group1 = double(group1(:)');
center1 = kromosom(2,:,1);
center1(kromosom(3,:,1)==0)=0;
[r,c,center1] = find(center1);
ps1 = fit(img_input,group1,center1)/10;
db1 = davies(img_input,group1,center1)/10;
d1 = dunn(img_input,group1,center1);
% figure; imshow(class);
tic
Cfcm = length(center1);
[center2,U,obj_fcn] = fcm(double(img_input(:)),Cfcm);
center2 = center2';
u2 = max(U);
[m,n] = size(U);
clusters = zeros(m,n);
for i=1:Cfcm
    clusters(i,U(i,:) == u2) = i;
end
group2 = max(clusters,[],1);
result = uint8(((group2-1)*255)/(Cfcm-1));
[y,x] = size(img_input);
result = reshape(result,y,x);
% imshow(result);
ps2 = fit(img_input,group2,center2);
db2 = davies(img_input,group2,center2);
d2 = dunn(img_input,group2,center2);
[pathstr, file_name] = fileparts(img);
toc
time2 = toc;
testing = vertcat(testing, [Cmax pop_size t_max ps1 ps2 db1 db2 d1 d2 length(center1) time1 time2]);
% xlswrite(['hasil\',file_name,'_cmax',num2str(Cmax),'_pop',num2str(pop_size),'_t',num2str(t_max)],kromosom,'Sheet1');
% xlswrite(['hasil\',file_name,'_cmax',num2str(Cmax),'_pop',num2str(pop_size),'_t',num2str(t_max)],ps1,'Sheet2','B2');
% xlswrite(['hasil\',file_name,'_cmax',num2str(Cmax),'_pop',num2str(pop_size),'_t',num2str(t_max)],ps2,'Sheet2','C2');
% xlswrite(['hasil\',file_name,'_cmax',num2str(Cmax),'_pop',num2str(pop_size),'_t',num2str(t_max)],db1,'Sheet2','D2');
% xlswrite(['hasil\',file_name,'_cmax',num2str(Cmax),'_pop',num2str(pop_size),'_t',num2str(t_max)],db2,'Sheet2','B3');
% xlswrite(['hasil\',file_name,'_cmax',num2str(Cmax),'_pop',num2str(pop_size),'_t',num2str(t_max)],d1,'Sheet2','C3');
% xlswrite(['hasil\',file_name,'_cmax',num2str(Cmax),'_pop',num2str(pop_size),'_t',num2str(t_max)],d2,'Sheet2','D3');
clear Cfcm Z pathstr r2 y best d1 r3 Cr c d2 j ps F db1 kromosom ps1 R db2 result m ps2 U clusters ff i n r obj_fcn r1 x;
        end
    end
end
% end
% xlswrite(['hasil\',file_name],testing,'Sheet1');
save(['hasil\',file_name,'_4.mat'],'testing');