
library(dplyr)

# First we will load the activity labels (y) and the recordings (X)

ydata <- rbind.data.frame(read.table("./data/train/y_train.txt"), 
                          read.table("./data/test/y_test.txt"))
names(ydata) <- "activity"

xdata <- rbind.data.frame(read.table("./data/train/X_train.txt"), 
                          read.table("./data/test/X_test.txt"))

# Now we merge both data frames

data <- tbl_df(cbind.data.frame(ydata, xdata))
rm(list = c("ydata", "xdata"))  # we do not need them anymore              
                   
# The next step is to make readable the activity names (data's
# first column), as there are only numbers. We can load the activity
# names from "activity_labels.txt", clean them, and finally assign them

label_l <- read.table("./data/activity_labels.txt",
                     col.names = c("index", "activityNames"),
                     colClasses = c("integer", "character"))
label_l <- mutate(label_l, activityNames = tolower(activityNames), 
         activityNames = sub("_", "-", activityNames))

data <- mutate(data, activity = unlist(lapply(activity, 
                                      function(x) {label_l$activityNames[x]})))
rm("label_l")

# Now we select only mean and standard deviation features. Then we improve 
# the readability of their names, which are available in "features.txt"

features <- read.table("./data/features.txt", 
                       col.names = c("index", "names"),
                       colClasses = c("integer", "character"))

features <- features %>%
  filter(grepl("mean|std", names))

# Clear feature names

features$names[grep("^t", features$names)] <- 
  sub("t", "time", features$names[grep("^t", features$names)])
features$names[grep("^f", features$names)] <- 
  sub("f", "freq", features$names[grep("^f", features$names)])
features$names[grep("Acc", features$names)] <- 
  sub("Acc", "Accelerometer", features$names[grep("Acc", features$names)])
features$names[grep("Gyro", features$names)] <- 
  sub("Gyro", "Gyroscope", features$names[grep("Gyro", features$names)])
features$names[grep("\\(\\)", features$names)] <- 
  sub("\\(\\)", "", features$names[grep("\\(\\)", features$names)])
features$names[grep("[X-Z]$", features$names)] <- 
  paste(features$names[grep("[X-Z]$", features$names)], "axis", sep = "")

# Assign again to "data" only the columns of interest, and rename them properly

data <- data[,c(1, features$index +1)]  # +1 because first column is "activity"
names(data) <- c("activity", features$names)
rm("features")  # no longer needed

# Now we will create a second dataframe, "data_tidy", which contains the
# averaged values for each feature, grouped by activity and subject. The first
# step is to load the subject list from "subject_xxx.txt" files

subject_l <- rbind.data.frame(read.table("./data/train/subject_train.txt"), 
                             read.table("./data/test/subject_test.txt")) 
names(subject_l) <- "subjects"

# Add all the information together in a new tibble object "data_subj" and
# compute average of all features for each subject and each activity

data_subj <- tbl_df(cbind.data.frame(subject_l, data))
data_tidy <- data_subj %>% 
  group_by(subjects, activity) %>%
  summarise_all(funs(mean(.)))
rm("subject_l", "data_subj")  # no longer needed

# Write the relevant data sets into .csv files for sharing

write.csv(data_tidy, file = "./data/data_tidy.csv")
