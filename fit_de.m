function ps = fit_de(Z,image,i,group)
    center = Z(2,:,i);
    center(Z(3,:,i)==0)=0;
    [r,c,center] = find(center);
    ps = fit(image,double(group(:)'),center);
    ps = 1/(ps+0.0002);