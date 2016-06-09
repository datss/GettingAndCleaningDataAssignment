
library(reshape2)

# Load activity labels and features
activitylabels <- read.table("activity_labels.txt")
activitylabels[,2] <- as.character(activitylabels[,2])
features <- read.table("features.txt")
features[,2] <- as.character(features[,2])


# Extract only the data on mean and standard deviation
featuresMeanStd<- grep(".*mean.*|.*std.*", features[,2])
featuresMeanStd.names <- features[featuresMeanStd,2]
featuresMeanStd.names = gsub('-mean', 'Mean', featuresMeanStd.names)
featuresMeanStd.names = gsub('-std', 'Std', featuresMeanStd.names)
featuresMeanStd.names <- gsub('[-()]', '', featuresMeanStd.names)

# Load the Training dataset
train <- read.table("train/X_train.txt")[featuresMeanStd]
trainActivities <- read.table("train/y_train.txt")
trainSubjects <- read.table("train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

#Load the Test Dataset
test <- read.table("test/X_test.txt")[featuresMeanStd]
testActivities <- read.table("test/y_test.txt")
testSubjects <- read.table("test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)


# merge train and test datasets and labels
d<- rbind(train, test)
colnames(d) <- c("subject", "activity", featuresMeanStd.names)

# converting activities & subjects into factors
d$activity <- factor(d$activity, levels = activitylabels[,1], labels = activitylabels[,2])
d$subject <- as.factor(d$subject)

d.collapsed <- melt(d, id = c("subject", "activity"))
d.mean <- dcast(d.collapsed, subject + activity ~ variable, mean)

write.table(d.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
