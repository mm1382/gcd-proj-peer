---
title: "CodeBook"
author: "mark menditto"
date: "August 18, 2014"
output:
  html_document: default
---

### Study Design

Here are the data for the project: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

and process the files with R script run_analysis.R which does the following: 

* Merges the training and the test sets to create one data set.
* Extracts only the measurements on the mean and standard deviation for each measurement. 
* Uses descriptive activity names to name the activities, descriptive variable names. 
* Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

### Input/Output files and transformations

From UCI HAR Dataset/README.txt:

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. 
Each person performed six activities \(WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)\ ... 
The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The input files are as follows: 

activity_labels.txt: Links the (6) class labels with their activity name. 
`run_analysis` reads this and transforms the file into a data frame as follows:

* converts these activities to lowercase, removes underscores and preserves factors

features.txt: List of all (561) features
`run_analysis` reads this and transforms the file into a `features` data frame as follows:

* filters out all activities besides those that end in -mean() and -std() into a `filteredidx` index variable
* Filtering reduces the 561 features to 66. 
* converts them to lowercase, and removes parens () to create a descriptive label
* Factors are preserved.

/train/subject_train.txt' and subject_test.txt are joined
`run_analysis` reads these and transforms the files into two data frames as follows, then consolidates them.

* Each row identifies the SUBJECT who performed the activity (1-30) for each window sample. 
* Reads and filters x_test and x_train for only those featuretype at `filteridx`
* assign column names from `features`
* x_test and x_train are joined

train/y_train.txt and y_test.txt activity IDs are joined. 

* Activity IDs are transformed to the descriptive names

* The subjects, X (activity data), Y (activity IDs transformed to names) are joined using `cbind()` 
  into a wide data frame: `merged_tidy` 

`run_analysis` then creates a second, independent tidy data set: tidy_mean.txt: 

* with the average of each variable, 
* activity and subject, using `melt()` and `dcast()`


### Input/output file, data frame dimensions, before and after transformation

`activities`: 6 obs. of 2 variables: id (int) and activity (Factor w/ 6 levels)

`all_subjects`: 10299 obs. of 1 variables: subjects (int)

`x_train`: 7352 obs. of 561 unfiltered variables, 66 filtered features (num)

`x_test`: 2947 of 561 unfiltered variables, 66 filtered features (num)

`y_train`: 7352 obs. of 1 variables: id (int)

`y_test`: 2947 obs. of 1 variables: id (int)

`all_x` (merged train & test): 10299 obs. of 66 filtered features (num)

`all_y` (merged train & test): 10299 obs. of 1 variables: activity (Factor w/ 6 levels)

`features`: 561 obs. of 2 variables: id (int), featuretype (Factor w/ 477 levels)

temporary variables: 
  `subject_test, subject_train, x_test, x_train, y_test, y_train`

#### Output data.frames and file:

`merged_tidy`: 10299 obs. of 68 variables: subject (int), activity (Factor w/ 6 levels), filtered features (num)
is the wide style of tidy data, then reformed into a narrow tidy data set using `melt()` and `dcast()`

`melted_data` (intermediate data.frame: 679734 obs. of 4 variables: 
  subject (int), activity (Factor w/ 6 levels), various (Factor w/ 66 levels)

<!-- -->

    # Create a second, independent tidy data set with the average of each variable, activity and subject
    library(reshape2)
    melted_data <- melt( merged_tidy, id=c("subject","activity") )
    tidy_data = dcast( melted_data, subject + activity ~ variable, fun.aggregate=mean )
    write.table( tidy_data, "tidy_data.txt", row.name=FALSE )

`tidy_data`: 180 obs. of 68 variables: subject (int), activity (Factor w/ 6 levels), filtered features (num)

`tidy_data` is written out as a file: `tidy_data.txt`


END