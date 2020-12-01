function [B_hat,D_hat, W_hat] = createTensor(B1d,D1d,W,P,Q,dim)
%TENSOR applies the tensor contraction to input vector x an returns
%contracted vector y.
%inputs: B1d: basis/shape function evaluated at quadrature points
%        D1d: derivative of basis/shape function evaluated at quadrature points
%        W  : quadrature weights
%        P  : polynomial degree + 1 
%        Q  : number of quadrature points
%        dim: mesh dimension
% output: 
%       : W_hat: Weights for the elements
%       : B_hat (N in most FEM contexts): 
%               basis/shape functions evaluted at quadrature points 
%       : D_hat (partial_N/partial_xi, partial_N/partial_eta, partial_N/partial_zeta) 
%               derivative of basis/shape functions evaluated at 
%               quadrature points in xi, eta and (zeta if 3D) directions.
%         D_hat consists of D0, D1 and (D2 if 3D problem) where
%           D0 (d_N/d_xi):   derivative of basis/shape functions wrt xi 
%                            evaluted at quadrature points 
%           D1 (d_N/d_eta):  derivative of basis/shape functions wrt eta 
%                            evaluted at quadrature points
%           D2 (d_N/d_zeta): derivative of basis/shape functions wrt zeta 
%                            evaluted at quadrature points
%
%           Structure of D_hat returned: 
%                 |D0|            |D0|
%           D_hat=|D1|   ,  D_hat=|D1|
%                                 |D2|      
%           To compute D0, D1 and D2 where (K) represents Kronecker Product :    
%                  D0 = D (k) B     D0 = D (K) B (K) B   
%                  D1 = B (K) D     D1 = B (K) D (K) B
%                                   D2 = B (K) B (K) D

    %convert 1D arrays of B1d and D1d to 2D matrices
    %NOTE: do NOT use reshape. It will break the order when P is NOT eqal Q
    B = zeros(Q,P);
    D = zeros(Q,P);    
    for i=1:Q
        for j=1:P
            B(i,j) = B1d((i-1)*P+j);
            D(i,j) = D1d((i-1)*P+j);
        end
    end
    
     %2D
       if(dim == 2)
           % Basis/Shape functions (B)
           B_hat = kron(B,B); 
           % Derivative of Basis/Shapefunctions (D)
           D_hat = [kron(D,B);kron(B,D)];           
           % weights (W_hat)
           W_hat = kron(W',W');
       end

       %3D
       if(dim == 3)
           % Basis/Shape functions (B)
           B_hat = kron(kron(B,B),B); 
           % Derivative of Basis/Shapefunctions (D_hat)
           D_hat = [kron(kron(D,B),B); kron(kron(B,D),D);kron(kron(B,D),D)];
           % weights (W_hat)
           W_hat = kron(kron(W',W'), W');
       end    


        
end

