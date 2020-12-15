%Test the current functions in the repo:
clear
clc

% delete(gcp('nocreate'))
% parpool


% sz = 100000;
% a = [1 2 3; 4 5 60; 7 88 9];
% mat = reshape(repmat(a, 1,sz), 3,3,[]);
% 
% tic 
% mat1 = delfun(mat);
% toc
% tic 
% mat2 = delfun1(mat);
% toc
% 
% DM = DMcreateFromFile('cylinder8_477Ke_2ss_us.exo');
% a = unique(DM.internal.materialBlock1.geom.conn);

fprintf(2,'*=======================Multi-block Materials testing Start======================\n\n');

fprintf(2,'Create a DM based on multi-block Material:');
DM = DMcreateFromFile('multi-block.exo');
disp(DM)


% Manipulate Material blocks:
fprintf(2,'Rename materialBlock3 to Aluminum:\n');
DM = DMrenameMaterialBlock(DM, 'materialBlock3', 'Aluminum');
% rename materialBlock2 to Iron
fprintf(2,'Rename materialBlock2 to Rubber:\n\n');
DM = DMrenameMaterialBlock(DM, 'materialBlock2', 'Rubber');
disp(DM)

% Manipulate Boundary (sidesets/nodesets):
fprintf(2, 'Rename nodeset ns_10 to wall\n');
DM = DMrenameBoundary(DM, 'ns_10', 'wall');
disp(DM)

fprintf(2, 'Set Dirichlet boundary condition for wall and ns_20 nodesets\n');
DM = DMaddBoundary(DM, {'wall', 'ns_20'}, 'DM_Essential');
disp(DM)

fprintf(2, 'Rename nodeset ss_9 to ForceFace\n');
DM = DMrenameBoundary(DM, 'ss_9', 'ForceFace');
disp(DM)

fprintf(2, 'Set Neumann boundary condition for ss_1, ss_2, ss_3\n');
DM = DMaddBoundary(DM, {'ss_1', 'ss_2', 'ss_3'}, 'DM_Natural');
disp(DM.ss_1)
disp(DM.ss_2)
disp(DM.ss_3)



%Setting material property requires the user to create a struct and pass it to the
%DMsetMaterialProperty() function. Struct is needed because, it cannot be
%determined what physics a problem has. For example for elastic type
%problems, user must create:
fprintf(2, 'Seting Physics for a Aluminum\n');
physAl = struct();
physAl.nu = 0.3;
physAl.E = 1e6;
DM = DMsetMaterialProperty(DM, physAl, 'Aluminum');
physRub = struct();
physRub.nu = 0.3;
physRub.E = 1e6;
DM = DMsetMaterialProperty(DM, physRub, 'Rubber');
disp(DM.Aluminum)
disp(DM.Rubber)



fprintf(2, 'Create a DofManager:\n');
DofManager = createDofManager(DM);
disp(DofManager)
fprintf(2, 'Set dofs, countinousness fieldnames for Rubber, Aluminum and materialBlock1:\n');
DofManager = setMaterialDofs(DofManager, [3,1], {'con', 'dis'}, {'displacement','pressure'}, 'Rubber');
DofManager = setMaterialDofs(DofManager, 3, {'con'}, {'displacement'}, 'Aluminum');
DofManager = setMaterialDofs(DofManager, 3, {'con'}, {'displacement'}, 'materialBlock1');

fprintf(2, 'Displaying dofs, countinousness and fieldnames for Rubber:\n');
DofManager.Rubber
DofManager.Rubber.displacement
DofManager.Rubber.pressure
fprintf(2, 'Displaying dofs, countinousness and fieldnames for Aluminum:\n');
DofManager.Aluminum
DofManager.Aluminum.displacement
fprintf(2, 'Displaying dofs, countinousness and fieldnames for Aluminum:\n');
DofManager.materialBlock1.displacement
DofManager.materialBlock1.displacement

fprintf(2, 'Set dofs, countinousness (no fieldnames) for materialBlock4:\n');
fprintf(2, 'DofManager defaults fieldnames to fld1, fld2, etc .. for materialBlock4:\n');
DofManager = setMaterialDofs(DofManager, [3,1], {'con','dis'}, {'', ''}, 'materialBlock4');
fprintf(2, 'Displaying dofs, countinousness and fieldnames for Aluminum:\n');
DofManager.materialBlock4.fld1
DofManager.materialBlock4.fld1


%Setting polynomial degrees for each Material:
fprintf(2, 'Setting polynomial degrees for Rubber:\n');
DofManager = setFieldDegreeByName(DofManager,[2,0], {'displacement','pressure'},'Rubber');
DofManager.Rubber.displacement
DofManager.Rubber.pressure

fprintf(2, 'Setting polynomial degrees for Aluminum:\n');
DofManager = setFieldDegreeByName(DofManager, 4 , {'displacement'},'Aluminum');
DofManager.Aluminum.displacement

fprintf(2, 'Setting polynomial degrees for materialBlock1:\n');
DofManager = setFieldDegreeByName(DofManager, 3 , {'displacement'},'materialBlock1');
DofManager.materialBlock1.displacement

fprintf(2, 'Setting polynomial degrees for materialBlock1:\n');
DofManager = setFieldDegreeByName(DofManager, [3,2] , {'fld1','fld2'},'materialBlock4');
DofManager.materialBlock4.fld1
DofManager.materialBlock4.fld1

fprintf(2,'=======================Multi-block Materials testing End======================*\n\n');

clear

fprintf(2,'*=======================Single Material testing Start===========================\n\n');

DM = DMcreateFromFile('beam_12e_ns_ss.exo');
disp(DM)
fprintf(2,'Rename materialBlock1 to Iron:\n');
DM = DMrenameMaterialBlock(DM, 'materialBlock1', 'Iron');
disp(DM)

% Manipulate Boundary (sidesets/nodesets):
fprintf(2, 'Rename nodeset ns_998 to wall\n');
DM = DMrenameBoundary(DM, 'ns_998', 'wall');
disp(DM)

fprintf(2, 'Set Dirichlet boundary condition for wall\n');
DM = DMaddBoundary(DM, {'wall'}, 'DM_Essential');
disp(DM.wall)

fprintf(2, 'Rename nodeset ns_999 to Force\n');
DM = DMrenameBoundary(DM, 'ns_999', 'Force');
disp(DM)

fprintf(2, 'Set Neumman boundary condition for wall and ss_898 nodesets\n');
DM = DMaddBoundary(DM, {'ss_898'}, 'DM_Natural');
disp(DM.ss_898)


DofManager = createDofManager(DM);
disp(DofManager)
fprintf(2, 'Set dofs\n');
DofManager = setMaterialDofs(DofManager, 3);
disp(DofManager.Iron)
DofManager = setFieldDegreeByName(DofManager,2);
DofManager.Iron.fld1

fprintf(2,'=======================Single Material testing End=============================*\n\n');


%Multi-block material elements in the above are serentipity. They won't work with Tensor
% FE basis functions

P = 2;
Q = 5;
[B1d, D1d, W, qref1d] = FEcreateBasis(P,Q, 'GAUSS');
B1d
D1d
W
qref1d
[B_hat,D_hat, W_hat] = createTensor(B1d,D1d,W,P,Q,DM.dim);
B_hat
u = rand(8,30000);
tic
elem_u = D_hat * u;
toc
W_hat

%==================%
P = 3;
Q = 3;
[B1d, D1d, W, qref1d] = FEcreateBasis(P,Q, 'GAUSS');
[B_hat,D_hat, W_hat] = createTensor(B1d,D1d,W,P,Q,2);
element_vtx_coords = rand(9,2);
%[dets, inverseElemVtxJacobian] = invJacobianTensor(element_vtx_coords, D_hat, Q,DM.dim);
%You get NaN's becasue the element_vtx_coords is not ordered
%lexicographically
% dets
% inverseElemVtxJacobian

% element_vtx_coords = element_vtx_coords(:,1:2);
% tic
% for i=1:10000
%     [dets, inverseElemVtxJacobian] = invJacobianTensor(element_vtx_coords, D_hat,P, Q,2);
% end
% toc
% 
% tic
% parfor i=1:10000
%     [dets, inverseElemVtxJacobian] = invJacobianTensor(element_vtx_coords, D_hat, Q,DM.dim);
% end
% toc