function [spK, flP, elP, flK, elK, SIZ, ILZ] = Form_functions_2(S,I,L)
%FORM_FUNCTIONS_2 Shape indices corresponding to form, using the particle axes S,I,L
addpath(genpath('Form'))

% Input
%	S  : Short axis			%%FIXME: Small or Short?
%	I  : Intermediate axis
%	L  : Long axis			%%FIXME: Large or Long?

% Output
%	spK: Intercept sphericity (Krumbein, 1941)
%	flP: Flatness (Potticary et al, 2015)
%	elP: Elongation (Potticary et al, 2015)
%	flK: Flatness (Kong and Fonseca, 2018)
%	elK: Elongation (Kong and Fonseca, 2018)
%	SIZ: S over I (Zingg, 1935)
%	ILZ: I over L (Zingg, 1935)

spK = Sphericity_Krumbein(S,I,L);						% K denoting: Krumbein (1941)
[flP, elP] = Form_parameters_Potticary_et_al(S,I,L);	% P denoting: Potticary et al (2015)
[flK, elK] = Form_parameters_Kong_and_Fonseca(S,I,L);	% K denoting: Kong and Fonseca (2018)
[SIZ, ILZ] = Form_parameters_Zingg(S,I,L);				% Z denoting: Zingg (1935)
end