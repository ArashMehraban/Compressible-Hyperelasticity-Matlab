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

  % Build qref1d, qweight1d
  % Set endpoints
  wi = 2.0/((Q*(Q-1)));
  qweight1d(1) = wi;
  qweight1d(Q) = wi;
 
  qref1d(1) = -1.0;
  qref1d(Q) = 1.0;
  % Interior
  for i = 2:floor((Q-1)/2) 
    % Guess
    xi = cos(pi*(i-1)/(Q-1));

    % Pn(xi)
    P0 = 1.0;
    P1 = xi;
    P2 = 0.0;
    for j=2:Q-1 
      P2 = (((2*j-1))*xi*P1-((j-1))*P0)/(j);
      P0 = P1;
      P1 = P2;
    end
    % First Newton step
    dP2 = (xi*P2 - P0)* Q/(xi*xi-1.0);
    d2P2 = (2*xi*dP2 - (Q*(Q-1))*P2)/(1.0-xi*xi);
    xi = xi-dP2/d2P2;
    % Newton to convergence
    for k=1:101
     if(abs(dP2)> 1e-15)
      P0 = 1.0;
      P1 = xi;
      for (PetscInt j = 2; j < Q; j++) {
        P2 = (((PetscScalar)(2*j-1))*xi*P1-((PetscScalar)(j-1))*P0)/((PetscScalar)(j));
        P0 = P1;
        P1 = P2;
      }
      dP2 = (xi*P2 - P0)*(PetscScalar)Q/(xi*xi-1.0);
      d2P2 = (2*xi*dP2 - (PetscScalar)(Q*(Q-1))*P2)/(1.0-xi*xi);
      xi = xi-dP2/d2P2;
     end
    end
    // Save xi, wi
    wi = 2.0/(((PetscScalar)(Q*(Q-1)))*P2*P2);
    if (qweight1d) {
      qweight1d[i] = wi;
      qweight1d[Q-1-i] = wi;
    }
    qref1d[i] = -xi;
    qref1d[Q-1-i]= xi;
    end
    
 end