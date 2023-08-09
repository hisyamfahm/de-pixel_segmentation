function ds = PS_dis(X,value,V)
% [y,x] = size(image);
% d = zeros(y,x);
% for i=1:length(value)
%     for j=1:x
        value(value==X) = 1000;
        d = abs((X-V)+(value-V))./(abs(X-V)+abs(value-V));
%     end
% end
ds = min(min(d));
clear d;
    
% for i=1:n
%     if i~=j
%         d(i) = abs((X(j)-V)+(X(k)-V))/(abs(X(j)-V)+abs(X(k)-V));
%     else
%         d(i) = 1000;
%         continue;
%     end
%     ds = min(d);
% end