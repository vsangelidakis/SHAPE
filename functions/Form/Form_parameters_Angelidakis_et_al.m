function [flatness, elongation] = Form_parameters_Angelidakis_et_al(c,b,a)
%% Form parameters proposed by Angelidakis et al (2021)
%  c,b,a: Short, Intermediate and Long dimension of a particle (aka S,I,L)
	flatness     = (b^2)/(a*c+b^2)-c/(a+c);
	elongation   = (a*c)/(a*c+b^2)-c/(a+c);
end