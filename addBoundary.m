function DM = addBoundary(DM, sets, boundaryMode)
     
   if(strcmp(boundaryMode, 'DM_Essential')) %Dirchlet Boundary Condition
       % The user should be able to provide an array of nodesets or sideset
       % through sets variable. So here is what needs to be (ignore sidesets)
       % done:
       % imagine sets = {'ns_999', 'ns_998'}. 
       % 1) Test if the names in sets variable, i,e. 'ns_999', 'ns_998' in this example
       %    are valid nodesets in the DM. The any name is not valid, Error
       %    message
       DM_ns_names = {'ns_998','ns_999'};
       sz_sets = size(sets,2);
       
       M1 = containers.Map(sets,ones(1,sz_sets));
       TF = isKey(M1,DM_ns_names);
       if (TF(1,1)==0)
           error('the 1st name of nodesets is not valid!');
       elseif (TF(1,2)==0)
           error('the 2nd name of nodesets is not valid!');    
       end
       % 2) If they are valid, check if their corrsponding bdry_stat are
       % ON. I.e, test if, in this example, ns_999_bdry_stat and
       % ns_998_bdry_stat are ON or not. If yes, do nothing and return DM,
       % if No:
       % I) turn the bdry_stat for each nodeset ON.
       % II) call createLM()
       DM_stat = {DM.ns_999_bdry_stat, DM.ns_998_bdry_stat};
       tf = strcmp(DM_stat,'ON');
       if tf(1,1) == 0
           createLM()
       elseif tf(1,2) == 0
           createLM()
       end
       
       
       if strcmp(sets, 'DM_Natural')

       end
 
   elseif(strcmp(Qmode, 'DM_Natural')) % Neumann Boundary Condition
  
   else % Deal with Robin Boundary Condition later
     error('boundaryMode error! Choose DM_Essential or DM_Natural boundary type!');
   end
end
   
function createLM()
 %left empty on Purpose
end