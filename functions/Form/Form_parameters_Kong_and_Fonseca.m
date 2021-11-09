function [flatness, elongation] = Form_parameters_Kong_and_Fonseca(c,b,a)
%% Form parameters proposed by Kong and Fonseca (2018)
%  c,b,a: Short, Intermediate and Long dimension of a particle (aka S,I,L)
	flatness   = (b-c)/b;
	elongation = (a-b)/a;
end