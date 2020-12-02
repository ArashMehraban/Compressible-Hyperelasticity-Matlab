function DM = DMsetMaterialDof(DM, materialName, dofsPerFieldforMaterial, varargin)
%DMSETMATERIALDOF sets the number of Fields and dofs per field for a
%material in DM. User can provide names for each field name. For example if
% dofsPerFieldforMaterial = [3,1], then user can provide {'disp', 'pressure'}
% as an optional input to the function. If field names are ommited, they default to
%           fld1, fld2, ... .
%
%input : DM 
%      : materialName            : materialBlock name. For Example: 
%        materialBlock1 or Iron if materialBlock1 is renamed to Iron by
%        user using DMrenameMaterialBlock() function.
%      : dofsPerFieldforMaterial : an array of dofs for the field. For 
%        Example: [3,1] 
%      : varargin (optional)     : a cell array of field names such as 
%        {'disp', 'pressure'}
%
%output: DM with updated numFields and dofPerfields for a materialName
%

  validateBlockName(DM, materialName);
  DM.(materialName).numFields = size(dofsPerFieldforMaterial,2);
  %DM.(materialName).dofs = dofsPerFieldforMaterial;

  materialfld_names = cell(1, DM.(materialName).numFields);
  if nargin == 3
      for i=1:DM.(materialName).numFields
          materialfld_names{i} = strcat('fld',num2str(i), '_dof');          
      end     
  end
  if nargin == 4
      for i=1:DM.(materialName).numFields
          materialfld_names{i} = strcat(char(varargin{1}(i)),'_dof');          
      end
  end
  for i=1:DM.(materialName).numFields
      %DM.(materialName).(materialfld_names{i}) = struct();
      DM.(materialName).(materialfld_names{i}) = dofsPerFieldforMaterial(i);
  end
  %DM.internal.fieldNames = materialfld_names;
end

function validateBlockName(DM, materialName)
    if isKey(DM.internal.blockNames, materialName)
    else
        msg = strcat("Error! DM does not have ", materialName, ' field'); 
       error(msg)
    end

end