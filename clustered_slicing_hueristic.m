function [z,x,y, x0] = clustered_slicing_hueristic(w,h,W,H, cuts)
% Implements 2 stage 1d knapsack problem method
m=length(cuts)-1;
n=length(w);

for i=1:m
    c{i}=find( (cuts(i) < h).*(cuts(i+1)>=h));
    gh(i)=max(h(c{i}));
    [z,v(i)]=solveKnapsack(w(c{i}),w(c{i}), W);
    zg{i}=c{i}(find(z>0.5));
end

[slices]=solveKnapsack((-v.*gh)', gh', H);

z=[];
x=[];
y=[];

yk=0;
for i=find(slices>0.5)'
    xk=0;
    z=[z;zg{i}];
    for j=zg{i}'
        x=[x;xk];
        y=[y;yk];
        xk=xk+w(j);
    end
    yk=yk+gh(i);
end
draw_rectangles(z,x,y,w(z),h(z),W,H)

x0=zeros(3*n, 1);

x0(z)=1;
x0(z+n)=x;
x0(z+2*n)=y;

dy=zeros(n,n);
dx=zeros(n,n);

for i=1:length(z)
    for j=1:length(z)
       if z(i)> z(j)
           %fprintf("i %i, j %i \n",z(i), z(j))
            if x(i)+w(z(i)) <= x(j)% is i to the left of j?
                dx(z(i),z(j))=1;
            elseif x(j)+w(z(j)) <= x(i)% is j to the left of i?
                dx(z(j),z(i))=1;
            elseif y(i) +h(z(i)) <= y(j)% is i below j?
                dy(z(i),z(j))=1;
            elseif y(j)+h(z(j)) <=y(i)% is j below i?
                dy(z(j),z(i))=1;
            end
        end
    end
end
x0=[x0;dx(:);dy(:)];
    function [z,obj]=solveKnapsack(v,w, C)
        %solves max z_i v_i
        %       s.t. sum z_i w_i \leq C
        
        A=w';
        b=C;
        f=-v';
        intcon=1:length(v);
        z = intlinprog(f,intcon,A,b,[],[],zeros(size(f')),ones(size(f')));
        obj= f*z;
    end
end