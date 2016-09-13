# This is an R script that runs the analysis of my Final Assignment Project
### I. ##Downloading and unzipping datasets Folder
if(!file.exists("./Mydata")){dir.create("./Mydata")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./Mydata/Dataset.zip")

# Unzip dataSet to /Mydata directory
unzip(zipfile="./Mydata/Dataset.zip",exdir="./Mydata")
 
### II. ## Assignment's requirements

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
## Part1. Merging the training and the test sets to create one data set:
# 1.1 #Reading  raw data files  
# Reading training X data containg the measurements, training Y data (Activity Id), and corresponding subject ID's  
x_train <- read.table("./Mydata/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./Mydata/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./Mydata/UCI HAR Dataset/train/subject_train.txt")
dim(x_train); dim(y_train); dim(subject_train)

# Reading testing X data containg the measurements, testing Y data (Activity Id), and corresponding subject ID's
x_test <- read.table("./Mydata/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./Mydata/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./Mydata/UCI HAR Dataset/test/subject_test.txt")
dim(y_test); dim(y_test); dim(subject_test)

# Reading activity labels:
activity_labels <- read.table('./Mydata/UCI HAR Dataset/activity_labels.txt')

# Reading feature vector:
features <- read.table('./Mydata/UCI HAR Dataset/features.txt')

# 1.2 #To merge the above data sets (x_train & x_test, y_train & y_test, subject_train & subject_test) and then combine colum wise  
X_merged <- rbind(x_train, x_test)
Y_merged <- rbind(y_train, y_test)
subject_merged <- rbind(subject_train, subject_test)
dim(X_merged); dim(Y_merged); dim(subject_merged)

# 1.3 # Defining variable names
colnames(X_merged) <- features[,2] 
colnames(activity_labels) <- c("Activity","Type_of_Activity")

# 1.4 # Merging the training and testing sets in one data set
AllData <- cbind(subject_merged, Y_merged, X_merged )
dim(AllData)

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
## Part2. Extracts only the measurements on the mean and standard deviation for each measurement.

Var_Names <- colnames(X_merged)

mu_sigma  <- (grep("-(mean|std)\\(\\)", Var_Names) ) 
MuSigma_Data  <- X_merged[ , mu_sigma]  # subsetting using the  variable mu_sigma with entries col's of mean & std only
dim(MuSigma_Data)
str(MuSigma_Data)

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
## Part3. Use descriptive activity names to name the activities in the data set. 
Y_merged[, 1] <-  activity_labels[Y_merged[, 1], 2]
names(Y_merged) <- "Activity"
View(Y_merged)   

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
## Part4. Appropriately label the data set with descriptive activity names.
colnames(subject_merged) <- "Subject" 
summary(subject_merged)

names(MuSigma_Data) <- gsub("^f", "frequency", names(MuSigma_Data))
names(MuSigma_Data) <- gsub("^t", "time", names(MuSigma_Data))
names(MuSigma_Data) <- gsub("BodyBody", "Body", names(MuSigma_Data))
names(MuSigma_Data) <- gsub("Acc", "Accelerometer", names(MuSigma_Data))
names(MuSigma_Data) <- gsub("Gyro", "Gyroscope", names(MuSigma_Data))
names(MuSigma_Data) <- gsub("Jerk", "SuddenMovement", names(MuSigma_Data))
names(MuSigma_Data) <- gsub("Mag", "Magnitude", names(MuSigma_Data))


#   combining Musigma_Data with 'subject' and 'activity' variables to obtain one pre-final data set.   

MuSigma_AllData <- cbind(subject_merged, Y_merged, MuSigma_Data)
View(MuSigma_AllData)
str(MuSigma_AllData)

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 
## Part5. From the data set in Part 4, creates a second, independent tidy data set with the average of 
## each variable for each activity and each subject.

library(plyr); # a tool package for splitting, applying, and combining data
MyTidyData<-aggregate(. ~Subject + Activity, MuSigma_AllData, mean)
MyTidyData<-MyTidyData[order(MyTidyData$Subject,MyTidyData$Activity),]
write.table(MyTidyData, file = "MyTidyData.txt",row.name=FALSE)

#@@ SB_2016_09_13 @@
