function [sphericity] = Sphericity_Krumbein(S,I,L)
%% Intercept sphericity proposed by Krumbein (1941)
% 	S,I,L: Short, Intermediate and Long dimension of a particle

	sphericity = (I*S/L^2)^(1/3);
end