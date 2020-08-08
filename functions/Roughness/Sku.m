function [Sku] = Sku(Z,Sq)
% Return the parameter Sku: Kurtosis of surface
[i,j]=size(Z);
Zm=1./(i*j)*sum(Z(:));
Sku=1/(Sq^4)/(i*j)*sum(sum((Z-Zm).^4));
end