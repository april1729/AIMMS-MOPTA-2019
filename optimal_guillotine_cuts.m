function optimal_guillotine_cuts(w,h,W,H)

n=length(w);
m=5;

A=sparse(1,m*n+m);
b=[];

for j=1:m
    k=length(b)+1;
    for i=1:n
        A(k, get_index_Z(i,j))=w(i);
    end
    b(k)=W;
end



for i=1:n
    for j=1:m
        k=length(b)+1;
        A(k,get_index_Z(i,j))=h(i);
        A(k, get_index_g(j))=-1;
        b(k)=0;
    end
end


k=length(b)+1;
for j=1:m
    A(k, get_index_g(j))=1;
    b(k)=H;
end


for i=1:n
    k=length(b)+1;
    for j=1:m
        A(k, get_index_Z(i,j))=1;
    end
    b(k)=1;
end


for j=1:m-1
    k=length(b)+1;
    A(k, get_index_g(j))=-1;
    A(k, get_index_g(j+1))=1;
    b(k)=0;
end

f=zeros(m*n+m,1);
for i=1:n
    for j=1:m
        f(get_index_Z(i,j))=-w(i)*h(i);
    end
end
lb=zeros(size(f));
ub=ones(size(f));
ub(1:n*m)=1;
ub(n*m+1:n*m+m)=H;
intcon=1:n*m;
soln = intlinprog(f,intcon,A,b,[],[],lb,ub);

Z=round(reshape(soln(1:n*m), [n,m]));
g=soln(n*m+1:end);

objects_used=[];
x=[];
y=[];
yi=0;
for j=1:m
    xi=0;
    if sum(Z(:,j))==0
        break
    end
    objects_used=[objects_used;find(Z(:,j)==1)];
    for obj=find(Z(:,j)==1)'
        x=[x, xi];
        y=[y,yi];
        xi=xi+w(obj);
    end
    yi=yi+g(j);
end


draw_rectangles(objects_used,x,y,w(objects_used),h(objects_used), W,H)

    function ind=get_index_Z(i,j)
        ind=n*(j-1)+i;
    end

    function ind=get_index_g(i)
        ind=m*n+i;
    end


end