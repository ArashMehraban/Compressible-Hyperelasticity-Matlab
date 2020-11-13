function [B, D, W] = FEcreateBasis(P,Q, Qmode)

 B = zeros(P*Q,1);
 D = zeros(P*Q,1);
 W = zeros(Q);
 qref1d =zeros(Q);
 nodes = zeros(P);
 
 %[nodes, ~ ] = LobattoQuadrature(P); 
 if(strcmp(Qmode, 'GAUSS'))
     %extend this to higher order than 2 based on C code later
     [qref1d, W] = GaussQuadrature(Q);
     
 elseif(strcmp(Qmode, 'GLL'))
     [qref1d, W] = LobattoQuadrature(Q);     
 else
     error('Qmode error! Choose GAUSS or GLL Quadrature points!');
 end
 

end

function [qref1d, W] = LobattoQuadrature(Q)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% lglnodes.m
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

    W=2./(Q*Q1*P(:,Q1).^2);
    qref1d = x;
    
 end