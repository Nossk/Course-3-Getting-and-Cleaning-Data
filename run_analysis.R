
#https://gist.github.com/mGalarnyk/4e8a7d6da3a99e1b75aea7c86af2ae09

#Load data

packages <- c("data.table", "reshape2")
sapply(packages, require, character.only = TRUE, quietly = TRUE)
path <- getwd()
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, file.path(path, "dataFiles.zip"))
unzip(zipfile = "dataFiles.zip")

#Loading activity labels and features

#Bring in data

activitylables <- fread(file.path(path, "UCI HAR Dataset/activity_labels.txt"), col.names = c("ClassLabels", "ActivityName"))
features <- fread(file.path(path, "UCI HAR Dataset/features.txt"), col.names = c("ClassLabels", "FeatureNames"))

        ##Extract desired data
#Use grep() as a pattern recognizer to find either the word "mean" or "standard deviation" 

desiredFeatures <- grep("(mean|std)\\(\\)", features[, FeatureNames])

#Then we extract the measurements and use gsub() to perform a replacement on all the matches that were obtained with grep() (clean out the "()")

measurements <- features[desiredFeatures, FeatureNames]
measurements
measurements <- gsub('[()]', '', measurements)

        ##Load the training datasets

#We load in the "x_train", "y_train" and "subject_train" datasets.
#In the "x_train" data set we subset using the "desiredFeatures" data set and pass through the "with = FALSE" argument to maintain the data frame properties
#We then merge the dataesest into one. Order matters

train1 <- fread(file.path(path, "UCI HAR Dataset/train/x_train.txt"))[, desiredFeatures, with = FALSE]
trainActivity <- fread(file.path(path, "UCI HAR Dataset/train/y_train.txt"), col.names = c("Activity"))
trainSubjects <- fread(file.path(path, "UCI HAR Dataset/train/subject_train.txt"), col.names = c("SubjectNumber"))

train <- cbind(trainSubjects, trainActivity, train1)

        ##Load the test datasets

#We conduct the same operation as before but with the test data

test1 <- fread(file.path(path, "UCI HAR Dataset/test/X_test.txt"))[, desiredFeatures, with = FALSE]
testActivity <- fread(file.path(path, "UCI HAR Dataset/test/Y_test.txt"), col.names = c("Activity"))
testSubjects <- fread(file.path(path, "UCI HAR Dataset/test/subject_test.txt"), col.names = c("SubjectNumber"))
test <- cbind(testSubjects, testActivity, test1)
t3 <- cbind(test1, testSubjects, testActivity)

