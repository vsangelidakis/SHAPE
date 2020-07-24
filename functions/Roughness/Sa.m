function [Sa] = Sa(Z)

%% FIXME
% INPUT

% Return the parameter Sa: Mean height of rough surface
% Sa=1/(n*m)*sum(sum(|Z-Zm|)) 
[n,m]=size(Z);
Zm=1./(n*m)*sum(Z(:));
Sa=1./(n*m)*sum(sum(abs(Z-Zm)));
end

