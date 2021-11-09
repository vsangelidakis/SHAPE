function [flatness, elongation] = Form_parameters_Potticary_et_al(c,b,a)
%% Form parameters proposed by Potticary et al (2015)
%  c,b,a: Short, Intermediate and Long dimension of a particle (aka S,I,L)
	flatness     = 2*(b-c)/(a+b+c);
	elongation   =   (a-b)/(a+b+c);
end