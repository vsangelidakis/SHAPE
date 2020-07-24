function [convexity] = Convexity(Volume, Volume_CH)
%% Degree of true sphericity proposed by Wadell (1932)
% 	Volume		: Volume of the particle
%	Volume_CH	: Volume of convex hull of the particle

	% FIXME: Maybe I need to calculate the convex hull of every individual
	% particle here, if the simplified particles are NOT convex!

	convexity=Volume/Volume_CH;
end