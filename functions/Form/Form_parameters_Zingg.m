function [c_over_b, b_over_a] = Form_parameters_Zingg(S,I,L)
%% Form parameters proposed by Zingg (1935)
% 	S,I,L: Short, Intermediate and Long dimension of a particle

	c_over_b=S/I;
	b_over_a=I/L;
end