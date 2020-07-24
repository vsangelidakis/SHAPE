function [Sq] = Sq(Z)
% Return the parameter Sq: Root means square of rough surface height
% Sq=1/(n*m)*sum(sum((Z-Zm).^2))

%% FIXME: Update the description  of Z below

% INPUT: 
% Z: (n*m) matrix (2-D image) with equal spacing, where the value of each element reflects the elevation of each particular point. 

[n,m]=size(Z);
Zm=1./(n*m)*sum(Z(:));
Sq=(1./(n*m)*sum(sum((Z-Zm).^2)))^0.5;
end

