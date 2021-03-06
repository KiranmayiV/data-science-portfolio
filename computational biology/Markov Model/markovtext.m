alpha={'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','$'};
vowels={'a','e','i','o','u'};
consonants={'b','c','d','f','g','h','j','k','l','m','n','p','q','r','s','t','v','w','x','y','z'};
N=58840;
% M=zeros(28,1);
X=zeros(27,27);
CV=zeros(3,3);
CV_P=zeros(3,3);
CV_score=zeros(3,3);
P=ones(27,27);
score=zeros(27,27);
SP=zeros(27,27);
% Z=11250;
% Prob=zeros(27,27);
length=0;
count=0;
count1=0;
storelengths=zeros(N,2);
freq_letter=zeros(27,1);
score_word=ones(40,1);
score_s=zeros(27,27);
v=0;
c=0;
score_collapse=zeros(3,3);




% average word length P(w)Q1
words=textread('text.txt','%c');
for i=1:N
    for j=1:27
    if words(i,1)==alpha{j} && alpha{j}=='$'
        count=count+1;
        storelengths(i,1)=count;
    elseif words(i,1)==alpha{j}
        length=length+1;
        storelengths(i,2)=length;
    end
    end
end
    av_word_length=sum(storelengths(:,2))/count;    
%frequency of each letter freq(a) Q2
for i=1:N
    for j=1:27
    if words(i,1)==alpha{j}
        freq_letter(j,1)=freq_letter(j,1)+1;
    end 
    end
end
%transitional probabilities Q3
for i=1:N
    for j=1:27
        for k=1:27                  
         if i==N
             break;
         elseif words(i,1)==alpha{j}&& words(i+1,1)==alpha{k}
            X(j,k)=X(j,k)+1; 
         end
        end
    end
end
for j=1:27
    for k=1:27
        P(j,k)=X(j,k)/freq_letter(j,1);
    end
end
%scoring matrix Q4
for j=1:27
    for k=1:27
      score(j,k)=log2(P(j,k)/freq_letter(j)*freq_letter(k));
    end    
end
%scaling scoring Matrix using tanh
for j=1:27
    for k=1:27
        score_s(j,k)=tanh(score(j,k));
    end
end
% %consonants and vowels Q5
for i=1:N
    for j=1:5
        for l=1:5
            if i==N
                break;
            elseif words(i,1)==vowels{j} && words(i+1,1)==vowels{l}  
                CV(2,2)=CV(2,2)+1;
            end
        end
        if i==N
            break;
        elseif words(i,1)==vowels{j}&& words(i+1,1)=='$'
                CV(2,2)=CV(2,2)+1;
        elseif words(i,1)=='$'&& words(i+1,1)==volwels{j}
                CV(3,2)=CV(3,2)+1;
        end        
        for k=1:22
            for m=1:22
                if i==N
                    break;
                elseif words(i,1)==consonants{k}&& words(i+1,1)==consonants{m}
                        CV(1,1)=CV(1,1)+1;
                end
            end
            if i==N
                break;                
            elseif words(i,1)==vowels{j}&& words(i+1,1)==consonants{k}
                    CV(2,1)=CV(2,1)+1;
            elseif words(i,1)==consonants{k}&& words(i+1,1)==vowels{j}
                CV(1,2)=CV(1,2)+1;
            elseif words(i,1)==consonants{k}&& words(i+1,1)=='$'
                CV(1,3)=CV(1,3)+1;            
            elseif words(i,1)=='$'&& words(i+1,1)==consonants{k}
                CV(3,1)=CV(3,1)+1;
            end
        end
    end
            
    if i==N
        break;
    elseif words(i,1)=='$'&& words(i+1,1)=='$'
         CV(3,3)=CV(3,3)+1;
    end  
    
      
end
for j=1:3
    for k=1:3
        CV_P(j,k)=CV(j,k)/sum(CV(j,:));
    end
end
for j=1:3
    for k=1:3
         CV_score(j,k)=log2(CV_P(j,k)/(sum(CV(j,:))*sum(CV(k,:))));
    end
end  
% %making CV_score from scoring matrix by collapsing original scoring matrix
% 
% for j=1:27    
%     if j==(1|5|9|15|21)
%     v=score_s(:,j)+v;
%     elseif j~='$'
%     c=score_s(:,j)+c;    
%     end
% end
% for k=1:27
%     if k==(1|5|9|15|21)
%         v1=score_s(k,:)+v1;
%     elseif k~='$'
%         c1=score_s(k,:)+c1;
%     end
% end
% score_collapse(1,1)=


   
%generating 4 letter words Q6
 
 y=1;

for z=1:40
    r1=random('unif',0,max(P(27,:)));
for i=1:27
    if r1<P(27,i)
        temp(i,1)=P(27,i);         
    end
end
temp(temp(:,1)==0,:)=[];
min_prob(1,1)=min(temp(:,1));

for i=1:27
    if P(27,i)==min_prob(1,1)
     g_word(1,1)=alpha{i};
    end 
    r2=random('unif',0,max(P(i,:)));
     for j=1:27
       if r2<P(i,j)
        temp(j,2)=P(i,j);
       end
     end
    temp(temp(:,2)==0,:)=[];
    min_prob(1,2)=min(temp(:,2));
    
    for j=1:27
        if P(i,j)==min_prob(1,2)
            g_word(1,2)=alpha{j};
        end 
        r3=random('unif',0,max(P(j,:)));
            for k=1:27
                if r3<P(j,k)
                    temp(k,3)=P(j,k);
                end
            end           
      
        temp(temp(:,3)==0,:)=[];
        min_prob(1,3)=min(temp(:,3));
        
        for k=1:27
           if P(j,k)==min_prob(1,3)
                g_word(1,3)=alpha{k};
           end
           r4= random('unif',0,max(P(k,:)));
                for l=1:27
                    if r4<P(k,l)
                        temp(l,4)=P(k,l);
                    end
                end
            
            temp(temp(:,4)==0,:)=[];
            min_prob(1,4)=min(temp(:,4));
            for l=1:27
                if P(k,l)==min_prob(1,4)
                    g_word(1,4)=alpha{l};
                end
            end
        end    
    end                
end
for i=1:4
word_dump(y,i)=g_word(1,i);
end
y=y+1;
end
%scoring the words generated

     for i=1:40
         for j=1:4
             for k=1:27
                 for l=1:27
                    if j==4 && i==40
                        break;
                    elseif j==4
                        i=i+1;
                    elseif word_dump(i,j)==alpha{k} && word_dump(i,j+1)==alpha{l}
                    score_word(i,1)=score_word(i,1).*score_s(k,l);
                    end
                 end
             end
         end
         
     end
     




   
%             
