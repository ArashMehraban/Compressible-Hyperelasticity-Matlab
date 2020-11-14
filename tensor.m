function y = tensor(ne,dof,P,Q,Rf,Sf,Tf,x)
%TENSOR applies the tensor contraction to input vector x an returns
%contracted vector y.
%inputs: ne  :number of elements to operate on
%        dof :number of components of a field
%        P   :polynomial degree + 1 
%        Q   :number of quadrature points
%        Rf  : B or D in 1-dimention (in form of a horizontal vector)
%        Sf  : B or D in 1-dimention (in form of a horizontal vector)
%        Tf  : B or D in 1-dimention (in form of a horizontal vector)
%        x   : input vector 
%output: y   : output results

x = reshape(x,[],P*P*P,ne); %reshape input x
u = zeros(dof,Q*P*P,ne); %holder variable
v = zeros(dof,Q*Q*P,ne); %holder variable
y = 0*x; %Output
    R = zeros(Q,P);
    S = zeros(Q,P);
    T = zeros(Q,P);
    
    
    for i=1:Q
        for j=1:P
            R(i,j) = Rf((i-1)*P+j);
            S(i,j) = Sf((i-1)*P+j);
            T(i,j) = Tf((i-1)*P+j);
        end
    end

for i=1:P
    for l=1:dof
        for a=1:Q
            for jk=1:P*P
                for e=1:ne
                    u(l, (a-1)*P*P+jk,e) = u(l, (a-1)*P*P+jk,e) + R(a,i) * x(l,(i-1)*P*P+jk,e);
                end
            end
         end
     end
end
 

     % v[l,a,b,k] = S[b,j] u[l,a,j,k]
        for l=1:dof
          for a=1:Q
            for k=1:P
              for j=1:P
                for b=1:Q
                  for e=1:ne
                      v(l, (((a-1)*Q+b)-1)*P+k,e) = v(l, (((a-1)*Q+b)-1)*P+k,e) + S(b,j) * u(l, (((a-1)*P+j)-1)*P+k,e);
                  end
                end
              end
            end
          end
        end
        
        

        % y[l,a,b,c] = T[c,k] v[l,a,b,k]
        for l=1:dof
          for ab=1:Q*Q
            for k=1:P
              for c=1:Q
                for e=1:ne
                    y(l, (ab-1)*Q+c,e) = y(l, (ab-1)*Q+c,e) + T(c,k) * v(l, (ab-1)*P+k,e);
                end
              end
            end
          end
        end
        
        y = reshape(y,1,[]);
        
end

