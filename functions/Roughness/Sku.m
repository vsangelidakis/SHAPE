function [Sku] = Sku(Z,Sq)
%% INPUT
%	Z	:	(MxN) Elevation of rough surface points given on an M x N grid 
%	Sq	:	(scalar) Root mean square of rough surface height
%% OUTPUT
%	Sku :	Kurtosis of rough surface
[i,j]=size(Z);
Zm=1./(i*j)*sum(Z(:));
Sku=1/(Sq^4)/(i*j)*sum(sum((Z-Zm).^4));
end