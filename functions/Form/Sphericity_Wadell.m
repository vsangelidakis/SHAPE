function [sphericity] = Sphericity_Wadell(Volume, Surface_area)
%% Degree of true sphericity proposed by Wadell (1932)
% 	Volume: Volume of tetrahedral mesh
%	Surface_area: Surface (outer) area of tetrahedral mesh

	sphericity = 6*Volume/((6*Volume/pi)^(1/3)*Surface_area);
end