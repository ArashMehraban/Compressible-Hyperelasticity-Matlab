function DM = DMsetMaterialProperty(DM, PhysicsStruct, varargin)
%DMSETMATERIALPROPERTY sets the physics of the problem for a material.
%
% User must create a struct and set its field names and value. For example:
%   phys = struct();
%   phys.nu = 0.3;
%   phys.E = 1e6;
%
%   and provide the phys object to DMSETMATERIALPROPERTY function:
%   If DM.numBlocks is 1, then:
%   DMsetMaterialProperty(DM, phys);
%
%   If DM.numBlocks > 1, then the user must provide a 3rd input indicating for
%   which materialBlock is the material property (phys) is being set:
%   DMsetMaterialProperty(DM, phys,'Iron');
%   or
%   DMsetMaterialProperty(DM, phys, 'materialBlock3');   
%
%input: DM
%     : PhysicsStruct (see discription above)
%     : varargin: materialBlock name (see discription above)
%
%output: DM with materialBlock phsysics updated
   if nargin > 3
       error('Too many inputs!')
   end
   if DM.numBlocks > 1 && nargin <3
       fprintf(2, 'DM has multiple materialBlocks. Determine which block!')
       error('Error! try:  help DMsetMaterialProperty')
   end
   if(DM.numBlocks == 1 && nargin == 2)
      DM.(char((keys(DM.internal.blockNames)))) = PhysicsStruct; 
   end
   if(nargin == 3)
      DM.(char(varargin)) = PhysicsStruct; 
   end
   
end