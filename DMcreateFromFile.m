function dm = DMcreateFromFile(filename)
%DMCREATEFROMFILE creates a Data Manager(DM) object (struct) from an
%Exoduss-II mesh file made by Trelis meshing software. This code was
%tested with output mesh file from Trelis 16.1
%
%DMCREATEFROMFILE(filename) can hadle 1D, 2D and 3D meshes with 1 or more blocks of the same type elements.
%This code was tested with:
%   -8-noded and 27-noded Hex elements
%   -4-noded and 9-noded Quad elements
%Meshes with Tet elements or mixed Tets and Hex elements may NOT work
%properly.
%Input:  mesh object (mesh object is obtained by calling readExodusIImesh() function automatically)
%Output: DM object (data manager for FEM)
%
%Example input and output:
%filename = 'beam_12e_ns_ss.exo';
%dm = DMcreateFromFile(filename);
%
% dm = 
% 
%   struct with fields:
% 
%                 dim: 3
%            numNodes: 45
%            numElems: 16
%     numNodesPerElem: 8
%                conn: [16×8 int32]
%              coords: [45×3 double]
%         numNodesets: 2
%              ns_998: [1×1 struct]
%              ns_999: [1×1 struct]
%         numSidesets: 2
%              ss_898: [1×1 struct]
%              ss_899: [1×1 struct]
%                   u: 0
%              dofMap: 0
%              appCtx: 0

%Exodus-ii connect:
%  v : vertex     bm : bottom face   bk : back face
%  e : edge       tp : top face      lt : left face
%  f : face       fr : front face    rt : right face
%  c : cell
%          v v v v v v v v
%  Hex8 = [1 2 3 4 5 6 7 8]                                       bm tp lt rt fr bk
%                                                                 4  8  5  6  5  8 
%                                                                 3  7  8  7  6  7 
%                           2 3  4  1  5  6  7  8  6  7  8  5     2  6  4  3  2  3 
%                           1 2  3  4  1  2  3  4  5  6  7  8     1  5  1  2  1  4                    
%           v v v v v v v v e e  e  e  e  e  e  e  e  e  e  e  c  f  f  f  f  f  f           
%  Hex27 = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27]
%
%
   mesh = readExodusIImesh(filename);
   numBlocks = mesh.num_el_blk;
   mesh_fld_names = fieldnames(mesh);
   M = containers.Map(mesh_fld_names,zeros(size(mesh_fld_names,1),1));
   
   dm=struct();
   if(numBlocks > 1)
       dm.numBlocks = mesh.num_el_blk;
       for i=1:dm.numBlocks
           dm.(strcat('numElemsInBlock',num2str((i)))) = mesh.(strcat('num_el_in_blk',num2str((i))));           
       end
       for i=1:dm.numBlocks
           dm.(strcat('conn',num2str((i)))) = mesh.(strcat('connect',num2str((i))))';           
       end   
       for i=1:dm.numBlocks
           dm.(strcat('numNodesPerElem',num2str((i)))) = mesh.(strcat('num_nod_per_el',num2str((i))))';           
       end  
   end
   dm.dim = mesh.num_dim;
   dm.numNodes = mesh.num_nodes;
   dm.numElems = mesh.num_elem; 
   dm.numNodesPerElem = mesh.num_nod_per_el1;
   
   if(numBlocks == 1)
       dm.conn = mesh.connect1';
   end
   
   if(mesh.num_dim == 1)
       dm.coords = mesh.coordx;
   elseif(mesh.num_dim == 2)
       dm.coords = [mesh.coordx,mesh.coordy];
   elseif(mesh.num_dim == 3)
       dm.coords = [mesh.coordx,mesh.coordy, mesh.coordz];
   end   
      
   TF = isKey(M,'num_node_sets');
   if(TF == 1)
       dm.numNodesets = mesh.num_node_sets;
       %nsnames = mesh.ns_names;  %Matlab screws these up!! In Trelis : {Nodeset|Sideset} <ids> Name "<new_name>"
       nsp = mesh.ns_prop1;
       ns_fld_names = cell(size(nsp,1),1);
       for i=1:size(nsp,1)
           ns_fld_names{i} = strcat('ns_',num2str(nsp(i)));
           nsTmp =struct();
           nsTmp.nodes = mesh.(strcat('node_ns',num2str((i))));
           nsTmp.onBoundary = 'NO';
           structName = matlab.lang.makeValidName(ns_fld_names{i});
           cellstructname = cellstr(structName);
           dm.(cellstructname{1}) = nsTmp;
       end                     
   end
   TF = isKey(M,'num_side_sets');
   if(TF == 1)
       dm.numSidesets = mesh.num_side_sets;
       %ssnames = mesh.ss_names; %Matlab screws these up!!
       ssp = mesh.ss_prop1;
       ss_fld_names = cell(size(ssp,1),1);
       ss_fld_mesh = cell(size(ssp,1),1);
       for i=1:size(ssp,1)
           ss_fld_names{i} = strcat('ss_',num2str(ssp(i))); 
           ss_fld_mesh{i} = strcat('side_ss',num2str((i)));
           ssTmp = struct();
           ssTmp.elems = mesh.(strcat('elem_ss',num2str((i))));
           ssTmp.sides = mesh.(ss_fld_mesh{i});
           ssTmp.onBoundary = 'NO';
           structName = matlab.lang.makeValidName(ss_fld_names{i});
           cellstructname = cellstr(structName);
           dm.(cellstructname{1}) = ssTmp;         
        end
   end
   dm.u = 0;   
   dm.dofMap = 0;
   dm.appCtx = 0;  
end

function mesh = readExodusIImesh(filename)
%readExodusIImesh returns a struct called mesh that holds all fields and
%their values of an Exodus-II file created by Trelis software. This code
%was tested with output mesh from Trelis 16.1
    
   
    if(~isfile(filename))
        fileDoesNotExist = strcat(filename,' does NOT exist!!');
        error(fileDoesNotExist);
    end

    if(~(strcmp(filename(end-4:end),'.exo')) && strcmp(filename(end-2:end),'.e'))
        error('Wrong file format for input. get_mesh can read .exo and .e files only!!')
    end
    
    ncid = netcdf.open(filename);
    % netCDF files have three header sections:
    % 1) dimensions
    % 2) variables
    % 3) attributes (global) (Not needed/extracted for get_mesh function)

    %get the number of dimensions and variables 
    [numdims, numvars, ~, ~] = netcdf.inq(ncid);

    %Allocate space for netCDF file dimensions 
    dimen_names = cell(numdims,1);
    dimen_lens = zeros(numdims,1);
    dimen_ID = zeros(numdims,1);

    %get dimensions information
    for i=0:numdims-1    
        [dim_names, dimlen] = netcdf.inqDim(ncid,i);
        dimen_ID(i+1) = netcdf.inqDimID(ncid,dim_names);
        dimen_names{i+1} = dim_names;
        dimen_lens(i+1) = dimlen;     
    end

    %Allocate space for netCDF file variables 
    var_names = cell(numvars,1);
    var_ID = zeros(numvars,1);
    
    %Allocate space for data extracted from netCDF variables
    mesh_data = cell(numvars,1);

    %get variables information
    for i=0:numvars-1   
        var_names{i+1} = netcdf.inqVar(ncid,i);
        var_ID(i+1) = netcdf.inqVarID(ncid,var_names{i+1});
        mesh_data{i+1} = netcdf.getVar(ncid, var_ID(i+1));
    end
    
    %return mesh topology info
    mesh=struct();
    for i=1:numdims
        mesh.(dimen_names{i}) = dimen_lens(i);
    end
    for i=1:numvars
        mesh.(var_names{i}) = mesh_data{i};
    end
    
    %close the file
    netcdf.close(ncid);
end
