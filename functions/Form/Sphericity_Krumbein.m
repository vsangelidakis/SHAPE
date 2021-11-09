function [sphericity] = Sphericity_Krumbein(c,b,a)
%% Intercept sphericity proposed by Krumbein (1941)
%  c,b,a: Short, Intermediate and Long dimension of a particle (aka S,I,L)
	sphericity = (b*c/a^2)^(1/3);
end