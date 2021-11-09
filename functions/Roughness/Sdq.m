function [Sdq] = Sdq(Z,dx,dy)
%% INPUT
%	Z	:	(MxN) Elevation of rough surface points given on an M x N grid
%	dx	:	(scalar): Step size of grid along X axis (in length units)
%	dy	:	(scalar): Step size of grid along Y axis (in length units)
%% OUTPUT
%	Sdq :	Root mean square gradient of rough surface
[i,j]=size(Z);
Sdq=(1./((i-1)*(j-1))*(sum(sum((diff(Z,1,2)/dx).^2))+sum(sum(diff(Z,1,1)/dy)).^2))^0.5;
end