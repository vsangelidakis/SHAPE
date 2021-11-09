function [Sq] = Sq(Z)
%% INPUT
%	Z	:	(MxN) - Elevation of rough surface points given on an M x N grid 
%% OUTPUT
%	Sq	:	Root mean square of rough surface height
[i,j]=size(Z);
Zm=1./(i*j)*sum(Z(:));
Sq=(1./(i*j)*sum(sum((Z-Zm).^2)))^0.5;
end

