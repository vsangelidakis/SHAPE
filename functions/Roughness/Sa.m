function [Sa] = Sa(Z)

%% FIXME: Write input/output and parameters descriptions
% INPUT

% Return the parameter Sa: Mean height of rough surface
[i,j]=size(Z);
Zm=1./(i*j)*sum(Z(:));
Sa=1./(i*j)*sum(sum(abs(Z-Zm)));
end

