function [Ssk] = Ssk(Z,Sq)
% Return the parameter Ssk: Skewness of surface
% Ssk=1/Sq^3*1./(n*m)*sum(sum((Z-Zm).^3)) 
[n,m]=size(Z);
Zm=1./(n*m)*sum(Z(:));
Ssk=1/(Sq^3)/(n*m)*sum(sum((Z-Zm).^3));
end