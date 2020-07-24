function [flatness, elongation] = Form_parameters_Kong_and_Fonseca(S,I,L)
%% Form parameters proposed by Kong and Fonseca (2018)
% 	S,I,L: Short, Intermediate and Long dimension of a particle

	flatness   = (I - S)/I;
	elongation = (L - I)/L;
end