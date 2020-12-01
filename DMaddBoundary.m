function DM = DMaddBoundary(DM, boundaryName, boundaryType)
   
   %validate boundarytype input
   validateBoundaryTye(boundaryType);
   
   %validate boundaryName input
   validBdryNames = validateBoundaryNames(DM, boundaryName);
   %
   % WIP: create LM Matrix based on DM.(validBdryNames).boundaryType
   %         
   for i=1:size(validBdryNames,2)
       DM.(validBdryNames{i}).boundaryType = boundaryType;
   end
   
   createLM(DM);

end

function TF = validateBoundaryTye(boundaryType)
% validateBoundaryMode() throws and error if an unknown boundary Type is
% selected
   if(strcmp(boundaryType, 'DM_Essential') || strcmp(boundaryType, 'DM_Natural'))
       TF = 1;
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
              error('Error! No such field in DM!');
          end
      end
      validBdryNames = boundaryName;
   end

end
   
function createLM(DM)
 %left empty on Purpose
end