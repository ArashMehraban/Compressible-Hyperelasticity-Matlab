function DM = setDofsPerField(DM, dofsPerField)
%SETDOFSPERFIELD sets numFields and dofs for a DM object
%
%input : DM 
%output: DM with LM and dofs set
%

  DM.numFields = size(dofsPerField,2);
  DM.dofs = dofsPerField;  
end