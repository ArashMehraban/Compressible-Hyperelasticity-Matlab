function [dets, inverseJacobian] = invJacobian(mat, dim)
%INVJACOBIAN computes the inverse Jacobian of matrices. Input dim
%determintes if it is 2x2 or 3x3. 
%Note: INVJACOBIAN is designed to handle ((2x2) by n) and ((3x3) by n) 
%      matrices. User can reshape n 2x2 or 3x3 matrices in a 3-dimensional
%      array to compute them all using vectorized operations for
%      performance.
%
%input: 
%        mat: 2x2xn or 3x3xn matrices 
%        dim: dim = 2 expects 2x2 and dim = 3 expects 3x3 matrices 
%      
%output:            dets : derterminants per 2x2 or 3x3 matricies 
%        inverseJacobian : Inverse Jacobian per 2x2 or 3x3 matrices
%            
     

  if dim == 2
     computeInv = @computeInv2D; 
  end
  if dim == 3
     computeInv = @computeInv3D; 
  end
  [dets, inverseJacobian] = computeInv(mat);

end

%Compute the Inverse of 2x2 matricies
function [detJ, inv2D] = computeInv2D(Je)
   [~,~,d] = size(Je);
   i =1:d;
   detJ(i) = Je(1,1,i) * Je(2,2,i) - Je(1,2,i) * Je(2,1,i);
   
   detCheckIfNonZero=zeros(size(detJ,1),1);
   if(isempty(detCheckIfNonZero(detCheckIfNonZero < 0)))
       error('Defective element! Negative determinant in element Jacobian');   
   end
   
   inv2D(:,:,i) = [Je(2,2,i) , -Je(1,2,i); -Je(2,1,i), Je(1,1,i)];
   
   invDetJ = 1./detJ;    
   for j = 1:d
       inv2D(:,:,j) = invDetJ(j)*inv2D(:,:,j);
   end
end

%Compute the Inverse of 3x3 matricies
function [detJ, inv3D] = computeInv3D(Je)
   [~,~,d] = size(Je);
   i =1:d;
   detJ(i) =   Je(1,1,i).*(Je(2,2,i).*Je(3,3,i) - Je(2,3,i).*Je(3,2,i)) - Je(1,2,i).*(Je(2,1,i).*Je(3,3,i) - Je(2,3,i).*Je(3,1,i)) + Je(1,3,i).*(Je(2,1,i).*Je(3,2,i) - Je(2,2,i).*Je(3,1,i));
   
   detCheckIfNonZero=zeros(size(detJ,1),1);
   if(isempty(detCheckIfNonZero(detCheckIfNonZero < 0)))
       error('Defective element! Negative determinant in element Jacobian');   
   end
   
   inv3D(:,:,i) = [Je(2,2,i).*Je(3,3,i) - Je(2,3,i).*Je(3,2,i) , Je(1,3,i).*Je(3,2,i) - Je(1,2,i).*Je(3,3,i), Je(1,2,i).*Je(2,3,i) - Je(1,3,i).*Je(2,2,i); 
                               Je(2,3,i).*Je(3,1,i) - Je(2,1,i).*Je(3,3,i) , Je(1,1,i).*Je(3,3,i) - Je(1,3,i).*Je(3,1,i), Je(1,3,i).*Je(2,1,i) - Je(1,1,i).*Je(2,3,i);
                               Je(2,1,i).*Je(3,2,i) - Je(2,2,i).*Je(3,1,i) , Je(1,2,i).*Je(3,1,i) - Je(1,1,i).*Je(3,2,i), Je(1,1,i).*Je(2,2,i) - Je(1,2,i).*Je(2,1,i)];
   invDetJ = 1./detJ;
   for j = 1:d
       inv3D(:,:,j) = invDetJ(j)*inv3D(:,:,j);
   end
end
  