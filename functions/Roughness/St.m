function [St,Sp,Sv] = St(Z)
% Return the parameters: St=Sp-Sv p:max, v: min

%% FIXME: Here I save 3 indices, not just St

Sp=max(Z(:));
Sv=min(Z(:));
St=Sp-Sv;
end