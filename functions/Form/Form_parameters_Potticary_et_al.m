function [flatness, elongation] = Form_parameters_Potticary_et_al(S,I,L)
%% Form parameters proposed by Potticary et al (2015)
% 	S,I,L: Short, Intermediate and Long dimension of a particle

	flatness     = 2*(I-S)/(L+I+S);
	elongation   =   (L-I)/(L+I+S);
end