function DM = DMsetDofsPerField(DM, dofsPerField, varargin)
%DMSETDOFSPERFIELD sets the number of Fields and dofs per field for a DM object
%
%input : DM 
%      : array of dof such as [3,1]
%      : cell array of field names such as {'disp', 'pressure'}
%           if field names cell array is ommited, it defaults to
%           fld1, fld2, ... 
%output: DM with updated numFields and dofPerfields
%

  DM.numFields = size(dofsPerField,2);
  fld_names = cell(1, DM.numFields);
  if nargin == 2
      for i=1:DM.numFields
          fld_names{i} = strcat('fld',num2str(i));          
      end     
  end
  if nargin == 3
      for i=1:DM.numFields
          fld_names{i} = char(varargin{1}(i));          
      end
  end
  for i=1:DM.numFields
      DM.(fld_names{i}) = struct();
      DM.(fld_names{i}).dof = dofsPerField(i);
  end

end