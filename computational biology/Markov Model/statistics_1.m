%%Computing zero, first and second order Markov approximation

words=textread('statistics_markov.txt','%c');
alpha={'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','$'};
N=length(words);
freq_letter=zeros(27,1);
X=zeros(27,27);
Y=zeros(27,27,27);
alp=char(alpha(1,:));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%zero order markov approximation
for i=1:length(words)
    for j=1:27
       if words(i,1)==alpha{j}
            freq_letter(j,1)=freq_letter(j,1)+1;
       end 
    end
end
    %prob(j|D)=prob(j|theta)prob(theta|D)dtheta
for j=1:27
    prob(j,1)=(freq_letter(j,1)+1)./(27+sum(freq_letter,1));
end

zero_order=cumsum(prob,1);
p=1;
q=1;
r=rand(1000,1);
%store=zeros(1000,1);
for k=1:numel(r)
    for l=1:length(zero_order)
        if r(k) >= zero_order(l)&& r(k) <= zero_order(l+1)
            gen_word(p,q)=alp(l+1);
            q=q+1;
        end
    end
end            
fid = fopen('zero', 'w');
        for d=1:length(gen_word(1,:))
        fprintf(fid, '%c', gen_word(1,d));
        end
        fclose(fid);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%first order markov approximation
clear
clc
for i=1:N-1
    for j=1:27
        for k=1:27                  
         if words(i,1)==alp(j)&& words(i+1,1)==alp(k)
            X(j,k)=X(j,k)+1; %freq as well
         end
        end
    end
end
for j=1:27
        for k=1:27 
            prob_1(j,k)= (X(j,k)+1)./(27+sum(X(j,:)));
        end
end
        % generating text
p=2;
q=1;
rand_alpha = prob_1(randi(numel(prob_1(:,1))));
close=cumsum(prob_1,2);
%for first two letters
for i=1:length(prob_1(:,1))
     if rand_alpha==prob_1(i,1)
            r=rand(1,1);
            gen_word(p,q)=alp(i);
            q=q+1;
            break
     end
end
for j=1:26
         if r >= close(i,j) && r <= close(i,j+1)
             gen_word(p,q)=alp(j+1);
             q=q+1;
         end         
end
for m=1:1000
    for k=1: 27
        if gen_word(p,q-1)==alp(k)
            r=rand(1,1);
            break
        end
    end
    for j=1:26
        if r >= close(k,j) && r <= close(k,j+1)
            gen_word(p,q)=alp(j+1);
            q=q+1;
        end
    end
end
        % to write generated words into a file
        fid = fopen('first', 'w');
        for d=1:length(gen_word(2,:))
        fprintf(fid, '%c', gen_word(2,d));
        end
        fclose(fid);
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%second order markov approximation

alp_string=char(27,2);
x=1;
Y=zeros(729,27);
for i=1:27
    for j=1:27
        alp_string(x,1)=alp(i);
        alp_string(x,2)=alp(j);
        x=x+1;
    end
end
alp_string=char(alp_string(:,:));
for i=1:N-2
    for j=1:729    
           if words(i,1)==alp_string(j,1)
                for k=1:729
                    if words(i+1,1)==alp_string(k,2)&& j==k
                        for l= 1:27
                            if words(i+2)==alp(l);
                                 Y(k,l)=Y(k,l)+1;
                            end
                        end
                    end
                end            
            end
    end
end
for j=1:729
        for k=1:27             
                prob_2(j,k)= (Y(j,k)+1)./(27+sum(Y(j,:)));
            
        end
end
    % generating text
p=3;
q=1;
rand_alpha = prob_2(randi(numel(prob_2(:,1))));
%for first three letter
for i=1:length(prob_2(:,1))
     if rand_alpha==prob_2(i,1)
            r=rand(1,1);
            gen_word(p,q)=alp_string(i);
            gen_word(p,q+1)=alp_string(i+1);
            q=q+2;
            break
     end
end
for j=1:26
         if r >= open(i,j) && r <= open(i,j+1)
             gen_word(p,q)=alp(j+1);
             q=q+1;
         end         
end
%after first three letters
for m=1:1000
    for k=1: 729
        if gen_word(p,q-2)==alp_string(k,1)&& gen_word(p,q-1)==alp_string(k,2)
            r=rand(1,1);
            break
        end
    end
    for j=1:26
        if r >= open(k,j) && r <= open(k,j+1)
            gen_word(p,q)=alp(j+1);
            q=q+1;
        end
    end
end

     % to write generated words into a file
        fid = fopen('second', 'w');
        for d=1:length(gen_word(3,:))
        fprintf(fid, '%c', gen_word(3,d));
        end
        fclose(fid);


