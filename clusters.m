function [class,range,idx_active,group] = clusters(Z,i,img_input)
    idx_active = find(Z(3,:,i)); %mengambil pusat cluster yang aktif saja
    img_input = double(img_input);
    a = length(idx_active);
    range = zeros(size(img_input,1),size(img_input,2),a);
%     u = zeros(a,length(img_input(:)));
        for j=1:a
            activeclass = Z(2,idx_active(j),i);
            %Perulangan untuk setiap intensitas piksel (0-255)
            %Menghitung jarak tiap intensitas ke tiap pusat cluster
            range(:,:,j) = abs(img_input-activeclass);
%             temp = range(:,:,j);
%             u(j,:) = temp(:)';
        end
%         sum_u = sum(u,1);
        group = min(range,[],3);
        for l=1:a
            temp = range(:,:,l);
            temp(temp~=group)=255;
            temp(temp==group)=l;
            range(:,:,l) = temp;
%             if length(find(distance(:,:,j)<1000))>1
%                 r=min(find(distance(:,:,j)<1000));
%             end
%             u(l,:) = (u(l,:)./sum_u);
        end
%         u = max(u,[],1);
        group = min(range,[],3);
        g_max = max(max(group));
%         class = uint16(img_input);
        class = uint8(((group-1)*255)/(g_max-1));
        group = uint8(group);
%         class(:,:,1)=class;
%         class(:,:,2)=group;