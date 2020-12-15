function DofManager = setMaterialDofs(DofManager, dofs,varargin)
%setMaterialDofs sets dofs, continuousness and field names for each field
%per material for the DofManager.
%
%NOTE: This function MUST be called for each material (materialBlock) separately.
%
%Function signature:
%    DofManager = setMaterialDofs(DofManager, dofs, continuousness, fieldNames, materialName);
%Example:
%    DofManager = setMaterialDofs(DofManager, [3,1], {'con', 'dis'}, {'disp', 'pressure'}, 'Rubber');
%    for an incompressible problem with discontinuous pressure field
%  or
%    DofManager = setMaterialDofs(DofManager, [3,1], {'con', 'con'}, {'disp', 'pressure'}, 'Rubber');
%    for an incompressible problem with continuous pressure field
%
% Note:  'con', 'continuous' or 'default' can be used instead of 'continuous'
%        'dis' or 'discontinuous' can be used instead of 'discontinuous'.
%
%Note: For ease of programming use, it is recommended that the user specify field names for dofs. 
%In case of one material (or masterialBlock) the short version of the
%function may be used:
%    DofManager = setMaterialDofs(DofManager, 3);
%    DofManager = setMaterialDofs(DofManager, dofs, {'con'}, {''}, Whatever_DM_materialBlock_name_is);   
%
%Note: If field names are ommited, they default to fld1, fld2, ... .           
%
%input : DofManager
%      : dofs          : a scalar or an array of dofs. Ex. 3 or [3,1]
%      : continuousness: a cell array the same size as dofs array that
%                        indicates the continuousness of each dof. 
%                        Ex. {'con', 'dis'} (see above help)
%      : fieldNames    : a cell array the same size as dofs array that 
%                        indicates a name for each field. 
%                        Ex: {'disp', ''pressure'}  
%      : materialName  : one string name that indicates which material in
%                        DM is being addressed. 
%                        Ex. 'Iron' or 'materialBlock1'                     
%
%output: DofManager with dofs, continuousness, fieldNames and degree (default to -1 for error checking)
%         set for a DM material

  if nargin == 2
      if DofManager.numMaterials > 1
          fprintf(2,'DofManager has multiple materials. Use:\n')
          fprintf(2,'setMaterialDofs(DofManager, dofs, continuousness, fieldNames, materialName);\n')
          fprintf(2,'setMaterialDofs(DofManager, [3,1], {''con'', ''dis''}, {''disp'', ''pressure''}, ''Iron'');\n')
          error('Error! Wrong usage of setMaterialDofs()!')
      end
      if(size(dofs,2) > 1)
          fprintf(2,'For multiple Fields, use:\n')
          fprintf(2,'setMaterialDofs(DofManager, dofs, continuousness, fieldNames, materialName);\n')
          fprintf(2,'setMaterialDofs(DofManager, [3,1], {''con'', ''dis''}, {''disp'', ''pressure''}, ''Iron'');\n')
          error('Error! Wrong usage of setMaterialDofs()!')
      end
      materialName = char(keys(DofManager.materials));
      DofManager = setMaterialDofs_internal(DofManager, dofs, {'con'}, {''}, materialName);
  end
  if nargin > 2
      continuousness = varargin{1};
      fieldNames = varargin{2};
      materialName = varargin{3};
      DofManager = setMaterialDofs_internal(DofManager, dofs, continuousness, fieldNames, materialName);
  end
  if nargin >5
      error('too many inputs!')
  end
end

function DofManager = setMaterialDofs_internal(DofManager, dofs, continuousness, fieldNames, materialName)
    DofManager.(materialName).numFields = size(dofs,2);
    
    validateBlockName(DofManager, materialName);
        
    %Keep track of dof_names (user-defined or generated)
    materialfieldNames = containers.Map();
    for i=1:size(dofs,2)
         tmp = struct();
         tmp.dof = dofs(i);
         validContinuousness = IsvalidContinuousness(continuousness{i});
         tmp.dofType= validContinuousness;
         tmp.degree = -1;
        if(isempty(fieldNames{i}))
            DofManager.(materialName).(strcat('fld',num2str(i))) = tmp;           
            materialfieldNames(strcat('fld',num2str(i))) = 1;
        else
            DofManager.(materialName).(char(fieldNames{i})) = tmp;
            materialfieldNames(fieldNames{i}) = 1;
        end
    end 
    DofManager.(materialName).fieldNames = materialfieldNames;
      
end

function validateBlockName(DofManager, materialName)
%Validate Block (material) name, otherwise, a user-defined name that does
%not exist in DM gets added to the DofManager!!
    if isKey(DofManager.materials, materialName)
    else
        msg = strcat("Error! DofManager does not have ", materialName, ' field'); 
       error(msg)
    end
end

function validContinuousness = IsvalidContinuousness(continuousness)
%Error if user does not employ a correct Continuousness word.
    valids = {'con', 'continuous','default', 'dis','discontinuous'};
    if(sum(strcmp(continuousness, valids)))
        validContinuousness = 'continuous';
    else
        fprintf(2,'Valid inputs for continuous: ''con'', ''continuous'',''default''\n')
        fprintf(2,'Valid inputs for discontinuous: ''dis'', ''discontinuous''\n')
        error('continuousness parameter Error.')
    end
end