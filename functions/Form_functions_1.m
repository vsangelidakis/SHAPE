function [con, spW] = Form_functions_1(Surface_area,Volume,Volume_CH)
%FORM_FUNCTIONS_1 Shape indices corresponding to form, not using the particle axes S,I,L
addpath(genpath('Form'))

%% FIXME Maybe I need to include here the volume of the Convex Hull
%%

% Input
%	Surface_area : Surface area
%	Volume       : Volume
%	Volume_CH    : Volume of convex hull

% Output
% 	con: Convexity
%	spW: Degree of true sphericity (Wadell, 1932)

con = Convexity(Volume, Volume_CH);
spW = Sphericity_Wadell(Volume, Surface_area);		% W denoting: Wadell (1932)

end