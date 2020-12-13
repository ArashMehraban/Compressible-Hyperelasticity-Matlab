function Atranspose = MatTrans3D(A)
%Trans3D transposes every slice of a 3D matrix. An MxNxD becomes NxMxD.
  Atranspose= permute(A,[2,1,3]);
end