function DofManager = createDofManager(DM)
%DOFMANAGER creates a DofManger object that allows the user to set number
%of fields per material and degrees of freedom (dof) per field for a DM.
%
%input : DM
%
%output: DofManager Object 
   
   %keep track of materialBlockNames
   materialBlockNames = containers.Map();
   
   DofManager = struct();
   DofManager.numMaterials = DM.numBlocks;
   
   blocknames = keys(DM.internal.blockNames);
   
   for i=1:DofManager.numMaterials
       DofManager.(char(blocknames{i})).numFields = 0;
       materialBlockNames(blocknames{i}) = 'None';
   end
   
   DofManager.materials = materialBlockNames;