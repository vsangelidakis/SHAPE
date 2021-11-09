function [Ssc,Rs] = Ssc(Z,dx,dy)
%% INPUT
%	Z	:	(MxN) Elevation of rough surface points given on an M x N grid
%	dx	:	(scalar): Step size of grid along X axis (in length units)
%	dy	:	(scalar): Step size of grid along Y axis (in length units)
%% OUTPUT
%	Ssc: Mean curvature of summits
%% TODO: Check again the formula below which differentiator should be dx and which one dy
[i,j]=size(Z);
Ssc=-0.5*(1./((i-2)*(j-2))*(sum(sum(diff(Z,2,2)/dx^2))+sum(sum(diff(Z,2,1)/dy^2))));
Rs=1/Ssc;
end