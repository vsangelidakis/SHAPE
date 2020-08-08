function [Ssc,Rs] = Ssc(Z,dx,dy)
% Return the parameter Ssc: Mean curvature of summits

%% FIXME: In the formula above, both differentiators are dx. Which one should be dy ???

[i,j]=size(Z);
Ssc=-0.5*(1./((i-2)*(j-2))*(sum(sum(diff(Z,2,2)/dx^2))+sum(sum(diff(Z,2,1)/dy^2))));
Rs=1/Ssc;
end