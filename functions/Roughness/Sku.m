function [Sku] = Sku(Z,Sq)
% Return the parameter Sku: Kurtosis of surface
% Sku=1/Sq^4*1./(n*m)*sum(sum((Z-Zm).^4)) 
[n,m]=size(Z);
Zm=1./(n*m)*sum(Z(:));
Sku=1/(Sq^4)/(n*m)*sum(sum((Z-Zm).^4));
end