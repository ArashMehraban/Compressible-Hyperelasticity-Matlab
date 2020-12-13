function C = MatMultMat3D(A,B)
%MatMult3D is capable of multiplying 3x3xN by 3x3xN and 2x2xN by 2x2xN
%matrices.
%input: A
%     : B
%
%output: C 3x3xN or 2x2xN
 
    [rA,cA,dA] = size(A);
    [rB,cB,dB] = size(B);
    if(rA ~= rB || cA ~= cB || dA ~=dB)
        error('size mismatch')
    end
    if(rA == 3 && cA == 3)
      C = MatMultMat3D_3x3(A,B,rA,cA,dA);  
    end
    
    if(rA == 2 && cA == 2)
      C = MatMultMat3D_2x2(A,B,rA,cA,dA);  
    end
    
    if(rA ~= cA)
        error('I can do square 2x2 and 3x3 matrices only!')
    end
end

function C = MatMultMat3D_2x2(A,B,rA,cA,dA)
%A = B = 2x2xdA

    C = zeros(rA,cA,dA);
    i  = 1:dA;
    C(1,1,i) = A(1,1,i).*B(1,1,i) + A(1,2,i).*B(2,1,i);
    C(1,2,i) = A(1,1,i).*B(1,2,i) + A(1,2,i).*B(2,2,i);

    C(2,1,i) = A(2,1,i).*B(1,1,i) + A(2,2,i).*B(2,1,i);
    C(2,2,i) = A(2,1,i).*B(1,2,i) + A(2,2,i).*B(2,2,i); 
end

function C = MatMultMat3D_3x3(A,B,rA,cA,dA)
%A = B = 3x3xdA
  
    C = zeros(rA,cA,dA);
    i  = 1:dA;
    C(1,1,i) = A(1,1,i).*B(1,1,i) + A(1,2,i).*B(2,1,i) + A(1,3,i).*B(3,1,i);
    C(1,2,i) = A(1,1,i).*B(1,2,i) + A(1,2,i).*B(2,2,i) + A(1,3,i).*B(3,2,i);
    C(1,3,i) = A(1,1,i).*B(1,3,i) + A(1,2,i).*B(2,3,i) + A(1,3,i).*B(3,3,i);

    C(2,1,i) = A(2,1,i).*B(1,1,i) + A(2,2,i).*B(2,1,i) + A(2,3,i).*B(3,1,i);
    C(2,2,i) = A(2,1,i).*B(1,2,i) + A(2,2,i).*B(2,2,i) + A(2,3,i).*B(3,2,i);
    C(2,3,i) = A(2,1,i).*B(1,3,i) + A(2,2,i).*B(2,3,i) + A(2,3,i).*B(3,3,i);

    C(3,1,i) = A(3,1,i).*B(1,1,i) + A(3,2,i).*B(2,1,i) + A(3,3,i).*B(3,1,i);
    C(3,2,i) = A(3,1,i).*B(1,2,i) + A(3,2,i).*B(2,2,i) + A(3,3,i).*B(3,2,i);
    C(3,3,i) = A(3,1,i).*B(1,3,i) + A(3,2,i).*B(2,3,i) + A(3,3,i).*B(3,3,i);
    
end