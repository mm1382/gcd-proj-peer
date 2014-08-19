---
title: "Readme.md"
author: "mark menditto"
date: "August 18, 2014"
output: html_document
---

### Introduction

This repository is for the  Peer Assessments / Getting and Cleaning Data Course Project

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. 
The goal is to prepare tidy data that can be used for later analysis.

### Here are the data for the project: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

### Purpose of the script: run_analysis.R

There is one R script called `run_analysis.R` that does the following. 

* Merges the training and the test sets to create one data set.

* Extracts only the measurements on the mean and standard deviation for each measurement. 

* Uses descriptive activity names to name the activities in the data set

* Appropriately labels the data set with descriptive variable names. 

* Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

### Preparing to run the script

1. Download the `run_analysis.R` program to your home directory (e.g., /users/myname/R/)

2. Download the data from: 
    https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

3. Extract (unzip) the data to a data subdirectory (e.g., "UCI HAR Dataset" or "data")

4. Open RStudio and SetWorkingDirectory to that path, e.g., /users/myname/R/UCI HAR Dataset)

    `setwd("~/R")`

5. Run `source('~/R/run_analysis.R', echo=TRUE)` to run the entire script. 

    Or to run `run_analysis.R` one line at a time (MacOS: Command+Enter), 
    
6. Note that `run_analysis.R` takes a few seconds to read large files like ./test/x_test.txt when it gets to the line: 
    `x_test  <- read.table( './test/x_test.txt', header=FALSE )`

### Output files

`run_analysis.R` creates a tidy data file:

<!-- -->
        
    # Create a second, independent tidy data set with the average of each variable, activity and subject
    run_analysis.R:write.table( tidy_data, "tidy_data.txt", row.name=FALSE )
    



end