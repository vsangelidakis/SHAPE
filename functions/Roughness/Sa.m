function [Sa] = Sa(Z)
%% INPUT
%	Z	:	(MxN) Elevation of rough surface points given on an M x N grid 
%% OUTPUT
%	Sa	:	Arithmetical mean height of rough surface
[i,j]=size(Z);
Zm=1./(i*j)*sum(Z(:));
Sa=1./(i*j)*sum(sum(abs(Z-Zm)));
end

