% I can put the classes in a separate file
classdef Roughness
	%ROUGHNESS: Morphological information related to roughness/surface texture
	%	Root mean square height (Sq)
	%	Arithmetical mean height (Sa)
	%	Root mean square gradient (Sdq)
	%	Kurtosis (Sku)
	%	Skewness (Ssk)
	
	properties
		Sq
		Sa
		Sdq
		Sku
		Ssk
	end
	
	methods %(Static)
		function obj = Roughness(Texture)
			%ROUGHNESS Constructor from spatial surface texture profile
			[obj.Sq, obj.Sa, obj.Sdq, obj.Sku, obj.Ssk]=Roughness_functions(Texture);
		end
	end
end