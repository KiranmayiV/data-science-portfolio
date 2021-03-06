# Gibbs Sampling for Motif Pattern Finding
This folder contains [matlab code](/gibbs_sampling.m) for implementing Gibbs Sampling coupled with Simulated Annealing. A problem statement for the algorithm is given [here](/project_gibbs.pdf). This code is part of an assingment towards a course in Biological Sequence Analysis. The output of the program is given in motif_3.mat displayed in [output file](/output.txt).


## Markov Chain Mote Carlo
"The aims of MCMC methods are to solve this problem: to generate samples from a given probability distribution P(x), which is hard to sample directly. It's always assumed that P(x) is evaluated. They involve a Markov process in which a sequence of states is generated, each sample having a probability distribution that depends on the previous value. Given enough time, the Markov chain will converge to a "stationary distribution," where samples are unbiased samples from P(x), effectively independent from the starting state. Although successive samples remain dependent on previous ones, independence is not needed for many purpposes, e.g. calculating the expectation of some random variable. In real applications there is seldom any useful analytical theory for predicting the time required to reach stationarity ("burnin"), nor for determining the sample size needed to adequately represent the target distribution ("mixing"), but the method nevertheless is of great practical importance." ([Ref](https://courses.cs.washington.edu/courses/cse527/03au/notes14.html))

## Gibbs sampling Problem for DNA sequences
Gibbs sampling in a subset of Markov Chain Monte Carlo methods which aims at finding underlying complex distrbutions by sampling. The current problems aims to find binding sites on a DNA sequence for transcription regulators. These bindings sites are sepcific sequences of DNA called motifs. Below is an image of binding sites highlighted in blue. ![](https://raw.githubusercontent.com/KiranmayiV/data-science-portfolio/master/Gibbs%20Sampling%20%26%20SA/motif_img.png) In order to find the positions of these motifs of say length `l` among `s` sequences of DNA, we try to find the most mutually similar substring of length `l` in all `s` sequences. 

## Gibbs Algorithm Explained
Assumptions
* Input is a set of DNA sequences `s1`, . . . , `sm`.
* Each sequence contains a copy or instance of the motif.
* The motif has a fixed length `l`.

Given that the probability distribution giving rise to motif sequence (highlighted in blue) is different from the background DNA sequence (in black) we also know there two different models at work here - 

* The `background model B` is given by a vector that specifices a probability for each of the four states (A/T/G/C)
* The motif is generated by a position weight matrix. The position weight matrix defines the `motif model M` probability for each position i = 1, 2, 3.. a probability `M(i, c)` for each of the four states for a word of length `l`. 

Given we know both `M` and `B`,  we can score any motif(`w`) sequence of length `l`. This score is calculated by the log odds ratio given by 
![](https://raw.githubusercontent.com/KiranmayiV/data-science-portfolio/master/Gibbs%20Sampling%20%26%20SA/score_2.png) ![](https://raw.githubusercontent.com/KiranmayiV/data-science-portfolio/master/Gibbs%20Sampling%20%26%20SA/score_1.png).

If R(w) > 0, it is more likely that the word w was generated by the motif model. If R(w) < 0, then it is more likely that w was generated by the random model. If both M and B are given, then we can make a maximum likelihood prediction of the locations of the motif in sequence of the input sequences. In each sequence `si`, choose a location `ai` such that the word `w` starting at `ai` maximizes R(w). Vice versa, if we are given the locations `a1`, . . . , `am` of the instances of the motif in `s1`, . . . , `sm`, then we can setup M and B for all states and positions `i`. The problem occurs since in motif-finding we know neither and therefore want to infer both.

## Psuedocode 
Brief: Construct `M'` and `B'` from `ai’s` from `m − 1` sequences and then use `M'` and `B'`
to determine a value for `ai` for remaining sequence `si`. Repeat.

Input: Sequences `s1`, . . . , `sm`

Output: Motif `M`, background `B`, locations `a1`, . . . , `am`

Init.: Choose `a1`, . . . , `am` either randomly.

*repeat*

    for h = 1, . . . , m 

    Compute M' and B'

    from a1, . . . , ah−1, ah+1, . . . , am (i.e., from data with h-th sequence and motif removed)
    
    Using M' and B', compute a new location ah in sh (∗)
    
    Compute M and B from a1, . . . , am (i.e., from data with new choice of h-th motif location inserted)

    Compute score L(a1, . . . , am) until score L(a1, . . . , am) has converged (where L is maximum likelihood prediction of the locations of the motif in sequence of the input sequences)
    
*Return M, B and a1, . . . , am*

## Simulated Annealing
While simulated annealing is a optimization algorithm that allows finding of global optimum it can be used for sampling as well. When simulated annealing is applied to gibbs sampling, you end up sampling from P^T distribution instead of P distribution wherein T is temperature sometimes also gibe by beta in the tradition SA algorithm.

## References
Markov Chain Monte Carlo
1. https://jeremykun.com/2015/04/06/markov-chain-monte-carlo-without-all-the-bullshit/
2. http://www.cs.cornell.edu/selman/cs475/lectures/intro-mcmc-lukas.pdf

Gibbs Sampling

3. [Sequence Analysis, WS’14/15, D. Huson & R. Neher (this part by D. Huson) February 5, 2015](https://ab.inf.uni-tuebingen.de/teaching/ws14/seqan/11-MotifFinding.pdf)
4. https://www.cs.cmu.edu/~ckingsf/bioinfo-lectures/gibbs.pdf

Simulated Annealing

5. https://ocw.mit.edu/courses/mathematics/18-417-introduction-to-computational-molecular-biology-fall-2004/lecture-notes/lecture_19.pdf

