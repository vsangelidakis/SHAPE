function [Sdq] = Sdq(Z,dx,dy)
% Return the parameter Sdq: Slope of Root means square
% This is equivalent to dZ = ((dz/dx)^2+(dz/dx)^2)^0.5 
[n,m]=size(Z);
Sdq=(1./((n-1)*(m-1))*(sum(sum((diff(Z,1,2)/dx).^2))+sum(sum(diff(Z,1,1)/dy)).^2))^0.5;
end