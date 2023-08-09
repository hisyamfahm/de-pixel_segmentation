function d = dunn(img_input,group,center)
    [y,x] = size(img_input);
    group = reshape(group,y,x);
    for i=1:length(center)
        temp = -1*ones(y,x);
        temp(group==i) = img_input(group==i);
%         temp = temp+1;
        value = temp(temp~=-1);
%         value = value-1;
        if length(find(value))~=0
            mi = min(value);
            ma = max(value);
            class = zeros(ma-mi+1,2);
            class(:,1) = mi:ma;
            class(:,2) = i;
            if i==min(group(:))
                intensity = class;
            else
                intensity = vertcat(intensity,class);
            end
        end
%         intensity(intensity(:,1)==value,2) = i;
    end
    min_distance = 1000;
    max_diameter = -1;
    for i=1:(length(center)-1)
        member_i = intensity(intensity(:,2)==i,1);
%         if i~=length(center)
            for j=(i+1):length(center)
                member_j = intensity(intensity(:,2)==j,1);
                range = zeros(size(member_i,1),1);
                if length(member_j)~=0
                    for k=1:size(member_i,1)
                        range(k) = min(abs(member_i(k)-member_j));
                    end
                end
                if min_distance>=min(range)
                    min_distance = min(range);
                end
            end
%         end
    end
    for i=1:length(center)
        member_i = intensity(intensity(:,2)==i,1);
        diameter = pdist(member_i);
        if max_diameter<=max(diameter)
            max_diameter = max(diameter);
        end
    end
    d = min_distance/max_diameter;