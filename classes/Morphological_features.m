classdef Morphological_features
	%MORPHOLOGICAL_FEATURES: Morphological information of the particle
	%	Form
	%	Roundness
	%	Roughness
	
	properties
		Form
		Roundness
		Roughness
	end
	
	methods %(Static)
		function obj = Morphological_features(ms,geom,options)
			%MORPHOLOGICAL_FEATURES Constructor from meshes and geometrical features

			% Form
			obj.Form=Form(ms,geom,options); %ms,aux
			
			% Roundness
			%% FIXME
			%%

			% Roughness
			if isempty(ms.Surface_texture)==false
				obj.Roughness=Roughness(ms.Surface_texture);
			end
		end
	end
end

