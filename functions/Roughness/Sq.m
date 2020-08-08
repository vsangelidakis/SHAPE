function [Sq] = Sq(Z)
% Return the parameter Sq: Root means square of rough surface height

%% FIXME: Update the description  of Z below

% INPUT: 
% Z: (n*m) matrix (2-D image) with equal spacing, where the value of each element reflects the elevation of each particular point. 

[i,j]=size(Z);
Zm=1./(i*j)*sum(Z(:));
Sq=(1./(i*j)*sum(sum((Z-Zm).^2)))^0.5;
end

