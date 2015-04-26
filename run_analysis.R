# Setting workind directory, library load

library(plyr)
setwd("~/Documents/Coursera/Getting&Cleaning data/Project")

# QUESTION 1 
# Read and merge data
#######################################################################################

# reading
x_trn <- read.table("UCI HAR Dataset/train/X_train.txt")
y_trn <- read.table("UCI HAR Dataset/train/y_train.txt")
s_trn <- read.table("UCI HAR Dataset/train/subject_train.txt")

x_tst <- read.table("UCI HAR Dataset/test/X_test.txt")
y_tst <- read.table("UCI HAR Dataset/test/y_test.txt")
s_tst <- read.table("UCI HAR Dataset/test/subject_test.txt")

# merging
data_x <- rbind(x_trn, x_tst)
data_y <- rbind(y_trn, y_tst)
data_s <- rbind(s_trn, s_tst)

# QUESTION 2 
# Extract only the measurements on the mean and standard deviation for each measurement
#######################################################################################

features <- read.table("UCI HAR Dataset/features.txt")

# extract columns with mean/std in their names

mean_std <- grep("-(mean|std)\\(\\)", features[, 2])

# subset the desired columns
data_x <- data_x[, mean_std]

# pass names
names(data_x)<- features[mean_std, 2]


# QUESTION 3
# Use descriptive activity names to name the activities in the data set
#######################################################################################

# getting activity names, updating variable
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
data_y[, 1] <- activity_labels[data_y[, 1], 2]
names(data_y) <- "Activity"


# QUESTION 4
# Appropriately label the data set with descriptive variable names
#######################################################################################

# correct column name
names(data_s) <- "subject"

# merge all data
merged <- cbind(data_x, data_y, data_s)



# QUESTION 5
# Create a second, independent tidy data set with the average of each variable for each 
# activity and each subject
#######################################################################################

final_data <- ddply(merged, .(subject, Activity), function(x) colMeans(x[, 1:66]))

write.table(final_data, "final_data.txt", row.name=FALSE)

