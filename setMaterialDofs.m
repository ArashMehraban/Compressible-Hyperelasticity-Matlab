function DofManager = setMaterialDofs(DofManager, dofs,varargin)
%setMaterialDofs allows the user to set dofs, continuousness of each field
%and user-defined field names per material for the DofManager.
%
%NOTE: This function MUST be called for each material (materialBlock) separately.
%
%Function signature:
%    DofManager = setMaterialDofs(DofManager, dofs, continuousness, fieldNames, materialName);
%Example:
%    DofManager = setMaterialDofs(DofManager, [3,1], {'con', 'dis'}, {'disp', 'pressure'}, 'Iron');
%    for an incompressible problem with discontinuous pressure field
%  or
%    DofManager = setMaterialDofs(DofManager, [3,1], {'con', 'con'}, {'disp', 'pressure'}, 'Iron');
%    for an incompressible problem with continuous pressure field
%
% Note:  'con', 'continuous' and 'default' can be used instead of 'continuous'
%        'dis' or 'discontinuous' can be used instead of 'discontinuous'.
%        
%In case of one material (or masterialBlock) the short version of the
%function may be used:
%    DofManager = setMaterialDofs(DofManager, 3);
%    DofManager = setMaterialDofs(DofManager, dofs, {'con'}, {''}, Whatever_DM_materialBlock_name_is);   
%
%Note: If field names are ommited, they default to fld1_dof, fld2_dof, ... .           
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
%output: DofManager with dofs, continuousness and fieldNames set for a DM material

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
      DofManager = setMaterialDofs_internal(DofManager, dofs, {'con'}, {''}, char(keys(DofManager.materials)));
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
         tmp.degree = -999;
        if(isempty(fieldNames{i}))
            DofManager.(materialName).(strcat('fld',num2str(i), '_dof')) = tmp;           
            materialfieldNames(strcat('fld',num2str(i), '_dof')) = 1;
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