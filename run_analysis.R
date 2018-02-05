library(dplyr)
# Verify the working directory to read the data from files if not use setwd()to change it to the right location
getwd()
Xtrain <- read.table("UCI HAR Dataset/train/X_train.txt")
Ytrain <- read.table("UCI HAR Dataset/train/Y_train.txt")
Subtrain <- read.table("UCI HAR Dataset/train/subject_train.txt")

Xtest <- read.table("UCI HAR Dataset/test/X_test.txt")
Ytest <- read.table("UCI HAR Dataset/test/Y_test.txt")
Subtest <- read.table("UCI HAR Dataset/test/subject_test.txt")

features<- read.table("UCI HAR Dataset/features.txt")	

activitylabels <- read.table("UCI HAR Dataset/activity_labels.txt")

# 1. Merges the training and the test sets to create one data set.
Xdata<- rbind(Xtrain, Xtest)
Ydata<- rbind(Y_train, Ytest)
Subtotaldata <- rbind(Subtrain, Subtest)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
selectedvar <- features[grep("mean\\(\\)|std\\(\\)",features[,2]),]
Xdata <- Xdata[,selectedvar[,1]]

# 3. Uses descriptive activity names to name the activities in the data set
colnames(Ydata) <- "activity" 
Ydata$activitylabel <- factor(Ydata$activity, labels = as.character(activitylabels[,2]))
activitylabel <- Ydata[,-1]
	
# 4. Appropriately labels the data set with descriptive variable names.
colnames(Xdata) <- features[selectedvar[,1],2]
	
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
colnames(Subtotaldata) <- "subject"
Finaldata<- cbind(Xdata, activitylabel, Subtotaldata)
Finalmean <- Finaldata %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
write.table(Finalmean, file = "./UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)








