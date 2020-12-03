function DM = DMaddBoundary(DM, boundaryName, boundaryType)
%DMADDBOUNDARY allows the user to choose a boundary type (DM_Essential or
%DM_Natural) also known as Dirichlet or Neumman boundary types for a set of 
%Nodesets or Sidesets. Nodesets and Sidesets (which are structs) are intended
%to be used for boundary conditions. All Nodeset and Sideset have a boundaryType
%that defaults to boundaryType = 'None' when DM object is created.
%Notice that boundaryName must be a valid boundaryName in DM. For example,
%if DMrenameBoundary() function is used to change ns_10 to wall, then wall
%is a valid boundary name in DM. ns_10 is no longer a valid boundaryName after
%being renamed.
%
%input : DM
%      : bouondaryNames. Must be given as strings in a cell array such as
%        {'ns_25', 'wall'}
%      : boundaryType. Must be either 'DM_essential' for Dirichlet condition 
%                                                 or
%                                     'DM_Natrual' for Neumman condition
%
%output: DM with updateed boundaryType for a list user-provided boundaryNames
%
%Example: DM = DMaddBoundary(DM, {'wall', 'ns_20'}, 'DM_Essential');
%         updates 'wall' and 'ns_20' boundaryType to DM_Essential from 'None'
   
   %validate boundarytype input
   validateBoundaryTye(boundaryType);
   
   %validate boundaryName input
   validBdryNames = validateBoundaryNames(DM, boundaryName);
      
   for i=1:size(validBdryNames,2)
       DM.(validBdryNames{i}).boundaryType = boundaryType;
   end
end

function validateBoundaryTye(boundaryType)
% validateBoundaryType() throws and error if an unknown boundary Type is
% selected
   if(strcmp(boundaryType, 'DM_Essential') || strcmp(boundaryType, 'DM_Natural'))
   else
       error("Error! Choose DM_Essential or DM_Natural as boundaryType" )
   end
end

function validBdryNames = validateBoundaryNames(DM, boundaryName)
%validateBoundaryNames() function returns the boundaryNames if they are
%valid boundary names in DM
  
  if(size(boundaryName,2) == 1 && strcmp(boundaryName{1}, 'all'))
      validBdryNames = keys(DM.internal.bdryNames);
  else
      for i=1:size(boundaryName,2)
          TF = isKey(DM.internal.bdryNames, boundaryName{i});
          if(TF == 0)
              msg = strcat('Error!', boundaryName{i}, ' does not exist in DM');
              error(msg);
          end
      end
      validBdryNames = boundaryName;
   end

end