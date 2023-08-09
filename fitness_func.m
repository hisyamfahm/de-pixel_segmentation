function ps = fitness_func(R,image,idx_active,i,group)
[y,x] = size(image);
% g_max = max(max(group));
temp = -1*ones(y,x);
% for i=1:pop_size
    idx_active = find(R(3,:,i));
    ps = 0;
%     bar1 = waitbar(0, 'Processing each kromosom...');
    for j=1:length(idx_active)
%         waitbar(j/length(idx_active));
        activecluster = R(2,idx_active(j),i);
        %Perulangan untuk setiap intensitas piksel (0-255)
        temp(group==j)=image(group==j);
        temp = temp+1;
        [r,c,value] = find(temp);
        value = value-1;
        n = length(value);
        bar2 = waitbar(0, 'Processing each cluster center...');
%         kelas = image;
        for g=1:n
%             kelas(cluster~=uint8(((cluster-1)*255)/(g-1)))=0;
            s = 0;
            waitbar(g/n);
%=========================================================================
%             for u=1:y
%                 for v=1:x
%                     ds = PS_dis(kelas(u,v),image,activecluster);
%                     de = round(sqrt(double((kelas(u,v)-activecluster)^2)));
%                     min_dis = 1000;
%                     for k=j:length(idx_active)
%                         dist = sqrt((R(2,idx_active(k),i)-activecluster)^2);
%                         if min_dis>dist
%                             min_dis = dist;
%                         end
%                     end
%                     s = s+((ds*de)/min_dis);
%                 end
%             end
%=========================================================================
            ds = PS_dis(value(g),value,activecluster);
            de = round(sqrt(double((value(g)-activecluster)^2)));
            min_dis = 1000;
            for k=j:length(idx_active)
                dist = sqrt((R(2,idx_active(k),i)-activecluster)^2);
                if min_dis>dist
                    min_dis = dist;
                end
            end
            s = s+((ds*de)/min_dis);
            s = s/n;
            ps = ps+s;
        end
        close(bar2);
    end
%     close(bar1);
    ps = ps/length(idx_active);
    ps = 1/(ps+0.0002);
% end