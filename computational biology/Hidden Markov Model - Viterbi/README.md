# Hidden Markov Model - Viterbi Algorithm for DNA sequences

Hidden Markov model along with markov model also have an additional property of having inherent hidden states such that the probability of having a particular state within the hidden state differs. This is best summarised by the image below
![](https://raw.githubusercontent.com/KiranmayiV/data-science-portfolio/master/Hidden%20Markov%20Model%20-%20Viterbi/HMM.png)
The hidden states in the image are H and L such that the probability of obtaining each of the states A/T/G/C in H and L differ. Also the transition probabilities within the hidden states and between the hidden states can also differ. If we consider a DNA sequence such as GGCACTGAA, there are several ways or possible paths (as their is no way of knowing if G belongs to L or H) that can generate the sequence. However the most probable path is computed by the Vertibi algorithm. 
The most probable path is given by -
![](https://raw.githubusercontent.com/KiranmayiV/data-science-portfolio/master/Hidden%20Markov%20Model%20-%20Viterbi/prob_HMM.png)

Write about the code and what it does here.
* Input - seq.txt
* Output - output.pdf

## References
1. [Viterbi Algorithm](https://raw.githubusercontent.com/KiranmayiV/data-science-portfolio/master/Hidden%20Markov%20Model%20-%20Viterbi/viterbi.pdf)
2. http://thegrantlab.org/teaching/material/Barry_Lecture14_HMMs.pdf