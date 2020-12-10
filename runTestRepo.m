%Test the current functions in the repo:
clear
clc

% delete(gcp('nocreate'))
% parpool


% DM functions with multiple blocks
fprintf(2,'Create a DM based on multi-block Material:');
DM = DMcreateFromFile('multi-block.exo');
DM

% Manipulate Material blocks:
% rename materialBlock3 to Aluminum
fprintf(2,'Rename materialBlock3 to Aluminum:\n');
DM = DMrenameMaterialBlock(DM, 'materialBlock3', 'Aluminum');
% rename materialBlock2 to Iron
fprintf(2,'Rename materialBlock2 to Iron:\n');
DM = DMrenameMaterialBlock(DM, 'materialBlock2', 'Iron');
DM

% Manipulate Boundary sidesets/nodesets:
% rename nodeset ns_10 to wall
fprintf(2, 'rename nodeset ns_10 to wall');
DM = DMrenameBoundary(DM, 'ns_10', 'wall');
% set Dirichlet boundary condition for wall and ns_10 nodesets
DM = DMaddBoundary(DM, {'wall', 'ns_20'}, 'DM_Essential');
% rename sideset ss_9 to wall
DM = DMrenameBoundary(DM, 'ss_9', 'ForceFace');
% set Neumman boundary condition for ForceFace and ss_11 sidesets
DM = DMaddBoundary(DM, {'ForceFace', 'ss_11'}, 'DM_Natural');
%
DM.wall
DM.ns_20
DM.ForceFace
DM.ss_11

DofManager = createDofManager(DM);
DofManager = setMaterialDofs(DofManager, [3,1], {'con', 'dis'}, {'','disp'}, 'materialBlock1');
DofManager = setMaterialDofs(DofManager, 3, {'dis'}, {'disp'}, 'Aluminum');
DofManager
DofManager.Aluminum
DofManager.Aluminum.disp
DofManager.materialBlock1
DofManager.materialBlock1.disp

%The elements in the above DM are serentipity. They won't work with Tensor
% FE basis functions
DM = DMcreateFromFile('beam_12e_ns_ss.exo');
DM
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