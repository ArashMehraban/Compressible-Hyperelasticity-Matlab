function [B, D, W, qref1d] = FEcreateBasis(P,Q, Qmode)
% This function evaluates the 1D shape function B and its derivative 
% D of order P at quadrature points Q usingg either GAUSS or LGL
% input: 
% P: degree of Lagrange polynomial or shape functions, note degree = P-1
% Q: Number of quadrature points
% Qmode: GAUSS or LGL method for computing quadrature points
% output:
% B: 1D shape function of size (1 x P*Q) evaluated at quadrature points
% D: 1D derivative of shape function of size (1 x P*Q) evaluated at quadrature points
% W: quadrature weight computed by GAUSS or LGL
% qref1d: quadrature points computed by GAUSS or LGL

% get Legendre-Gauss-Lobatto nodes (or quadrature points)
 [nodes, ~ ] = LobattoQuadrature(P); 
 if(strcmp(Qmode, 'GAUSS'))
     % get the quadrature points and weights using GAUSS
     [qref1d, W] = GaussQuadrature(Q);
     % get the Basis and its derivative as an 1xPQ array
     [B1d, D1d] = FEBasisEval(P, Q, nodes, qref1d);
 elseif(strcmp(Qmode, 'GLL'))
     % get the quadrature points and weights using LGL
     [qref1d, W] = LobattoQuadrature(Q);   
     % get the Basis and its derivative as an 1xPQ array  
     [B1d, D1d] = FEBasisEval(P, Q, nodes, qref1d);
 else
     error('Qmode error! Choose GAUSS or GLL Quadrature points!');
 end
 B = B1d;
 D = D1d;
end

function [qref1d,w] = GaussQuadrature(Q)
%input  : Q: Number of quadrature points (Gauss)
%output : qref1d: Gauss quadrature points in 1D
%         W: Gauss weights
% Golub-Welsch algorithm: (Brute force version by Trefethen-Bau)
% to calculate Gauss points and weights using Legendre weight function 
%
    beta = 0.5./sqrt(1-(2*(1:Q-1)).^(-2));
    [V,D]=eig(diag(beta,1)+diag(beta,-1));
    [x,i]=sort(diag(D)); 
    w=2*V(1,i).^2;
    qref1d = x';
end

function [qref1d, W] = LobattoQuadrature(Q)
    % Use the Chebyshev-Gauss-Lobatto nodes as the first guess
    x=-cos(pi*(0:Q-1)/(Q-1))';
    % The Legendre Vandermonde Matrix
    Vmat=zeros(Q,Q);
    % Compute P_(Q) using the recursion relation
    % Compute its first and second derivatives and
    % update x using the Newton-Raphson method.
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
% This function evaluates the 1D shape function B1d and its derivative 
% D1d of order P at quadrature points Q.
% input: 
% P: degree of Lagrange polynomial or shape functions
% note P = degree + 1 ==> P = 2, returns B1d = [B1d_1 B1d_2]
% Q: Number of quadrature points,
% example Q = 2, P = 2 returns B1d = [B1d_1(Q1) B1d_2(Q1) B1d_1(Q2) B1d_2(Q2)]
% nodes: it is Legendre-Gauss-Lobatto nodes computed by LobattoQuadrature function
% qref1d: quadrature points computed by GAUSS or LGL
% output:
% B1d: 1D shape function of size (1 x P*Q) evaluated at quadrature points
% D1d: 1D derivative of shape function of size (1 x P*Q) evaluated at quadrature points

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