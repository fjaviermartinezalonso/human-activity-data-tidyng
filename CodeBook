# Code Book

# 1. General information and variable description
The data used for this little project have been downloaded from 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Variables and methods for obtaining this data is self-explained in the following 
files from the authors:
https://github.com/fjaviermartinezalonso/human-activity-data-tidyng/blob/master/data/README.txt
https://github.com/fjaviermartinezalonso/human-activity-data-tidyng/blob/master/data/features_info.txt

# 2. Tidyng process step by step
The main goal is to extract data of specific features from this data set, to process it 
in order to obtain some metrics of interest and finally to tidy the names of the table
so that it is easier to read.

The first step is to read the data set. It is separated into feature data (X) and activity 
labels (y), each of them for training and test sets. After this, all the data is stored in
a tibble object (dplyr library).

In the next step the activity labels, which are initially just numbers, are substituted
by the actual names of the activities. Then names for the features and the activities are
manipulated to become easier to read and understand. 

Next, the data set is filtered to contain only the mean and standard deviation features, which
are the ones of interest for this little project.

Finally, the data about the subjects that obtained the measurements is loaded and used along
the different activities to group the features by subject and activity. Then, an average is
performed for all the mean and standard deviation features, and the resulting data set is stored
in the data folder in csv format.
