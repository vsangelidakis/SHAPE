function [Ssc,Rs] = Ssc(Z,dx,dy)
% Return the parameter Ssc: Mean curvature of summits
% Second delivative of Z: -0.5*((ddz/dx^2)+(ddz/dx^2)) 

%% FIXME: In the formula above, both differentiators are dx. Which one should be dy ???

[n,m]=size(Z);
Ssc=-0.5*(1./((n-2)*(m-2))*(sum(sum(diff(Z,2,2)/dx^2))+sum(sum(diff(Z,2,1)/dy^2))));
Rs=1/Ssc;
end