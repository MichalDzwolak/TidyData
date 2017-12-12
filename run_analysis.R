library(dplyr)

# download
if(!file.exists("./dane")){dir.create("./dane")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./dane/Dataset.zip")

# Unzip 
unzip(zipfile="./dane/Dataset.zip",exdir="./dane")

# load train tables
train1= read.table("./dane/UCI HAR Dataset/train/X_train.txt")
train2= read.table("./dane/UCI HAR Dataset/train/y_train.txt")
sub_train=read.table("./dane/UCI HAR Dataset/train/subject_train.txt")

# load test tables
test1= read.table("./dane/UCI HAR Dataset/test/X_test.txt")
test2= read.table("./dane/UCI HAR Dataset/test/y_test.txt")
sub_test=read.table("./dane/UCI HAR Dataset/test/subject_test.txt")

# Read act labels
actlab = read.table('./dane/UCI HAR Dataset/activity_labels.txt')

# Read features 
features <- read.table('./dane/UCI HAR Dataset/features.txt')

# Column names
# train set
colnames(train1) <- features[,2]
colnames(train2) <-"actid"
colnames(sub_train) <- "subid"

# test set
colnames(test1) <- features[,2]
colnames(test2) <-"actid"
colnames(sub_test) <- "subid"

# act labels
colnames(actlab) <- c('activityId','activityType')

# merge
train <- cbind(train2, sub_train, train1)
test <- cbind(test2, sub_test, test1)
final = rbind(train,test)

colnam = (grepl("mean..", colnames(final)) | grepl("std..", colnames(final)) | grepl("actid", colnames(final)) | grepl("subid", colnames(final)))

final = final[, colnam==TRUE]

final = final %>% group_by(actid, subid) %>% summarise_all(mean)

write.table(final, file = "tidydata.txt", row.names = FALSE)
