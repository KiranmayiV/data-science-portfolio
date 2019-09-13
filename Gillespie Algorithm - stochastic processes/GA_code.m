%% section 2.1
%a1-b1

a=20;
k=0.1;
ds=0.005;
s=0;
store_a=zeros(10^5,1);
for i=1:10^5
    r=rand(1,1);
    if r < a*k*ds
        a = a - 1 ;
        store_a(i,1)= a;
    else
        store_a(i,1)= a; 
    end
    s=s+ds;
    store_a(i,2)=s;
end
figure(1);
stairs(store_a(:,2),store_a(:,1),'r')

%a2-c2
a=20;
k=0.1;
store_a=zeros(10^4,4);
t=0;

for i=1:10^4
    r=rand(1,1);
    tau=(1/(a*k))*reallog(1/r);
    t = t + tau;
    a= a -1;
    if a ==0
        t = t + tau;
        store_a(i,2) = t;
        break
    end
    store_a(i,1) = a;
    store_a(i,2) = t;
    
end

figure(2);
stairs(store_a(1:20,2),store_a(1:20,1),'b*-')
plot(store_a(1:49,2),store_a(1:49,1),'*')
% mean by master equation
a=20;
n=exp(-k.*store_a(1:20,2));
m=a.*n;
plot(store_a(1:20,2),m,'r--')

%% section 2.2
% a3-d3


for x =1:5
    a=0;
    k1=0.1;
    k2=1;
    t=0;
    for i =1:10^5
        r1=rand(1,1);
        r2=rand(1,1);
        alpha=a*k1 + k2;
        tau=(1/alpha)*reallog(1/r1);

        if r2 >= (k2/alpha) % happens only at t=t + tau
            a= a -1;
        else
            a =a + 1;        
        end
        t=t + tau;
        store_a(i,x)=a;
        store_t(i,x)=t;

    end
end
%plots
figure();
stairs(store_t(:,1),store_a(:,1))
hold on
stairs(store_t(:,2),store_a(:,2),'r')
hold on
stairs(store_t(:,3),store_a(:,3),'k')
hold on
stairs(store_t(:,4),store_a(:,4),'m')
hold on
stairs(store_t(:,5),store_a(:,5),'g')
%mean plot
[T,Y] = ode23(@ode,[0 10000],0);
hold on
plot(T,Y,'k*-')

% histogram
max(store_a(:,1))
hist(store_a(:,1),26)
bar(hist(store_a(:,1),26)./10^5)
%stationary distribution
 x=[0 1];
 k1=0.1;
 k2=1; 
for n=3:30
x(n)=(exp(-k2/k1)/factorial(n))*(k2/k1)^n;
end
x(1)=[];
x(2)=0;
y=x./sum(x);
figure();
plot(y)

%% section 2.3

%for z=1:5
    a=0;
    b=0;
    k1=.001;
    k2=0.01;
    k3=1.2;
    k4=1;
    t=0;
    alpha1=0;
    alpha2=0;
    alpha3=0;
    alpha4=0;
    alpha=0;
    for i =1:10^6
        r=rand(2,1);        
        alpha1=a*(a-1)*k1;
        alpha2=a*b*k2;
        alpha3=k3;
        alpha4=k4;
        alpha=alpha1+alpha2+alpha3+alpha4;
        tau=(1/alpha)*reallog(1/r(1));
        mu=r(2)*alpha ;
        if mu < alpha1 % happens only at t=t + tau
            a= a - 2;
        elseif mu < alpha1+alpha2
            a= a - 1;
            b= b - 1;
        elseif mu < alpha1+alpha2+alpha3
            a = a + 1;
        else
            b = b + 1 ;        
        end
        
        t=t + tau;
        store_a(i,1)=a;
        store_t(i,1)=t;
        store_b(i,1)=b;
    end      
%end

figure();
stairs(store_t(:,1),store_a(:,1))
hold on
stairs(store_t(:,2),store_a(:,2),'r')
hold on
stairs(store_t(:,3),store_a(:,3),'k')
hold on
stairs(store_t(:,4),store_a(:,4),'m')
hold on
stairs(store_t(:,5),store_a(:,5),'g')

figure();
stairs(store_t(:,1),store_b(:,1))
hold on
stairs(store_t(:,2),store_b(:,2),'r')
hold on
stairs(store_t(:,3),store_b(:,3),'k')
hold on
stairs(store_t(:,4),store_b(:,4),'m')
hold on
stairs(store_t(:,5),store_b(:,5),'g')
%mean
[T,Y] = ode23(@ode_2,[0 1000],[0 0]);
hold on
plot(T,Y(:,1),'k*-')
plot(T,Y(:,2),'k*-')

%stationary distribution by long time simulation
z(:,1)=store_a(:,1);
z(:,2)=store_b(:,1);
stat=zeros(40,40);
for i= 1:length(store_b(:,1))
    if (((store_a(i,1)>0)&(store_a(i,1)<40))&((store_b(i,1)>0)&(store_b(i,1)<40)))
       stat(store_a(i,1),store_b(i,1))=stat(store_a(i,1),store_b(i,1))+1; 
    end;
end
stat=stat./177559;
figure()
contourf(stat)
% histogram
%summing over b
hist(store_a(:,1),max(store_a(:,1)))
figure()
bar(hist(store_a(:,1),max(store_a(:,1)))./177559)

hist(store_b(:,1),max(store_b(:,1)))
bar(hist(store_b(:,1),max(store_b(:,1)))./10^8)
 if ((A>0)&(A<101))
       pa(A)=pa(A)+1;
end;
pa=pa./10^6;
bar(pa);

%% section 3.1
%a6-b6

for i = 1: 6
    dt=0.1;
    D=0.0001;
    x=0;
    y=0;
    z=0;
    for n= 1:6000
         r=randn(3,1);
        x = x + (r(1)*sqrt(2*D*dt));
        y = y + (r(2)*sqrt(2*D*dt));
        z = z + (r(3)*sqrt(2*D*dt));
    store_x(n,i)=x;
    store_y(n,i)=y;
    store_z(n,i)=z;
    end
end

figure(4);
plot(store_x(:,1),store_y(:,1))
hold on
plot(store_x(:,2),store_y(:,2),'r')
hold on
plot(store_x(:,3),store_y(:,3),'k')
hold on
plot(store_x(:,4),store_y(:,4),'m')
hold on
plot(store_x(:,5),store_y(:,5),'g')
hold on
plot(store_x(:,6),store_y(:,6),'c')    

hold on

plot(store_x(end,1),store_y(end,1),'ko','MarkerSize',10,'MarkerFaceColor',[0.1,0.1,0.1])
hold on
plot(store_x(end,2),store_y(end,2),'ko','MarkerSize',10,'MarkerFaceColor',[0.1,0.1,0.1])
hold on
plot(store_x(end,3),store_y(end,3),'ko','MarkerSize',10,'MarkerFaceColor',[0.1,0.1,0.1])
hold on
plot(store_x(end,4),store_y(end,4),'ko','MarkerSize',10,'MarkerFaceColor',[0.1,0.1,0.1])
hold on
plot(store_x(end,5),store_y(end,5),'ko','MarkerSize',10,'MarkerFaceColor',[0.1,0.1,0.1])
hold on
plot(store_x(end,6),store_y(end,6),'ko','MarkerSize',10,'MarkerFaceColor',[0.1,0.1,0.1])    
hold off

%prob distribution function in two dimensions
x=[-0.8:0.01:0.8];
y=[-0.8:0.01:0.8];
for i=1:length(x)
    for j=1:length(y)
        prob(i,j)=(1/4*D*6000*pi)*exp(-(x(i)^2+y(j)^2)/4*D*6000);
    end
end
figure(6)
contourf(x,y,prob)
shading flat;

%a7-b7

for i = 1: 1000 % number of molecules
    D=0.0001;
    L=1;
    dt=0.1;
    x=0.4;    
    for n= 1:2400 % time in 
         r=randn(1,1);
        x = x + (r*sqrt(2*D*dt));
        if x < 0
            x = -x - (r*sqrt(2*D*dt));
        elseif x > L
            x= 2*L -x - (r*sqrt(2*D*dt));
        end
        store_x(n,i)=x;
    
    end
end
figure(7);
plot(store_x(:,1))
hold on
plot(store_x(:,2),'r')
plot(store_x(:,3),'k')
plot(store_x(:,4),'m')
plot(store_x(:,5),'g')
plot(store_x(:,6),'c')    
plot(store_x(:,7),'b.')
plot(store_x(:,8),'r.')
plot(store_x(:,9),'m.')
plot(store_x(:,10),'k.')
hold off
Xplot(:,1)=store_x(2400,:);
figure(8); 
h=hist(Xplot(:,1),40);
bar(h)

%% section 3.2
   
    %initialisation
    clear;
    clc;
    t=0;
    D=0.0001;
    h=0.025; %1/number of compartments
    k=D/h^2;
    time= 14*60 ; % corresponds to number of steps taken by each molecules
    a = zeros(40,1);
    a(16,1)=1;
    a(17,1)=0; 
    alpha_f=zeros(40,1);
    alpha_b=zeros(40,1);
     n=1;

while t < time
     
     %propensities in forward direction
                for i=1:39
                    alpha_f(i,n)= a(i,n)*k;
                end
                
                %propensities in backward direction
                for i=2:40
                    alpha_b(i,n)= a(i,n)*k;
                end
                
                %computing alpha summation of propensities
                alpha = 2*k*1-a(1,n)*k-a(40,n)*k;                                              
                
                %generating 2 random numbers
                r=rand(2,1);           
                
                %computing the time of next reaction occurence
                tau=(1/alpha)*reallog(1/r(1));
                
                %determining which forward reaction occurs
                mu=r(2)*alpha ;
                

                    a(:,n+1) = a(:,n);
                    j=0;
                    while j < 39  
                        if sum(alpha_f(1:j,n))<= mu 
                            j = j+1;
                        else
                            break
                        end
                        
                    end
                                       
                     if mu < sum(alpha_f(1:j,n))
                        a(j,n+1)=a(j,n)-1;
                        a(j+1,n+1)=a(j+1,n)+1;    
                        
                     else
                        forw=sum(alpha_f(:,n));
                        z=1;
                        while z<40 
                            if  (forw + sum(alpha_b(1:z,n)))<= mu                                                     
                                
                                z=z+1;
                            else
                                a(z,n+1) = a(z,n)-1;
                                a(z-1,n+1) = a(z-1,n)+1;
                               break
                            end
                           
                        end  
                                                     
                     end                              
                             
        
        t=t + tau;
        store_t(n,1)=t;
        n=n+1;      
end

figure(9);
y1=a(:,n);
x=[1*0.025:1*0.025:40*0.025];
y2=a(:,n).*0.025;
[hAx] =plotyy(x,y1,x,y2,@bar);
xlabel('x [mm]')
ylabel(hAx(1),'number of molecules in compartments') % left y-axis
ylabel(hAx(2),'concentration [molecules/number of compartments]') 

figure(10);
hold on
a(:,n)=[];
for j=1:n-1
    for i=1:40
        if a(i,j)==1
            plot(i*0.025,store_t(j,1)./60,'m<')
            hold on
        end
    end
end















