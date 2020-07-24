% I can put the classes in a separate file
classdef Form %< dynamicprops
	%FORM: Morphological information related to form
	%	Convexity
	%	Sphericity_Wadell (Wadell, 1932)
	
	% Form_indices_obb and/or Form_indices_eli
	%	Intercept_Sphericity_Krumbein_1941
	%	Flatness_Potticary_et_al_2015
	%	Flatness_Kong_and_Fonseca_2018
	%	Elongation_Potticary_et_al_2015
	%	Elongation_Kong_and_Fonseca_2018
	%	Zingg_c_over_b
	%	Zingg_b_over_a
	
	%%
	%% FIXME: Add rest of the indices, e.g. surface orientation tensor
	%%
	properties
		Convexity
		Sphericity_Wadell
% 		Form_indices % This is defined below as a struct. Do I need to turn it into a class?
		Form_indices_obb
		Form_indices_eli
		Form_indices_sot

% 		Intercept_Sphericity_Krumbein
% 		Flatness_Potticary_et_al_2015
% 		Elongation_Potticary_et_al_2015
% 		Flatness_Kong_and_Fonseca_2018
% 		Elongation_Kong_and_Fonseca_2018
% 		Zingg_c_over_b
% 		Zingg_b_over_a
	end
	
	methods %(Static)
		function obj = Form(mesh,geom,options)
			% FORM Constructor from Geometrical_features
			[obj.Convexity, obj.Sphericity_Wadell] = Form_functions_1(geom.Surface_area,geom.Volume,geom.Volume_CH);
			
			[obj.Form_indices_sot.Compactness, obj.Form_indices_sot.Flatness, obj.Form_indices_sot.Elongation, ~, ~] = SurfaceOrientationTensor(mesh.Surface_mesh.Vertices, mesh.Surface_mesh.Faces);

	%% FIXME: Decide whether to always calculate OBB/ELI or let the user decide
	%%
% 			if strcmp(options,'all')
% % 				P = addprop(H,'PropertyName') in the script
				obj.Form_indices_obb=Form_indices(geom.S_obb, geom.I_obb, geom.L_obb);
				obj.Form_indices_eli=Form_indices(geom.S_eli, geom.I_eli, geom.L_eli);
% 			elseif strcmp(options,'obb')
% 				obj.Form_indices_obb=Form_indices(geom.S_obb, geom.I_obb, geom.L_obb);
% % 				delete(obj.Form_indices_eli)
% % 				obj.Form_indices_eli.Hidden=true
% 			elseif strcmp(options,'eli')
% 				obj.Form_indices_eli=Form_indices(geom.S_eli, geom.I_eli, geom.L_eli);
% 			end
		end
		
% 		% This method controls visibility of the object's properties
% 		function flag = isInactivePropertyImpl(obj,Form_indices_eli)
% 			if isempty(Form_indices_eli)
% 				flag = obj.UseRandomInitialValue;
% 			else
% 				flag = false;
% 			end
% 		end

	end
end

