Getting and Cleaning Data
======

## Peer Assessment 1

### run_analysis.R

The run_analysis.R script will read the "Human Activity Recognition Using Smartphones Dataset" data files 
to create a tidy data with the following characteristics:
* The different data files in the original data are merged into a single file.
* The first two columns of this tidy data set are the subject id and the descriptive name of the performed activity.
* Of the 561 original variables, only those on the mean and standard deviation for each measurement are extracted and added to the tidy result.
* The names of the variables are "normalized" to make them easier to use in R.
* The data in the tidy result are average of the original values of each variable for each activity and each subject.

The data files in the original dataset and the variables they contain are described in the README.txt and 
features_info.txt files that can be found in the dataset.

The dataset can be downloaded here: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

#### Usage and requirements

The zip file containing the dataset must be downloaded and unzipped locally before running the script.  
The script, by default, requires the zip to be exploded "as is" in its current working directory. 
That is, all the data files are expected to be in the 'UCI HAR Dataset' directory.

You can change this default behaviour passing the directory containing the data as a parameter to the `getTidyData` function. See the script for more details.

To run the script with the default configuration in R or RStudio, set your working directory to the folder containing the script and the uncompressed zip file and run 
source('run_analysis.R') from R or RStudio.  
At the end of the execution, the tidy dataset will be in the `tidy` variable.  
To automatically save the results to a file during script execution, you can run `tidy <- getTidyData(outputFile='tidyMeans.txt')`.

#### Data codebook

The variables in the original dataset, the measures collected, the definitions of subject and activity are described 
in the README.txt and features_info.txt files accompanying the data.  

The tidy dataset contains one row for each subject and each activity.
The first two columns contain the subject id (`subject`) and the descriptive name of the activity (`activity`).  
The remaining 66 columns contain the mean (obtained aggregating by subject and activity) of the variables in the original dataset relative to mean or 
standard deviation of measurements, one column in the destination for each column in the input data to preserve (non mean or std columns are skipped).  
The output variables are selected/renamed according to the following rules:
* only variables containing mean() or std() in their names are preserved;
* parentheses are removed;
* names are normalized using `make.names', that makes "syntactically valid names out of character vectors".

So, for example, the column name `tBodyAcc-mean()-X` in the original file becomes `tBodyAcc.mean.X` in the tidy dataset, the column `tBodyAcc-mad()-X` is skipped.

The following table shows an example of the tidy output:

| subject | activity | tBodyAcc.mean.X | ... 64 more measures ... | fBodyBodyGyroJerkMag.std
| 1 | LAYING | 0.2215982 | ... | -0.9326607
| 1 | SITTING | 0.2612376 | ... | -0.9870496
| 1 | STANDING | 0.2789176 | ... | -0.9946711
| 1 | WALKING | 0.2773308 | ... | -0.3816019
| 1 | WALKING_DOWNSTAIRS | 0.2891883 | ... | -0.3919199
| 1 | WALKING_UPSTAIRS | 0.2554617 | ... | -0.6939305
| 2 | LAYING | 0.2813734 | ... | -0.9894927
| 2 | SITTING | 0.2770874 | ... | -0.9896329
| 2 | STANDING | 0.2779115 | ... | -0.9777543
| 2 | WALKING | 0.2764266 | ... | -0.5581046
`...`

for the purposes of this analysis, the variables were defined as


### Reference

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012
