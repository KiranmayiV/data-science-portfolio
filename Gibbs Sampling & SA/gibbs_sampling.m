
seq=textread('seqlist.txt','%c');
sequence=char(200,10);
%total 10 sequences
%each sequence has 200 nt's
y=[1:200:2000];%starting position of each sequence
%putting 10 sequences into a 200* 10 character matrix
j=2;
r1=2;
r2=1;
r3=1;
for i =1:length(seq) % i gives position in seq
    if j==11 %end of y vector
        sequence(r1,j-1)=char(seq(i)); %fill the last sequence starting from r1 = 2
        r1=r1+1;
    elseif y(j)~= i %if not the beginning of new sequence
        
        sequence(r3,j-1)=char(seq(i)); %continue filling rest of sequence from r3 = 2
        r3=r3+1;       %increment r3 value         
    else %if beginning of a new sequence
        sequence(r2,j)=char(seq(i)); %fill in the first character
        r3=2; %set r3 = 2       
        j=j+1; % j counts the number of sequences, as each new sequence begins increment j
        
    end
end
y= [y 2001]; %appending 2001 so that length of seq from 1801 to 2001 is accounted for
%to count and build pwm if first line chosen 
%remaining sequences 
nt=['A','T','G','C'];
rand_seq_prev_chosen =0;
position_seq = 0;
%mega-loop
for x=1:10000 % 10 sequences X 10 times per seq X 100 sliding windows for seq of length 200; so for each sliding window looping over 100 times
    % to select a sequence to be eliminated
    rand_seq = randi(10,1,1);  %generate a random integer sequence number between 1-10    

    %choosing randomly start positions of motif's in the unchosen sequences
    clear r
    clear rand
    %r=zeros(11,1);
    for i=1:length(y)-1 
        r(i)=randi([y(i) y(i+1)-10],1,1);
    end
    for i=1:10
        rand(i+1)=r(1,i);
    end
    
    %eliminating starting position of chosen sequence
    rand(rand_seq+1)=[];    
    rand(1)=1;
    rand(11)=2001;
    
        if rand_seq < rand_seq_prev_chosen && rand_seq_prev_chosen ~= 0
            rand(rand_seq_prev_chosen)= y(rand_seq_prev_chosen)+ position_seq;
        elseif  rand_seq > rand_seq_prev_chosen && rand_seq_prev_chosen ~= 0
            rand(rand_seq_prev_chosen+1)= y(rand_seq_prev_chosen) + position_seq;
        end    
    %postions
    clear pwm
    pwm=zeros(4,11);
    for i=2:length(rand)-1                  
        for j=1:10       % random numbers correspond to each sequence
            if seq(rand(i)+j-1)==nt(1)
                pwm(1,j)= pwm(1,j) +1;
            elseif seq(rand(i)+j-1)==nt(2)
                pwm(2,j)=pwm(2,j)+1;
            elseif seq(rand(i)+j-1)==nt(3)
                pwm(3,j)=pwm(3,j)+1;
            else
                pwm(4,j)=pwm(4,j)+1;
            end
        end
    end
    %to calculate background
    for i=1:length(seq)
             if i>=rand(1) && i <rand(2) 
                    if seq(i)==nt(1)
                        pwm(1,11)=pwm(1,11)+1;
                    elseif seq(i)==nt(2)
                        pwm(2,11)=pwm(2,11)+1;
                    elseif seq(i)==nt(3)
                        pwm(3,11)=pwm(3,11)+1;
                    else
                        pwm(4,11)=pwm(4,11)+1;
                    end
             elseif i>= rand(10)+10 && i <= rand(11)
                    if seq(i)==nt(1)
                         pwm(1,11)=pwm(1,11)+1;
                    elseif seq(i)==nt(2)
                        pwm(2,11)=pwm(2,11)+1;
                    elseif seq(i)==nt(3)
                        pwm(3,11)=pwm(3,11)+1;
                    else
                        pwm(4,11)=pwm(4,11)+1;
                    end
             end
             for k=2:9
                 if i >=(rand(k)+10) && i < rand(k+1)
                        if seq(i)==nt(1)
                            pwm(1,11)=pwm(1,11)+1;
                        elseif seq(i)==nt(2)
                            pwm(2,11)=pwm(2,11)+1;
                        elseif seq(i)==nt(3)
                            pwm(3,11)=pwm(3,11)+1;
                        else
                            pwm(4,11)=pwm(4,11)+1;
                        end
                 end
            end
    end
    %normalizing pwm

    for i=1:4
        for j=1:10
            pwm(i,j)=(pwm(i,j)+1)./(4-1+4); % applying pseudocount=0.5
        end
        pwm(i,11)=(pwm(i,11)+1)./(sum(pwm(:,11))+4);
    end

    %making a window over the chosen sequence and calculating weight for each possible motif position over the chosen sequence 

    from=[y(rand_seq):1:y(rand_seq)+190];
    to=[y(rand_seq)+9:1:y(rand_seq)+199];
    p_window=zeros(191,1);

    for i=1:numel(from)
        pos=0;
        p=1;
        p_bckgrnd=1;
        for k=from(i):to(i)%k corresponds to position in the scanned sequence
            t=p;
            s=p_bckgrnd;
            pos=pos+1;
            if sequence(k)==nt(1)
                p=pwm(1,pos);
                p_bckgrnd=pwm(1,11);
            elseif sequence(k)==nt(2)
                p=pwm(2,pos);
                p_bckgrnd=pwm(1,11);
            elseif sequence(k)==nt(3)
                p=pwm(3,pos);
                p_bckgrnd=pwm(1,11);
            else
                p=pwm(4,pos);
                p_bckgrnd=pwm(1,11);
            end
            p=t*p;
            p_bckgrnd=s*p_bckgrnd;
             % no of windows for 200 length chosen sequence is 100
        end
        p_window(i)= p./p_bckgrnd;
    end
        %trial Simulated Annealing
        for beta=1:3
        p_window=p_window.*p_window;
        end
    
        %normalizing windows - you are sampling from probabilities P^beta (normalised) instead of P
        p_win =p_window(:,1)./sum(p_window(:,1));
        %randomly choosing a window
        %the row gives the starting position of motif sequence
        prob_wind = p_win(randi(numel(p_win(:,1))));

        %k holds position of windown in chosen sequence
        for k=1:length(p_win)
            if p_win(k)==prob_wind
                rand_seq_prev_chosen = rand_seq;%sequence number
                position_seq = k; %position in chosen sequence              
                
            end
        end
        
end

%to recruit sequences from rand intital positions
motif=zeros(10,10);
e=1;
%while e<= 10
    for m=1:numel(seq)
        for n = 2:length(rand)-1
            if  m==rand(n)
                motif(1,e)=seq(m);
                motif(2,e)=seq(m+1);
                motif(3,e)=seq(m+2);
                motif(4,e)=seq(m+3);
                motif(5,e)=seq(m+4);
                motif(6,e)=seq(m+5);
                motif(7,e)=seq(m+6);
                motif(8,e)=seq(m+7);
                motif(9,e)=seq(m+8);
                motif(10,e)=seq(m+9);
                motif(11,e)=rand(n);
                e=e+1;
            end
        end
    end
    
