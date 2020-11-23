function DM = addBoundary(DM, sets, boundaryMode)
     
   if(strcmp(boundaryMode, 'DM_Essential')) %Dirchlet Boundary Condition
       % The user should be able to provide an array of nodesets or sideset
       % through sets variable. So here is what needs to be (ignore sidesets)
       % done:
       % imagine sets = ['ns_999', 'ns_998']. 
       % 1) Test if the names in sets variable, i,e. 'ns_999', 'ns_998' in this example
       %    are valid nodesets in the DM. The any name is not valid, Error
       %    message
       % 2) If they are valid, check if their corrsponding bdry_stat are
       % ON. I.e, test if, in this example, ns_999_bdry_stat and
       % ns_998_bdry_stat are ON or not. If yes, do nothing and return DM,
       % if No:
       % I) turn the bdry_stat for each nodeset ON.
       % II) call createLM()
       createLM();
 
   elseif(strcmp(Qmode, 'DM_Natural')) % Neumann Boundary Condition
  
   else % Deal with Robin Boundary Condition later
     error('boundaryMode error! Choose DM_Essential or DM_Natural boundary type!');
   end
end
   
function createLM()
 %left empty on Purpose
end