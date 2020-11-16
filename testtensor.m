clc

clear all

P = 2;
Q = 2;

[B, D, W, qref1d] = FEcreateBasis(P,Q, 'GAUSS');

Rf = B;
Sf = B;
Tf = B;
ne = 1;
dof = 3;
x1 = 1:24;  
y = tensor(ne,dof,P,Q,Rf,Sf,Tf,x1);

% old code
       % x: Guass points    w: Gauss weights

       x = qref1d';
       w = W';
       num_quadr_pts_in_1d = 2;
       dim = 3;
       bHat = [(1-x)/2, (1+x)/2];
       dHat = [-1/2+0*x, 1/2+0*x];
           
       % Basis/Shape functions (B)
       B_hat = kron(kron(bHat,bHat),bHat); 
           % Derivative of Basis/Shapefunctions (D_hat)
       D_hat = [kron(kron(dHat,bHat),bHat); kron(kron(bHat,dHat),bHat);kron(kron(bHat,bHat),dHat)];    


       
 x2 = reshape(x1, 8,3);      
 y1 = B_hat*x2;
 
 
 
 