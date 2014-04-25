G_A_C_Data_Coursera_PT
======================

This repository has been created as part of the Mini-Project for completion of Coursera Data Science Specialization Course- Getting and Cleaning Data

Only a single script has been used for performing the tasks required as per the Project.

Comments are included in the scripts for each line of code to explain the purpose of using the code and the expected output.

### Script Considerations
The script was written on R Studio. Hence instead of <- symbol, "=" was used. Both are equivalent in R Studio. However, if you are executing the script in base R, then you will have to change all the "=" symbols to <-.


### Data Input Assumptions
It is assumed that the data downloaded from the web has been unzipped in the Working Directory. This implies that there is a folder named UCI HAR Dataset in the Working Directory and all other files are inside this folder as such. No data file is moved or altered in any way either in terms of name or location.


### Data Output Format
The resulting tidy data is present in a text format (.txt file). The data is arranged first by Subject and then by Activity. Hence there are 6 rows for each subject and a total of 180 rows. 


### IMP- Considerations while checking the Tidy Data
The data is present in .txt format. Opening the data directly in a notepad or wordpad file does not clearly represent the structure of the data. One option would be to open the data in softwares such as notepad++ which will depict the structure in the correct format. Other option would be to import the data in R and check its structure. Do note that while importing, use header = TRUE otherwise R gives its own column names to data which messes up the entire structure. The input command should be as below:

```{r}
 Tidy_Data = read.table("Assignment_Tidy_Data.txt", header = TRUE)
```
