function [B1d, D1d, W, qref1d] = FEcreateBasis(P,Q, Qmode)
% FECREATEBASIS creates and evaluates basis/shape function and their derivative 
% at quadrature points (Q) for the polynomial order P. 
%  input: 
%       P: polynomial degree + 1
%       Q: Number of quadrature points
%   Qmode: GAUSS or GLL quadrature points
% output:
%     B1d: basis/shape function evaluated at quadrature points
%     D1d: derivative of basis/shape function evaluated at quadrature points
%       W: quadrature weights
%  qref1d: quadrature points computed by GAUSS or LGL

% get Legendre-Gauss-Lobatto nodes (or quadrature points)
  [nodes, ~ ] = LobattoQuadrature(P); 
  if(strcmp(Qmode, 'GAUSS'))
     % populate a 1D array with GAUSS quadrature points and weights
     [qref1d, W] = GaussQuadrature(Q);
     % populate a 1D array for B1d and D1d described above in outputs
     [B1d, D1d] = FEBasisEval(P, Q, nodes, qref1d);
  elseif(strcmp(Qmode, 'GLL'))
     % populate a 1D array with GLL quadrature points and weights
     [qref1d, W] = LobattoQuadrature(Q);   
     % populate a 1D array for B1d and D1d described above in outputs  
     [B1d, D1d] = FEBasisEval(P, Q, nodes, qref1d);
  else
     error('Qmode error! Choose GAUSS or GLL Quadrature points!');
  end

end

function [qref1d,w] = GaussQuadrature(Q)
%GAUSSQUADRATURE computes Gauss quadrature points and weight in 1D
% input:
%      Q: Number of GAUSS quadrature points
% output: 
%     qref1d: Gauss quadrature points in 1D
%          W: Gauss weights in 1D

    beta = 0.5./sqrt(1-(2*(1:Q-1)).^(-2));
    [V,D]=eig(diag(beta,1)+diag(beta,-1));
    [x,i]=sort(diag(D)); 
    w=2*V(1,i).^2;
    qref1d = x';
end

function [qref1d, W] = LobattoQuadrature(Q)
%LOBATTOQUADRATURE computes GLL quadrature points and weight in 1D
% input:
%      Q: Number of GLL quadrature points
% output: 
%     qref1d: GLL quadrature points in 1D
%
    % Use the Chebyshev-Gauss-Lobatto nodes as the first guess
    x=-cos(pi*(0:Q-1)/(Q-1))';
    % The Legendre Vandermonde Matrix
    Vmat=zeros(Q,Q);
    xold=2;
    while max(abs(x-xold))>eps
        xold=x;
        Vmat(:,1)=1; 
        Vmat(:,2)=x;
        for k=2:Q-1
            Vmat(:,k+1)=( (2*k-1)*x.*Vmat(:,k)-(k-1)*Vmat(:,k-1) )/k;
        end
        x=xold-( x.*Vmat(:,Q)-Vmat(:,Q-1))./( Q*Vmat(:,Q));
    end
    W=(2./((Q-1)*Q*Vmat(:,Q).^2))';
    qref1d = x';    
end


function [B1d, D1d] = FEBasisEval(P, Q, nodes, qref1d)
% FEBASISEVAL populates B1d and D1d of order P at quadrature points Q.
%  input: 
%        P: degree of Lagrange polynomial or shape functions
%        Q: Number of quadrature points
% output:
%        B1d: see above for description
%        D1d: see above for description

B1d = zeros(1,P*Q);
D1d = zeros(1,P*Q);

for i = 1:Q
    c1 = 1.0;
    c3 = nodes(1) - qref1d(i);
    B1d((i-1)*P+1) = 1.0;
    for j = 2:P
        c2 = 1.0;
        c4 = c3;
        c3 = nodes(j) - qref1d(i);
            for k = 1:j-1
                dx = nodes(j) - nodes(k);
                c2 = c2*dx;
                if k == j-1
                    D1d((i-1)*P + j) = c1*(B1d((i-1)*P + k) - c4*D1d((i-1)*P + k)) / c2;
                    B1d((i-1)*P + j) = - c1*c4*B1d((i-1)*P + k) / c2;
                end
                D1d((i-1)*P + k) = (c3*D1d((i-1)*P + k) - B1d((i-1)*P + k)) / dx;
                B1d((i-1)*P + k) = c3*B1d((i-1)*P + k) / dx;
            end
        c1 = c2;
    end
end

end