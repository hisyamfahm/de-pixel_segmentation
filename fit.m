function ps = fit(img_input,group,center)
    [y,x] = size(img_input);
    group = reshape(group,y,x);
    ps = 0;
    for j=1:length(center)
        temp = -1*ones(y,x);
        temp(group==j) = img_input(group==j);
        temp = temp+1;
        [r,c,value] = find(temp);
        value = value-1;
        mi = min(value);
        ma = max(value);
        s = 0;
        val = mi:ma;
        n = length(value);
        range = abs(center - center(j));
        range(j) = 1000;
        min_dis = min(range);
        for g = mi:ma
            nn = length(find(value==g));
            ds = PS_dis(g,val,center(j));
            de = abs(double(g-center(j)));
            
%             min_dis = 1000;
%             for k=1:length(center)
%                 if k~=j
%                     range = sqrt((center(k)-center(j))^2);
%                 else
%                     continue;
%                 end
%                 if min_dis>range
%                     min_dis = range;
%                 end
%             end
            s = s+((ds*de)/min_dis)*nn;
        end
        s = s/n;
        ps = ps+s;
    end
    ps = ps/length(center);