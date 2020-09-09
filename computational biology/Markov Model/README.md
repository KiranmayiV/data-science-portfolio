# Markov Chain Model
Markov chain is a mathematical system that allows for modelling of sequential events of stochastic processes. A stochastic process that satisfies a Markov property or memoryless state is called a markov chain. A memoryless state is achieved when the proability of the next sequential state occuring depends only on the current state. In other wordsw when the conditional probability distribution of future states of the process depends only on the present state not on the sequence of events that preceded it.

A discrete time markov chain is a sequence of random variables X1, X2, X3 .. with the Markov property given by -

P(X_n+1 = x |X1 = x1, X2 = x2, X3= x3.. ) = P(X_n+1 = x | X_n = x_n) 

A markov chain with memory can also be defined when the present n+1th state depends on past m states.

A zero order markov chain is therefore defined with m=0 ie current state visa doesn't depend on the previous state at all. Therefore the transitional or conditional probability between states is the same as probability distribution of individual states.
ie. P(X_n+1 = x | X_n = x_n)  = P(X_n+1 = x)

Similarly first order markov chain is given by m = 1
ie P(X_n+1 = x | X_n = x_n) 

And Second order markov chain is given by present state depending on the conditional probabilities of previous two states.
P(X_n+1 = x | X_n=x_n, X_n-1 = x_n-1)

This folder contains [matlab code](https://raw.githubusercontent.com/KiranmayiV/data-science-portfolio/master/Markov%20Model/statistics_1.m) for calculating Zero, First and Second order Markov model. 
* Input file = statistics_markov.txt 
* Output file = output.txt

Additionally [matlab file](https://raw.githubusercontent.com/KiranmayiV/data-science-portfolio/master/Markov%20Model/markovtext.m) computes several statistics for [text file](https://raw.githubusercontent.com/KiranmayiV/data-science-portfolio/master/Markov%20Model/text2.txt) Below are the statistics listed - 

* Average word length in the input text file
* Frequency of each letter
* First order transitional probabibilites ie. building a 27 X 27 probability matrix computing P(X_n+1 = x | X_n = x_n) 
* Computing scoring matrix  ie
* Transtition probabilities and scoring matrix for consonants and vowels
* Generating 4 letter words using the calculated transition probabilities
* Scoring the 4 letter words generated.

## References
1. https://en.wikipedia.org/wiki/Markov_chain
2. https://www2.cs.duke.edu/courses/spring09/cps111/notes/markovChains.pdf
