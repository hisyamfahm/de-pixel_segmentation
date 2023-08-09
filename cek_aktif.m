function Z = cek_aktif(Z,Cmax,i)
temp = zeros(1,Cmax);
%Cek apakah activation threshold lebih dari threshold(0.5)
temp(Z(1,:,i)>0.5)=1; %jika ya tandai sebagai pusat cluster yang aktif
Z(3,:,i)=logical(temp);
