#After downloading and extracting the zip files...
##1. Merges the training and the test sets to create one data set.

# 1.1 Reading files

# 1.1.1 Reading datasets into the environment
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# 1.1.2 Reading feature vector
features <- read.table("./UCI HAR Dataset/features.txt")

# 1.1.3 Reading activity labels
activityLabels = read.table("./UCI HAR Dataset/activity_labels.txt")

# 1.1.4 Assigning variable names
##six activities - WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING
##subject - who performed the activity. Its range is from 1 to 30.
colnames(x_train) <- features[,2]
colnames(y_train) <- "activityID"
colnames(subject_train) <- "subjectID"

colnames(x_test) <- features[,2]
colnames(y_test) <- "activityID"
colnames(subject_test) <- "subjectID"

colnames(activityLabels) <- c("activityID", "activityType")

#1.1.5 Merging all datasets into one set
all_train_data <- cbind(y_train, subject_train, x_train)
all_test_data <- cbind(y_test, subject_test, x_test)
final_data <- rbind(all_train_data, all_test_data)

##2. Extracts only the measurements on the mean and standard deviation for each measurement. 
##keywords: mean; std

#2.2.1
library(dplyr)
extract_data <- final_data %>% select(activityID, subjectID, grep("\\bmean\\b|\\bstd\\b", colnames(final_data)))

##3.Uses descriptive activity names to name the activities in the data set
##4.Appropriately labels the data set with descriptive variable names. 
##notes: A 561-feature vector with time (t) and frequency (f) domain variables.
colnames(extract_data) <- gsub("^t", "time", colnames(extract_data))
colnames(extract_data) <- gsub("^f", "frequency", colnames(extract_data))

##notes: acc: Accelerometer; gyro: gyroscope; mag: magnitude;  
colnames(extract_data) <- gsub("Acc", "Accelerometer", colnames(extract_data))
colnames(extract_data) <- gsub("Gyro", "Gyroscope", colnames(extract_data))
colnames(extract_data) <- gsub("Mag", "Magnitude", colnames(extract_data))

##5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidy_data <- aggregate(. ~subjectID + activityID, extract_data, mean)

#create the new dataset as a txt file
write.table(tidy_data, file = "tidy_data.txt", row.name=FALSE)
