function [Ssk] = Ssk(Z,Sq)
% Return the parameter Ssk: Skewness of surface
[i,j]=size(Z);
Zm=1./(i*j)*sum(Z(:));
Ssk=1/(Sq^3)/(i*j)*sum(sum((Z-Zm).^3));
end