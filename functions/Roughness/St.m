function [St,Sp,Sv] = St(Z)
%% INPUT
%	Z	:	(MxN) Elevation of rough surface points given on an M x N grid 
%% OUTPUT
%	St	:	Total height of rough surface
%	Sp	:	Maximum peak height of rough surface
%	Sv	:	Maximum pit height of rough surface
Sp=max(Z(:));
Sv=min(Z(:));
St=Sp-Sv;
end