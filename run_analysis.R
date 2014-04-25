#Loading the required Package
library(plyr)
library(reshape2)

#Importing Global Data
activity_labels = read.table("UCI HAR Dataset/activity_labels.txt",col.names = c("Activity_Code","Activity_Name"))
features = read.table("UCI HAR Dataset/features.txt", col.names = c("Feauter_Column", "Feature_Name"))

# Importing Test Set Data
## Imporing subject and activity data
subject_test = read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "Subject_Number")
y_test = read.table("UCI HAR Dataset/test/y_test.txt",col.names = "Activity_Code")

## Measurement data set is imported with column names as features itself
x_test = read.table("UCI HAR Dataset/test/x_test.txt",col.names = features[,2])

## Joining Activity Code to Activity Name
y_test_name = join(y_test,activity_labels, by = "Activity_Code")

## Combining all in a single dataset with Activity Code, Activity Desc, Subject and all other measurement
x_test_act_sub = cbind(y_test_name,subject_test,x_test)


# Importing Training Set Data
## Imporing subject and activity data
subject_train = read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "Subject_Number")
y_train = read.table("UCI HAR Dataset/train/y_train.txt",col.names = "Activity_Code")

## Measurement data set is imported with column names as features itself
x_train = read.table("UCI HAR Dataset/train/x_train.txt",col.names = features[,2])

## Joining Activity Code to Activity Name
y_train_name = join(y_train,activity_labels, by = "Activity_Code")

## Combining all in a single dataset with Activity Code, Activity Desc, Subject and all other measurement
x_train_act_sub = cbind(y_train_name,subject_train,x_train)

# Merging Training and Test Set
Final_dataset_v1 = rbind(x_train_act_sub,x_test_act_sub)

# Assigning column names of the data set to a vector. This will be used to extract the columns where measures of mean and standard deviation are observed
column_names = colnames(Final_dataset_v1)

# Extracting the column numbers for cases where mean and STD are observed
mean_col = grep("mean",column_names)
std_col = grep("std",column_names)

#Creating a vector of all the columns which are required for the final tidy dataset, Also included the first 3 columns for activity and subject
col_in_scope = c(1:3,mean_col,std_col)

#Subsetting the combined dataset for only means and STD columns
Mean_STD_Data = Final_dataset_v1[ , col_in_scope]

#Melting the data frame with Activity Code, Activity Name and Subject as ID. Rest all are variables
Data_Melt = melt(Mean_STD_Data, id = c(1:3),measure.vars = c(4:82))

#Recasting the data which is summarized on Subject number and then Activity Number
Data_Cast = dcast(Data_Melt,Subject_Number+Activity_Code+Activity_Name ~ variable,mean)

#Writing the output dataset to the Working Directory
write.table(Data_Cast,file = "Assignment_Tidy_Data.txt", row.names = FALSE)
