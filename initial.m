function Z = initial(pop_size,Cmax)
Z = zeros(3,Cmax,10);
%Perulangan untuk tiap kromosom pada populasi
for i=1:pop_size
    %Inisialisasi secara acak activation threshold setiap pusat cluster
    Z(1,:,i) = rand(1,Cmax);
%     Z(1,:,i) = 0.5+(0.5*rand(1,Cmax));
    %Perulangan untuk setiap pusat cluster pada kromosom
    for j=1:Cmax
        temp = double(255.*rand(1));
        [r,c,v] = find(Z(2,:,i));
        %Cek apakah pusat cluster sudah digunakan
        while v~=0
            %Inisialisasi pusat cluster secara acak
            temp = double(255.*rand(1));
            [r,c,v] = find(Z(2,:,i)==temp);
        end
        Z(2,j,i) = temp;
    end
    %inisialisasi pusat cluster aktif
    Z = cek_aktif(Z,Cmax,i);
    while length(find(Z(3,:,i)))<=2
        Z(1,:,i) = rand(1,Cmax);
        Z = cek_aktif(Z,Cmax,i);
    end
end