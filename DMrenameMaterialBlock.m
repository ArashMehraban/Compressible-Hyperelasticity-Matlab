function DM = DMrenameMaterialBlock(DM, currentMaterialBlockName, newMaterialName)
%DMRENAMEMATERIALBLOCK renames a currentMaterialBlockName (example: materialBlock1)
%to a user-defined material name (example: Iron) for the DM object.
%
%inuput : DM data manager object
%       : currentMaterialBlockName : for example materialBlock1
%       : newMaterialName          : for example Iron
%
%output : DM : for example with its materialBlock1 renamed to Iron
%         
  DM_fld_names = fieldnames(DM);
  if(isKey(DM.internal.blockNames, currentMaterialBlockName))
      for i=1:size(DM_fld_names,1)
          if strcmp(DM_fld_names{i}, currentMaterialBlockName)
              remove(DM.internal.blockNames,DM_fld_names{i});
              DM_fld_names{i} = newMaterialName;         
              DM.internal.blockNames(newMaterialName) = 1;
          end         
      end      
  else
      error('DM does not have the specified field!')
  end
  DM = cell2struct(struct2cell(DM),DM_fld_names);
  
  %rename the corresponding currentMaterialBlockName for DM.internal too
  DM_internal_fld_names = fieldnames(DM.internal);
  for i=1:size(DM_internal_fld_names,1)
      if(strcmp(DM_internal_fld_names{i}, currentMaterialBlockName))
          DM_internal_fld_names{i} = newMaterialName;
          DM.internal = cell2struct(struct2cell(DM.internal),DM_internal_fld_names);          
      end      
  end
end
