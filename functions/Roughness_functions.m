function [sq, sa, sdq, sku, ssk] = Roughness_functions(Texture)
%ROUGHNESS Invoke calculation of all shape indices describing roughness
addpath(genpath('Roughness'))
sq=Sq(Texture.z);
sa=Sa(Texture.z);
sdq=Sdq(Texture.z,Texture.dx,Texture.dy);
sku=Sku(Texture.z,sq);
ssk=Ssk(Texture.z,sq);
end

