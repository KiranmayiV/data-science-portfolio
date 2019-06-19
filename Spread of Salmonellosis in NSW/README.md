# Studying the Spread of Salmonellosis in NSW
This folder contains the code and analysis of the project carried about in collaboration with Charles Perkins Centre and Centre for Complex Systems at the University of Sydney. 
The project has multiple team members each of whom had uniquely contributed to the project. 

While the project has been published as linked [here](https://www.nature.com/articles/s41598-019-42582-3), this folder only inlcudes the work done by the author and doesn't include the work of other authors of the paper.

### Description of the Dataset

The data was collected by Westmead Hospital, Sydney and represented real patient cases of diagonsed salmonellosis. While the original dataset had several attributes listed for each patient such as data of collection of sample, type of sample, post code of detection etc not all of the listed attributes were studied for this study.

The attributes that were considered to be important to find a spatio-temporal pattern of evolution for the cases of Salmonellosis detected were the post code in which a case in detected/diagnosed and date of collection of the sample. 

Additionally each strain of bacterium isolated from the sample is given a 5 digit idenitifier. The first 4 digits represent number of tandem repeats of DNA at specific location and the last digit represents the length of base pairs at the last specific location. These specific locations are standardised (for each micro-organism the location varies) and used for the purpose of molecular typying (or method of developing a unique identifier for each strain) of micro-organisms. For better understanding of MLVAs please refer the [paper](https://www.nature.com/articles/s41598-019-42582-3).  Example of an MLVA identifier - 3-11-10-8-523. 

In conclusion the dataset essentially has three important attributes - location, date, MLVA identifier. 

### Project Methodology 

1. Visualisation of spatial and temporal patterns (link the ipython file here) - In order understand the underlying patterns of disease case occurence, it was important to 
2. Clustering of Data: 
