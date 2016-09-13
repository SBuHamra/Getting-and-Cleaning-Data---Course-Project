# Getting-and-Cleaning-Data---Course-Project
This repository includes  the R code and documentation files for the Getting and Cleaning Data Coursera course. The R script, run_analysis.R, performs the  tasks required as part of completing the project to produce a tidy data text data that meets the principles . These tasks are summarized as follows.
•	Download , unzip and read raw dataset  
•	Loads both the training and test datasets, keeping only those columns which reflect a mean or standard deviation
•	Loads the activity and subject data for each dataset, and merges those columns with the dataset
•	Merges the two datasets
•	Creates a tidy dataset that consists of the average (mean) value of each variable for each subject and activity pair.

The documentation file codebook.Rmd has the specific description of the tidy data file contents. The final output is called MyTidyData.txt, and uploaded in the course project's form. The data can be read into R using the default command   read.table(header=TRUE).

