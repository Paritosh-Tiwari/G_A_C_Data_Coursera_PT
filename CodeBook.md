CodeBook
========================================================

This Codebook explains in details the variables and the transformations performed to clean up the data, perform required analysis and produce the desired result.


The Packages required for the course were loaded in the R Environment
```{r}
library(plyr)
library(reshape2)
```

Activity Labels and Features were imported first as these are reference data. The activity labels can be used for describing the activity code and features file can be used for providing column names to the measurement data. Descriptive column names were provided for better clarity of datasets.

```{r}
activity_labels = read.table("UCI HAR Dataset/activity_labels.txt",col.names = c("Activity_Code","Activity_Name"))
features = read.table("UCI HAR Dataset/features.txt", col.names = c("Feather_Column", "Feature_Name"))
```


### Importing Test Dataset

The subject and activity data was imported in R. These data had a single column only. Assigned a descriptive column name for easier identification. Note that the column name 'Activity_Code' was kept same as the column name in the activity_label dataset. This was done to ensure that common columns can be identified easily for joining data later.

```{r}
subject_test = read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "Subject_Number")
y_test = read.table("UCI HAR Dataset/test/y_test.txt",col.names = "Activity_Code")
```

Next the Measurements dataset is imported. The column names are directly assigned while importing the data itself. Refer above code and note that these column names are present in the second column of 'features' data set.

```{r}
x_test = read.table("UCI HAR Dataset/test/x_test.txt",col.names = features[,2])
```

Next a dataset was created for activity names by joining 'y_test' data with the 'activity_labels' data. The join was performed by Activity_Code. Join was used instead of arrange as the arrange command sorts the data which will not allow for the next step in the process where all tables are joined to form one dataset


```{r}
y_test_name = join(y_test,activity_labels, by = "Activity_Code")
```

The resultant table looked like below

```{r}
y_test_name[c(1,10,100,1000,2000,2500,2947),]

     Activity_Code      Activity_Name
1                5           STANDING
10               5           STANDING
100              1            WALKING
1000             1            WALKING
2000             3 WALKING_DOWNSTAIRS
2500             1            WALKING
2947             2   WALKING_UPSTAIRS
```


Now we have three different tables:
* y_test_name- This has the 2947 rows of activities with two columns- Activity_Code and Activity_Name
* subject_test- This table has 2947 rows of Subject_Number
* x_test- This dataset contains 2947 rows and 561 columns of measurement variables

All the above dataset was joined by using cbind as the number of rows are same.

```{r}
x_test_act_sub = cbind(y_test_name,subject_test,x_test)
```

The resulting table has columns as below

* Activity_Code 
* Activity_Name 
* Subject_Number 
* tBodyAcc.mean...X tBodyAcc.mean...Y
* .......all other measurement variables

```{r}
x_test_act_sub[1:5,1:5]

  Activity_Code Activity_Name Subject_Number tBodyAcc.mean...X tBodyAcc.mean...Y
1             5      STANDING              2         0.2571778       -0.02328523
2             5      STANDING              2         0.2860267       -0.01316336
3             5      STANDING              2         0.2754848       -0.02605042
4             5      STANDING              2         0.2702982       -0.03261387
5             5      STANDING              2         0.2748330       -0.02784779
> 
```


### Importing Training Dataset

Exactly the same steps as above were performed to import the training data set. The names were changes from test to train. The result is the x_train_act_sub dataset with the columns same as above.

```{r}
subject_train = read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "Subject_Number")

y_train = read.table("UCI HAR Dataset/train/y_train.txt",col.names = "Activity_Code")

x_train = read.table("UCI HAR Dataset/train/x_train.txt",col.names = features[,2])

y_train_name = join(y_train,activity_labels, by = "Activity_Code")

x_train_act_sub = cbind(y_train_name,subject_train,x_train)
```

### Merging Training and Test Data Set

Since both dataset have exactly the same column names and ordering, both dataset were merged using a simple rbind command

```{r}
Final_dataset_v1 = rbind(x_train_act_sub,x_test_act_sub)
```

The total number of rows in the resulting dataset were sum of rows of training and test dataset. The three extra columns are for Activity_Code, Activity_Label and Subject_Name.

```{r}
> dim(x_test)
[1] 2947  561

> dim(x_train)
[1] 7352  561

> dim(Final_dataset_v1)
[1] 10299   564

```


### Extracting only the measurements on the mean and standard deviation for each measurement

Based on observation of the column names of the merged dataset (Final_dataset_v1), it was noted that the words 'mean' and 'std' were present in measurements of mean and standard deviation.

Assigned the column names of the merged dataset to a vector. This will be used to extract the words 'mean' and 'std'

```{r}
column_names = colnames(Final_dataset_v1)
```

Note that in the above column_name vector, the position of the column name will be same as its position in the merged dataset. This implies that the column_names[1] = "Activity_Code", column_names[5] = "tBodyAcc.mean...Y" and so on.


```{r}
> column_names[1:5]
[1] "Activity_Code"     "Activity_Name"     "Subject_Number"    "tBodyAcc.mean...X"
[5] "tBodyAcc.mean...Y"

```


Now used the 'grep' command to extract the column numbers where 'mean' and 'std' words are present.

```{r}
mean_col = grep("mean",column_names)
std_col = grep("std",column_names)
```

Now created a vector of all the columns which are required for the final tidy dataset, Also included the first 3 columns for Activity_Code, Activity_Label and Subject_Number.

```{r}
col_in_scope = c(1:3,mean_col,std_col)
```

The above vector col_in_scope consists of the numeric reference of the columns which has the mean and std words in it. The output looks something like this.

```{r}
col_in_scope

 [1]   1   2   3   4   5   6  44  45  46  84  85  86 124 125 126 164 165 166 204 217 230 243
[23] 256 269 270 271 297 298 299 348 349 350 376 377 378 427 428 429 455 456 457 506 516 519
[45] 529 532 542 545 555   7   8   9  47  48  49  87  88  89 127 128 129 167 168 169 205 218
[67] 231 244 257 272 273 274 351 352 353 430 431 432 507 520 533 546

```

This vector was now used to subset the original merged data as per the project requirement.

```{r}
Mean_STD_Data = Final_dataset_v1[ , col_in_scope]

```

The Mean_STD_Data contains the activity and subject details along with measurements of mean and standard deviation.

The above dataset has 82 columns. The first 3 columns are for Activity Code, Activity Label and Subject Name. The remaining 79 columns are measurements.

```{r}
dim(Mean_STD_Data)

[1] 10299    82

Mean_STD_Data[1:3,1:5]

  Activity_Code Activity_Name Subject_Number tBodyAcc.mean...X tBodyAcc.mean...Y
1             5      STANDING              1         0.2885845       -0.02029417
2             5      STANDING              1         0.2784188       -0.01641057
3             5      STANDING              1         0.2796531       -0.01946716

```


### Summarizing the Data

The final requirements of the project is to creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

Melt and Cast functions in R were used to performed this task.

First the dataset was melted using the first 3 columns (Activity_Code, Activity_Label and Subject_Number) as ID and all other variables as measures.

```{r}
Data_Melt = melt(Mean_STD_Data, id = c(1:3),measure.vars = c(4:82))

```

The above data looks like this now

```{r}
Data_Melt[1:5,1:5]

  Activity_Code Activity_Name Subject_Number          variable     value
1             5      STANDING              1 tBodyAcc.mean...X 0.2885845
2             5      STANDING              1 tBodyAcc.mean...X 0.2784188
3             5      STANDING              1 tBodyAcc.mean...X 0.2796531
4             5      STANDING              1 tBodyAcc.mean...X 0.2791739
5             5      STANDING              1 tBodyAcc.mean...X 0.2766288

```

Recasted the data and summarized it first on Subject and then Activity. All the measurements were included and their average was taken by using the mean function.

```{r}
Data_Cast = dcast(Data_Melt,Subject_Number+Activity_Code+Activity_Name ~ variable,mean)
```

The final tidy dataset looks like below

```{r}
Data_Cast[1:12,1:5]

   Subject_Number Activity_Code      Activity_Name tBodyAcc.mean...X tBodyAcc.mean...Y
1               1             1            WALKING         0.2773308      -0.017383819
2               1             2   WALKING_UPSTAIRS         0.2554617      -0.023953149
3               1             3 WALKING_DOWNSTAIRS         0.2891883      -0.009918505
4               1             4            SITTING         0.2612376      -0.001308288
5               1             5           STANDING         0.2789176      -0.016137590
6               1             6             LAYING         0.2215982      -0.040513953
7               2             1            WALKING         0.2764266      -0.018594920
8               2             2   WALKING_UPSTAIRS         0.2471648      -0.021412113
9               2             3 WALKING_DOWNSTAIRS         0.2776153      -0.022661416
10              2             4            SITTING         0.2770874      -0.015687994
11              2             5           STANDING         0.2779115      -0.018420827
12              2             6             LAYING         0.2813734      -0.018158740
```

### Writing Tidy Data to Disk

The tidy data was written to disk in .txt format using the write.table() function. Row Names were set as FLASE, otherwise a separate column of row name was getting generated in the output data which created a disparity between the header row and data rows

```{r}
write.table(Data_Cast,file = "Assignment_Tidy_Data.txt", row.names = FALSE)
```


This concludes this CodeBook.

## .................... END .......................
