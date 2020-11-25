function DM = renameBoundary(DM, currentBdryObjName, newBdryObjName)
%UPDATEBOUNDARYNAME renames the current boundary struct name with the
%user-defined name for the DM object.
%
%inuput : DM data manager object
%       : currentBdryObjName : for example ns_999
%       : newBdryObjName     : for example wall
%
%output : DM : for example with its ns_999 boundary object renamed to wall
%         
  DM_fld_names = fieldnames(DM);
  if(isKey(DM.internal.bdryNames, currentBdryObjName))
      for i=1:size(DM_fld_names,1)
          if strcmp(DM_fld_names{i}, currentBdryObjName)
              remove(DM.internal.bdryNames,DM_fld_names{i});
              DM_fld_names{i} = newBdryObjName;         
              DM.internal.bdryNames(newBdryObjName) = 1;
          end         
      end      
  else
      error('DM does not have the specified field!')
  end
  DM = cell2struct(struct2cell(DM),DM_fld_names);
end

  