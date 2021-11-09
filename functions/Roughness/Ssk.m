function [Ssk] = Ssk(Z,Sq)
%% INPUT
%	Z	:	(MxN) - Elevation of rough surface points given on an M x N grid 
%	Sq	:	(scalar) Root mean square of rough surface height
%% OUTPUT
%	Ssk :	Skewness of rough surface
[i,j]=size(Z);
Zm=1./(i*j)*sum(Z(:));
Ssk=1/(Sq^3)/(i*j)*sum(sum((Z-Zm).^3));
end