# mm1382

# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities, descriptive variable names. 
# Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

setwd("~/git/GcD/GcD-proj/UCI HAR Dataset")

# activity_labels.txt: Links the class labels with their activity name
activities <- read.table( './activity_labels.txt', header=FALSE, sep = " ", col.names = c("id", "activity") );
activities$activity <- tolower(activities$activity)   # lowercase
activities$activity <- gsub( "_", "", activities$activity )  # remove underscores
activities$activity <- factor(activities$activity)  # preserve factor class

# features.txt: List of all features
features <- read.table( './features.txt', header=FALSE, sep = " ", col.names = c("id", "featuretype") );
filteredidx <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])  #  row indexes of features that say: std() or mean()

# Use descriptive activity names to name the activities in the data set
features$featuretype <- tolower( features$featuretype )
features$featuretype <- gsub( "\\(|\\)", "", features$featuretype ) # remove parens
features$featuretype <- factor( features$featuretype ) # preserve factors

# Each row identifies the subject who performed the activity (1-30) for each window sample. 
subject_train <- read.table( './train/subject_train.txt', header=FALSE, col.names = "subject" );
subject_test  <- read.table( './test/subject_test.txt',   header=FALSE, col.names = "subject" );
all_subjects <- rbind( subject_train, subject_test ) # Join test and train subjects
  
# Read and filter x_test and x_train for only those featuretype at filteridx
x_train <- read.table( './train/x_train.txt', header=FALSE );   # Training set
colnames(x_train) <- features$featuretype   # assign column names from features
x_train <- x_train[ ,filteredidx ]   # filter

x_test  <- read.table( './test/x_test.txt',   header=FALSE );   # Test set
colnames(x_test) <- features$featuretype    # assign column names from features
x_test <- x_test[ ,filteredidx ]     # filter
all_x <- rbind( x_train, x_test )    # Join test and train data frames

y_train <- read.table( './train/y_train.txt', header=FALSE, col.names = "id" );    # Training labels
y_test  <- read.table( './test/y_test.txt',   header=FALSE, col.names = "id" );    # Test labels
all_y <- rbind( y_train, y_test )  # Join test and train activities

# Transform Y dataframe of ids into descriptive activity
# Cant use merge() because rows are by default lexicographically sorted on the common columns
all_y$activity <- activities[ all_y$id, 2 ]
all_y$id <- NULL  # drop id column since descriptive activity column is appended

merged_tidy <- cbind( all_subjects, all_y, all_x  )
write.table(merged_tidy, "merged_tidy.txt")

# Cleanup
rm( subject_test, subject_train, x_test, x_train, y_test, y_train ) 

# Create a second, independent tidy data set with the average of each variable, activity and subject
library(reshape2)
melted_data <- melt( merged_tidy, id=c("subject","activity") )
tidy_mean = dcast( melted_data, subject + activity ~ variable, fun.aggregate=mean )
write.table( tidy_mean, "tidy_mean.txt", row.name=FALSE )
