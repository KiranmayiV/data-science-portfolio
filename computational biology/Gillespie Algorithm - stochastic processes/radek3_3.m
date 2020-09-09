rand('state',6);

D=0.0001;         % 10^{-4} mm^2 sec^{-1}
finaltime=4*60;   % 4 minutes
numberofmolecules=1000;

n=40;
h=1/n;
mesh=[h/2:h:1-h/2];

A=zeros(n,1);

A(15)=numberofmolecules/2;
A(16)=numberofmolecules/2;

time=0;

while (time<finaltime)
       rr=rand(2,1);
       a0=2*D/(h*h)*(numberofmolecules-A(1)/2-A(n)/2);          
       time=time+(1/a0)*log(1/rr(1));
       ss=0;
       k=0;
       while ((ss<=rr(2)*a0)&(k<n-1))
              k=k+1;
              ss=ss+D/(h*h)*A(k);
       end;
       if (ss>rr(2)*a0) 
           A(k)=A(k)-1;
           A(k+1)=A(k+1)+1;
       else
           k=1;
           while ((ss<=rr(2)*a0)&(k<n))
                  k=k+1;
                  ss=ss+D/(h*h)*A(k);
           end;
           A(k)=A(k)-1;
           A(k-1)=A(k-1)+1;
       end;
end;
