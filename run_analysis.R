setwd("~/R-Home/coursera/datacleaning/UCI HAR Dataset")

## read x column names, clean names
xnames <- read.table(file = "features.txt", header = FALSE, sep = "", col.names = c("id", "feature"))
xnames$feature <- gsub("-|\\(\\)", "", xnames$feature)

## read y activity labels
ynames <- read.table(file = "activity_labels.txt", header = FALSE, sep = "", col.names = c("id", "activity"))

## read in x training set, combine with train subject IDs
xtrain <- read.table(file = ".\\train\\X_train.txt", header = FALSE, sep = "", col.names = xnames$feature)
xsubject <- read.table(file = ".\\train\\subject_train.txt", header = FALSE, sep = "", col.names = "subject")
xtrain <- cbind(xsubject, xtrain)

## read in x test set, combine with test subject IDs
xtest <- read.table(file = ".\\test\\X_test.txt", header = FALSE, sep = "", col.names = xnames$feature)
xsubject <- read.table(file = ".\\test\\subject_test.txt", header = FALSE, sep = "", col.names = "subject")
xtest <- cbind(xsubject, xtest)

## merge x train and test 
xtotal <- rbind(xtrain, xtest)

## read y training and y test activity codes, combine 
ytrain <- read.table(file = ".\\train\\Y_train.txt", header = FALSE, sep = "", col.names = "activity")
ytest <- read.table(file = ".\\test\\Y_test.txt", header = FALSE, sep = "", col.names = "activity")
ytotal <- rbind(ytrain, ytest)

## merge x and y data
xymerge <- cbind(xtotal, ytotal)

## replace activity code with activity name
xymerge$activity <- ynames$activity[xymerge$activity]

## get relevant columns
## Extracts only the measurements on the mean and standard deviation for each measurement.
mstd <- grep("mean|std", names(xymerge))

## subset only wanted columns into final data set
finaldata <- xymerge[,mstd]
finaldata <- cbind("subject" = xymerge$subject,
                   "activity" = xymerge$activity,
                   finaldata)

## creates a second, independent tidy data set with the average of each variable for each activity and each subject.
finalAggregate <- aggregate(finaldata[-c(1,2)], by = list("subject" = finaldata$subject, "activity" = finaldata$activity) , mean)
