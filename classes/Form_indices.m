% I can put the classes in a separate file
classdef Form_indices
	%FORM_INDICES: Shape indices related to form, using the particle axes S,I,L
	
	% Shape indices relying on these axes:
	%	Intercept_Sphericity_Krumbein_1941
	%	Flatness_Potticary_et_al_2015
	%	Flatness_Kong_and_Fonseca_2018
	%	Elongation_Potticary_et_al_2015
	%	Elongation_Kong_and_Fonseca_2018
	%	Zingg_S_over_I
	%	Zingg_I_over_L
	
	properties
		Intercept_Sphericity_Krumbein
		Flatness_Potticary_et_al_2015
		Elongation_Potticary_et_al_2015
		Flatness_Kong_and_Fonseca_2018
		Elongation_Kong_and_Fonseca_2018
		Flatness_Angelidakis_et_al_2021
		Elongation_Angelidakis_et_al_2021
		Zingg_S_over_I
		Zingg_I_over_L
	end
	
	methods %(Static)
		function obj = Form_indices(S,I,L) %ms,aux
			% FORM_INDICES Constructor from particle axes S,I,L
			[	obj.Intercept_Sphericity_Krumbein, ...
				obj.Flatness_Potticary_et_al_2015, ...
				obj.Elongation_Potticary_et_al_2015, ...
				obj.Flatness_Kong_and_Fonseca_2018, ...
				obj.Elongation_Kong_and_Fonseca_2018, ...
				obj.Flatness_Angelidakis_et_al_2021, ...
				obj.Elongation_Angelidakis_et_al_2021, ...
				obj.Zingg_S_over_I, ...
				obj.Zingg_I_over_L	] = Form_functions_2(S,I,L);
		end
	end
end

