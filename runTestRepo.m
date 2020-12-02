%Test the current functions in the repo:
clear
clc

DM = DMcreateFromFile('multi-block.exo');
DM
DM = DMrenameMaterialBlock(DM, 'materialBlock3', 'Aluminum');
DM = DMrenameMaterialBlock(DM, 'materialBlock2', 'Iron');
DM
DM = DMsetMaterialDof(DM, 'Iron', [3,1],{'disp', 'pressure' });
DM.Iron
DM = DMrenameBoundary(DM, 'ns_10', 'wall');
DM = DMaddBoundary(DM, {'wall', 'ns_20'}, 'DM_Essential');
DM = DMrenameBoundary(DM, 'ss_9', 'ForceFace');
DM = DMaddBoundary(DM, {'ForceFace', 'ss_11'}, 'DM_Natural');
DM.wall
DM.ns_20
DM.ForceFace
DM.ss_11
