function DofManager = createDofManager(DM)
%DOFMANAGER creates a DofManger object that allows the user to set number
%of fields per material and degrees of freedom (dof) per field for a DM.
%
%input : DM
%
%output: DofManager Object (This mostly an internal object. No user interaction)
   
   DofManager = struct();
   DofManager.numblocks = DM.numBlocks;
   blocknames = keys(DM.internal.blockNames);
   for i=1:DofManager.numblocks
       DofManager.(char(blocknames{i})) = DM.internal.(blocknames{i}).geom; 
       DofManager.(char(blocknames{i})).numFields = 0;
   end
   