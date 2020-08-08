function [Sdq] = Sdq(Z,dx,dy)
% Return the parameter Sdq: Slope of Root means square
[i,j]=size(Z);
Sdq=(1./((i-1)*(j-1))*(sum(sum((diff(Z,1,2)/dx).^2))+sum(sum(diff(Z,1,1)/dy)).^2))^0.5;
end