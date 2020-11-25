function DM = updateBoundaryName(DM, currentBdryObjName, newBdryObjName)
%UPDATEBOUNDARYNAME renames the current boundary struct name with the
%user-defined name for the DM object.
%
%inuput : DM data manager object
%       : currentBdryObjName : for example ns_999
%       : newBdryObjName     : for example wall
%
%output : DM : for example with its ns_999 boundary object renamed to wall
%         

  fld_names = fieldnames(DM);
  for i=1:size(fld_names,1)
     if strcmp(fld_names{i}, currentBdryObjName) 
         fld_names{i} = newBdryObjName;
     end         
  end
  DM = cell2struct(struct2cell(DM),fld_names);
end

  