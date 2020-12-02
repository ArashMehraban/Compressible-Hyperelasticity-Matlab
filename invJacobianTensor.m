function [detsInvJe, inverseElemVtxJacobian] = invJacobianTensor(elem_vtx_coords, D_hat, Q, dim)
%INVJACOBIANTENSOR computes the inverse Jacobian of an element vertex coordinates 
%for all Quadrature points. 
%INVJACOBIANTENSOR assumes coordinates are reordered lexographically 
%
%input: 
%      elem_vtx_coords: one element vertex coordinates
%         D_hat tensor: see tensor() function for details
%                    Q: number of Quadrature Points
%      
%output:            dets : derterminants for all quadrature points
%        elemVtxJacobian : inverse of element vertex coordinate Jacobian for 
%        all quadrature points 
%            


  %2D:                 
  %  permuted_jac = [D0x  D0y]  
  %                 [D1x  D1y] 24x3 for one Q1 element with 8 Quad Pts
  %
  %3D:              [D0x D0y D0z]  
  %  permuted_jac = [D1x D1y D1z]
  %                 [D2x D2y D2z] 81x3 for one Q2 element with 27 Quad Pts
  permutedJac = D_hat*elem_vtx_coords;
  dets = zeros(Q,1);
  [r,c] = size(permutedJac);
  inverseElemVtxJacobian = zeros(r,c);
  if dim == 2
     computeInv = @computeInv2D; 
  end
  if dim == 3
     computeInv = @computeInv3D; 
  end
  
  j=1;
  for i=1:dim:r
      temp = permutedJac(i:i+dim-1,:);
      [jdet , invTemp] = computeInv(temp);
      if(jdet < 0)
         error('Defective element! Negative determinant in Jacobian');
      end
      dets(j) = jdet;
      inverseElemVtxJacobian(i:i+dim-1,:) = invTemp;      
      j=j+1;
  end
  detsInvJe = 1./dets;
end

%Compute the Inverse of a 2x2 matrix
function [detJ, inv2D] = computeInv2D(Je)
   detJ = Je(1,1) * Je(2,2) - Je(1,2) * Je(2,1);
   inv2D = 1/detJ * [Je(2,2) , -Je(1,2); -Je(2,1), Je(1,1)];
end

%Compute the Inverse of a 3x3 matrix
function [detJ, inv3D] = computeInv3D(Je)
    detJ =   Je(1,1)*(Je(2,2)*Je(3,3) - Je(2,3)*Je(3,2)) - Je(1,2)*(Je(2,1)*Je(3,3) - Je(2,3)*Je(3,1)) + Je(1,3)*(Je(2,1)*Je(3,2) - Je(2,2)*Je(3,1));
    
    inv3D = 1/detJ * [Je(2,2)*Je(3,3) - Je(2,3)*Je(3,2) , Je(1,3)*Je(3,2) - Je(1,2)*Je(3,3), Je(1,2)*Je(2,3) - Je(1,3)*Je(2,2); 
                      Je(2,3)*Je(3,1) - Je(2,1)*Je(3,3) , Je(1,1)*Je(3,3) - Je(1,3)*Je(3,1), Je(1,3)*Je(2,1) - Je(1,1)*Je(2,3);
                      Je(2,1)*Je(3,2) - Je(2,2)*Je(3,1) , Je(1,2)*Je(3,1) - Je(1,1)*Je(3,2), Je(1,1)*Je(2,2) - Je(1,2)*Je(2,1)];
end



  

  