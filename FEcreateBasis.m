function [B, D, W, Q] = FEcreateBasis(P,Q, Qmode)

 dof = P + 1;
 %[nodes, ~ ] = LobattoQuadrature(P); 
 if(strcmp(Qmode, 'GAUSS'))
     %extend this to higher order than 2 based on C code later
     [qref1d, W] = GaussQuadrature(Q);
     x = qref1d;
     if dof==2
         BHat = [(1-x)/2; (1+x)/2];
         DHat = [-1/2+0*x; 1/2+0*x];
     elseif dof==3
         BHat = [(x.^2 - x)/2; (1-x.^2); (x.^2+x)/2];
         DHat = [x-1/2; -2*x; x+1/2];
     else
         error('Polynomial order is not supported!');
     end     

 elseif(strcmp(Qmode, 'LGL'))
     [qref1d, W] = LobattoQuadrature(Q-1);     
     x = qref1d;
     if dof==2
         BHat = [(1-x)/2; (1+x)/2];
         DHat = [-1/2+0*x; 1/2+0*x];
     elseif dof==3
         BHat = [(x.^2 - x)/2; (1-x.^2); (x.^2+x)/2];
         DHat = [x-1/2; -2*x; x+1/2];
     else
         error('Polynomial order is not supported!');
     end 
 else
     error('Qmode error! Choose GAUSS or LGL Quadrature points!');
 end


 B = reshape(BHat,dof*Q,1)';
 D = reshape(DHat,dof*Q,1)';
 W = W;
 Q = qref1d;

end

function [qref1d,W] = GaussQuadrature(Q)
%input: Q: Number of quadrature points (Gauss)
%output:qref1d: Gauss quadrature points
%       W: Gauss weights
% Golub-Welsch algorithm: (Brute force version by Trefethen-Bau)
% to calculate Gauss points and weights using Legendre weight function 
%
    beta = 0.5./sqrt(1-(2*(1:Q-1)).^(-2));
    [V,D]=eig(diag(beta,1)+diag(beta,-1));
    [x,i]=sort(diag(D)); 
    w=2*V(1,i).^2';

    W = w';
    qref1d = x';
end

function [qref1d, W] = LobattoQuadrature(Q)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
% Computes the Legendre-Gauss-Lobatto nodes, weights and the LGL Vandermonde
% matrix. The LGL nodes are the zeros of (1-x^2)*P'_Q(x). Useful for numerical
% integration and spectral methods.
%
% Reference on LGL nodes and weights:
%   C. Canuto, M. Y. Hussaini, A. Quarteroni, T. A. Tang, "Spectral Methods
%   in Fluid Dynamics," Section 2.3. Springer-Verlag 1987
%
% Written by Greg von Winckel - 04/17/2004
% Contact: gregvw@chtm.unm.edu
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Truncation + 1
    Q1=Q+1;

    % Use the Chebyshev-Gauss-Lobatto nodes as the first guess
    x=-cos(pi*(0:Q)/Q)';

    % The Legendre Vandermonde Matrix
    P=zeros(Q1,Q1);

    % Compute P_(Q) using the recursion relation
    % Compute its first and second derivatives and
    % update x using the Newton-Raphson method.

    xold=2;

    while max(abs(x-xold))>eps

        xold=x;

        P(:,1)=1;    P(:,2)=x;

        for k=2:Q
            P(:,k+1)=( (2*k-1)*x.*P(:,k)-(k-1)*P(:,k-1) )/k;
        end

        x=xold-( x.*P(:,Q1)-P(:,Q) )./( Q1*P(:,Q1) );

    end

    w=2./(Q*Q1*P(:,Q1).^2);
    W = w';
    qref1d = x';
    
 end