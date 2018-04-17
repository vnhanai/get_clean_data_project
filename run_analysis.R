dir.create("smartphone")
file <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(file, destfile = "smartphone.zip")
unzip(zipfile = "smartphone.zip", exdir = "smartphone")

Xtest <- read.table("smartphone/UCI HAR Dataset/test/X_test.txt")
Ytest <- read.table("smartphone/UCI HAR Dataset/test/y_test.txt")
subjecttest <- read.table("smartphone/UCI HAR Dataset/test/subject_test.txt")

Xtrain <- read.table("smartphone/UCI HAR Dataset/train/X_train.txt")
Ytrain <- read.table("smartphone/UCI HAR Dataset/train/y_train.txt")
subjecttrain <- read.table("smartphone/UCI HAR Dataset/train/subject_train.txt")

features <- read.table("smartphone/UCI HAR Dataset/features.txt")
activitylabels <- read.table("smartphone/UCI HAR Dataset/activity_labels.txt")

colnames(Xtrain) <- features[,2]
colnames(Ytrain) <- "ActivityID"
colnames(subjecttrain) <- "SubjectID"

colnames(Xtest) <- features [,2]
colnames(Ytest) <- "ActivityID"
colnames(subjecttest) <- "SubjectID"

colnames(activitylabels) <- c('ActivityID', 'ActivityTypes')

TestMerge <- cbind(Ytest, subjecttest, Xtest)
TrainMerge <- cbind(Ytrain, subjecttrain, Xtrain)
Alldata <- rbind(TrainMerge, TestMerge)

ColNames <- colnames(Alldata)


mean_and_std <- (grepl("ActivityID" , ColNames) | 
                   grepl("SubjectID" , ColNames) | 
                   grepl("mean.." , ColNames) | 
                   grepl("std.." , ColNames) 
)
Mean_SDsubset <- Alldata[, mean_and_std == TRUE]

NameActivity <- merge(Mean_SDsubset, activitylabels, by = 'ActivityID', all.x = TRUE)


TidyData <- aggregate(. ~SubjectID + ActivityID, NameActivity, mean)
TidyData <- TidyData[order(TidyData$SubjectID, TidyData$ActivityID), ]
                              
write.table(TidyData, "TidyData.txt", row.names = FALSE)


                  