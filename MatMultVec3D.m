function Mat3dresult =  MatMultVec3D(mat, vec)
%MatMultVec3D multiplys elements of a vector of size 1xD (or Dx1) by 2D
%slices of 3D matrix of size MxNxD
%
%input: vect : a vertical or a horizontal vector of size 1xD (or Dx1)
%     : mat  : 3D matrix of size MxNxD
%
%output: Mat3dresult where each slice of mat input is scaled by the corresponding
%        scalar element of vec input (ith element of vec multiplied by ith slice of mat)

  [rv, cv] = size(vec);
  [~, ~, dmat] = size(mat);
  if(rv ~= dmat || cv ~= dmat)
      error('size mismatch!')
  end

   Mat3dresult = bsxfun(@times,mat,reshape(v,1,1,dmat));
end