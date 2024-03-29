seq=textread('seq.txt','%c');
trans=[0 0.5 0.5; 0.002 0.95 0.048; 0.002 0.048 0.95];
trans=log(trans(:,:));
emit=[0.15 0.85; 0.40 0.60];
emit=log(emit(:,:));
v1=zeros(length(seq),1); %1st hidden state +
v2=zeros(length(seq),1); %2nd hidden state -
% 0 = end and begin state
% 1st hidden state = +
% 2nd hidden state = -
%emitted states = 0 and 1
%v(0)=log(1);
x1=zeros(length(seq),2);
x2=zeros(length(seq),2);
track=zeros(length(seq),3);
v1(1)=emit(1,2)+ trans(1,2);
v2(1)=emit(2,2)+ trans(1,3);

for i=2:length(seq)
    y1=[v1(i-1)+trans(2,2), v2(i-1)+trans(3,2)];
    y2=[v1(i-1)+trans(2,3), v2(i-1)+trans(3,3)];
    x1(i-1,:)=y1;
    x2(i-1,:)=y2;
    if max(y1)== y1(1)
        track(i-1,1)=1;
        
    else 
        track(i-1,1)=2;
        
    end
    if max(y2)== y2(1)
        track(i-1,2)=1;
    else
        track(i-1,2)=2;
    end
%     track(i-1,3)=seq(i-1);
    
    if seq(i)== '1'
       v1(i)=emit(1,2)+max(y1);
       v2(i)=emit(2,2)+ max(y2);
        
    else
        v1(i)=emit(1,1)+ max (y1);
        v2(i)=emit(2,1)+ max(y2);
    end
end
%forward algorithm
seq=textread('seq.txt','%c');
trans=[0 0.5 0.5; 0.002 0.95 0.048; 0.002 0.048 0.95];
emit=[0.15 0.85; 0.40 0.60];
f1=zeros(length(seq),1); %1st hidden state +
f2=zeros(length(seq),1); %2nd hidden state -
f1(1)=emit(1,2).*trans(1,2);
f2(1)=emit(2,2).*trans(1,3);
for i=2:length(seq)
    y1=[f1(1).*trans(2,2), f2(1).*trans(3,2)];
    y2=[f1(1).*trans(2,3), f2(1).*trans(3,3)];
    if seq(i)== '1'
       f1(i)=emit(1,2).*sum(y1);
       f2(i)=emit(2,2).*sum(y2);
        
    else
        f1(i)=emit(1,1).*sum(y1);
        f2(i)=emit(2,1).*sum(y2);
    end   
end
prob_seq=f1(end).*trans(2,1)+f2(end).*trans(3,1);
%backward algorithm
seq=textread('seq.txt','%c');
trans=[0 0.5 0.5; 0.002 0.95 0.048; 0.002 0.048 0.95];
emit=[0.15 0.85; 0.40 0.60];
b1=zeros(length(seq),1); %1st hidden state +
b2=zeros(length(seq),1); %2nd hidden state -
b1(519)= trans(2,1);
b2(519)=trans(3,1);

for i =numel(seq)-1:-1:1
    if seq(i)==1
    x=emit(1,2);
    y=emit(2,2);
    else
    x=emit(1,1);
    y=emit(1,2);
    end
    b1(i)=trans(2,2).*x.*b1(i+1)+trans(2,3).*y.*b2(i+1);
    b2(i)=trans(3,2).*x.*b1(i+1)+trans(3,3).*y.*b2(i+1);
end

%posterior probabilities
P1=zeros(length(seq),1);
P2=zeros(length(seq),1);
for i=1:length(seq)
                    
    P1(i)=(f1(i).*b1(i))./prob_seq;
    P2(i)=(f2(i).*b2(i))./prob_seq;
end

figure(1)
plot(P1(:,1),'*')

figure(2)
plot(P2(:,1))