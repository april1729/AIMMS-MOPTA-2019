function [z,x,y] = global_solver_milp(l,w,L,W)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

n=length(l);

A=sparse(5*n^2+1,3*n+2*n^2);
b=zeros(5*n^2+1,1);
intcon=[1:n, 3*n+1:3*n+2*n^2];

for i=1:n
    for j=1:n
        if i~=j
            
            k=get_constraint_number(A);
            A(k,get_index_x(1,i))=1;
            A(k,get_index_x(1,j))=-1;
            A(k,get_index_c(1,i,j))=L;
            b(k)=L-l(i);
            
            k=get_constraint_number(A);
            A(k,get_index_x(2,i))=1;
            A(k,get_index_x(2,j))=-1;
            A(k,get_index_c(2,i,j))=W;
            b(k)=W-w(i);
            
            if i>j
                k=get_constraint_number(A);
                A(k, i)=1;
                A(k,j)=1;
                A(k,get_index_c(1,i,j))=-1;
                A(k,get_index_c(1,j,i))=-1;
                A(k,get_index_c(2,i,j))=-1;
                A(k,get_index_c(2,j,i))=-1;
                b(k)=1;
            end
        end
    end
end

% Knapsack constraint
k=get_constraint_number(A);
A(k, 1:n)=1*(l.*w);
b(k)=L*W;

% we need to take at least x items, elimates a ton of bad points


% if we arent using a particular object, dont worry about the placement
% constraints for it 

for i=1:n
    for j=1:n
        
    k=get_constraint_number(A);
    A(k, i)=-1;
    A(k, get_index_c(1,i,j))=1;
    b(k)=0;
    
    k=get_constraint_number(A);
    A(k, i)=-1;
    A(k, get_index_c(1,j,i))=1;
    b(k)=0;
    
    k=get_constraint_number(A);
    A(k, i)=-1;
    A(k, get_index_c(2,i,j))=1;
    b(k)=0;
    
    k=get_constraint_number(A);
    A(k, i)=-1;
    A(k, get_index_c(2,j,i))=1;
    b(k)=0;

    end
end


f=zeros(3*n+2*n^2,1);
f(1:n)=-1*(l.*w);

lb=zeros(size(f));
ub=ones(size(f));
ub(n+1:2*n)=L-l;
ub(2*n+1:3*n)=W-w;

soln = intlinprog(f,intcon,A,b,[],[],lb,ub);



z=find(soln(1:n)>0.5);
x=soln((n+1):2*n);
y=soln((2*n+1):3*n);
cx=reshape(soln(3*n+1:3*n+n^2), [n,n]);
cy=reshape(soln(3*n+n^2+1:3*n+2*n^2), [n,n]);

draw_rectangles(z,x(z),y(z),l(z),w(z), L, W)


    function k=get_index_c(x_or_y,i,j)
        C=zeros(n,n);
        C(i,j)=1;
        if x_or_y==1 % get cx index
            k=3*n+find(C(:)==1);
        else %get cy index
            k=3*n+n^2+find(C(:)==1);
        end
    end

    function k=get_index_x(x_or_y,i)
        
        if x_or_y==1 % get x index
            k=n+i;
        else %get y index
            k=2*n+i;
        end
    end

    function k=get_constraint_number(A)
        k=min(find(sum(abs(A), 2)==0));
    end 

end