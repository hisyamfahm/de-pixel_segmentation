function ps = fit(R,image,i,group)
    [y,x] = size(image);
    idx_active = find(R(3,:,i));
    ps = 0;
    for j=1:length(idx_active)
        activecluster = R(2,idx_active(j),i);
        temp = -1*ones(y,x);
        temp(group==j) = image(group==j);
        temp = temp+1;
        [r,c,value] = find(temp);
        value = value-1;
        mi = min(value);
        ma = max(value);
        s = 0;
        val = mi:ma;
        n = length(value);
        for g = mi:ma
            nn = length(find(value==g));
            ds = PS_dis(g,val,activecluster);
            de = abs(double(g-activecluster));
            
            min_dis = 1000;
            for k=1:length(idx_active)
                if k~=j
                    dist = abs(R(2,idx_active(k),i)-activecluster);
                else
                    continue;
                end
                if min_dis>dist
                    min_dis = dist;
                end
            end
            s = s+((ds*de)/min_dis)*nn;
        end
        s = s/n;
        ps = ps+s;
    end
    ps = ps/length(idx_active);
    ps = 1/(ps+0.0002);