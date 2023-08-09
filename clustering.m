function [view_group,group,Z] = clustering(Z,i,img_input)
    idx_active = find(Z(3,:,i)); %mengambil pusat cluster yang aktif saja
    img_input = double(img_input);
    range = zeros(size(img_input,1),size(img_input,2),length(idx_active));
        for j=1:length(idx_active)
            activeclass = Z(2,idx_active(j),i);
            %Perulangan untuk setiap intensitas piksel (0-255)
            %Menghitung jarak tiap intensitas ke tiap pusat cluster
            range(:,:,j) = abs(img_input-activeclass);
        end
        group = min(range,[],3);
        for l=1:length(idx_active)
            temp = range(:,:,l);
            temp(temp~=group)=255;
            temp(temp==group)=l;
            if length(find(temp==l))<=2
                center_1 = Z(2,idx_active(l),i);
                min_neighbor = 1000;
                new_label = 1;
                for k=1:length(idx_active)
                    if k~=l
                        center_2 = Z(2,idx_active(k),i);
                        neighbor = abs(center_1-center_2);
                        if min_neighbor>=neighbor
                            min_neighbor=neighbor;
                            new_label = k;
                        end
                    end
                end
                temp(temp==group)=l;
                for kk=new_label:length(idx_active)-1
                    group(group==kk) = kk-1;
                end
                Z(3,l,i) = 0;
                Z(1,l,i) = 0.5*rand;
            end
            range(:,:,l) = temp;
        end
        
        group = min(range,[],3);
        g_max = max(max(group));
        view_group = uint8(((group-1).*255)./(g_max-1));
        group = uint8(group);