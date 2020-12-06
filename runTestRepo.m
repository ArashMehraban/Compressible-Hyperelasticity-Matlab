%Test the current functions in the repo:
clear
%clc

% delete(gcp('nocreate'))
% parpool


%DM functions
DM = DMcreateFromFile('multi-block.exo');
DM
DM = DMrenameMaterialBlock(DM, 'materialBlock3', 'Aluminum');
DM = DMrenameMaterialBlock(DM, 'materialBlock2', 'Iron');
DM
% DM = DMsetMaterialDof(DM, 'Iron', [3,1],{'disp', 'pressure' });
% DM.Iron
DM = DMrenameBoundary(DM, 'ns_10', 'wall');
DM = DMaddBoundary(DM, {'wall', 'ns_20'}, 'DM_Essential');
DM = DMrenameBoundary(DM, 'ss_9', 'ForceFace');
DM = DMaddBoundary(DM, {'ForceFace', 'ss_11'}, 'DM_Natural');
DM.wall
DM.ns_20
DM.ForceFace
DM.ss_11

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