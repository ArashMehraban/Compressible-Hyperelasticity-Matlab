function DofManager = setFieldDegreeByName(DofManager,degree, varargin)
%setFieldDegreeByName sets the polynomial accuracy per field per material.
%function signature:
%  DofManager = setFieldDegreeByName(DofManager,degree,fieldNames, material);
%
%Note: A function call per material is required
%
%If DM has ONE material and the material has ONE field, then short version
%of the function may be called as follows:
%    DofManager = setFieldDegreeByName(DofManager,degree);
%Ex: DofManager = setFieldDegreeByName(DofManager,2); 
%
%If DM has ONE material and the material has MULTIPLE fields, then a
%material name is not needed as a function input, but a cell array of 
%field names is required.
%Note: If no field names were set already using setMaterialDofs() function,
%then DofManager has created default field names as follows:
%fld1, fld2, ... . 
%Example:
%    
%Ex: DofManager = setFieldDegreeByName(DofManager,[2,0], {'disp', 'pressure'});
%    or
%    DofManager = setFieldDegreeByName(DofManager,[2,0], {'fld1', 'fld2'});
%
%In all other cases, the the material name also needs to be determined:
%Ex: DofManager = setFieldDegreeByName(DofManager,[2,0], {'disp', 'pressure'}, 'Rubber');
%    or
%    DofManager = setFieldDegreeByName(DofManager,[2,0], {'fld1', 'fld2'}, 'Rubber');
%
%input: DofManager
%     : degree     : a scaler or an array of polynomial degrees
%     : fieldNames : a cell array of field names
%     : materialName ONE fieldName
%
%Output: DofManager
%      
   if nargin == 2
      if DofManager.numMaterials > 1
          fprintf(2, 'Material type must be determined!\n')
          error('Multiple-material Error!')          
      end
      if DofManager.(char(keys(DofManager.materials))).numFields > 1
          fprintf(2, 'Field name must be determined!\n')
          error('Multiple-material Error!')
          
      end
      materialName = char(keys(DofManager.materials));
      fieldNames = {keys(DofManager.(materialName).fieldNames)};
      DofManager = setFieldByDegree_internal(DofManager,degree, fieldNames, materialName);
   end
   
   if nargin == 3
       if DofManager.numMaterials > 1
          fprintf(2, 'Material type must be determined!\n')
          error('Multiple-material Error!')          
       end
       materialName = char(keys(DofManager.materials));
       fieldNames = varargin(1);
       DofManager = setFieldByDegree_internal(DofManager,degree, fieldNames, materialName);       
   end   
   
   if nargin == 4
       materialName = varargin(2);
       fieldNames = varargin(1);
       validateBlockName(DofManager, materialName);
       validateFieldName(DofManager,fieldNames,materialName);
       DofManager = setFieldByDegree_internal(DofManager,degree, fieldNames, materialName);    
   end  
   
   if nargin > 4
       error('Too many inputs!')
   end

end

function DofManager = setFieldByDegree_internal(DofManager,degree, fieldName, materialName)
   if DofManager.(char(materialName)).numFields ~= size(degree,2)
       msg = strcat("Error! Size of 'degree' array does not match ", materialName{1}, ' numFields: ', num2str(DofManager.(char(materialName)).numFields));
       error(msg);
   end
   for i=1:size(degree,2)
       DofManager.(char(materialName)).(char(fieldName{1}(i))).degree = degree(i);
   end
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

function validateFieldName(DofManager,fieldNames, materialName)
%Validate Field name in the specified materialBlock
    for i=1:size(fieldNames{1},2)
        if isKey(DofManager.(char(materialName)).fieldNames,char(fieldNames{1}(i)))
        else
            msg = strcat("Error! ",  materialName, " does NOT have '", char(fieldNames{1}(i)), "' field"); 
            error(msg)
        end
    end
end