function db = davies(img_input,group,center)
    [y,x] = size(img_input);
    group = reshape(group,y,x);
    s = zeros(length(center),1);
    for j=1:length(center)
        temp = -1*ones(y,x);
        temp(group==j) = img_input(group==j);
        temp = temp+1;
        [r,c,value] = find(temp);
        value = value-1;
        mi = min(value);
        ma = max(value);
        total = 0;
        for g = mi:ma
            range = sum(g-center(j))*length(find(value==g));
            total = total+range;
        end
        s(j) = total/length(value);
    end
    R = zeros(length(center),1);
    for i=1:length(center)
        Ri = zeros(length(center),1);
        for j=1:length(center)
            if j==i
                Ri(j)=0;
            else
                Ri(j) = s(i)+s(j)/(abs(center(i)-center(j)));
            end
        end
        R(i) = max(Ri);
    end
    db = sum(R)/length(center);