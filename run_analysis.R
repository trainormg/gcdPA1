## Reads the "Human Activity Recognition Using Smartphones Dataset"
#
# The original zip file containing the dataset must be exploded before 
# running the script. 
# The directory where the data reside can be set using the datadir parameter
# (see below).
# By default, the script assumes the zip file was exploded in the current 
# working directory.
# Directory structure and file names inside the data directory must be the
# same as in the original dataset.


#### main function

### Reads the dataset and returns a tidy, smaller data frame.
## The result contains only the mean values grouped by subject and activity 
## of the variables in the original dataset containing mean or standard
## deviations of raw data.

## inputs:
# datadir: directory containing the unzipped dataset (default 'UCI HAR Dataset')
#   the default value is the name of the directory in the original zip file

## outputs
# a tidy dataset of means

getTidyData <- function(datadir = 'UCI HAR Dataset', outputFile = NULL) {
    
    ## data common to all the subsets
    
    # read the list of features
    # the resulting data.frame will have 2 columns, id and name
    # the stringsAsFactors = FALSE is needed for easier name cleaning
    features <- read.table(file.path(datadir, 'features.txt'), 
        col.names=c("id", "name"), stringsAsFactors = FALSE)
    
    # select the features containing mean or standard deviation
    # toKeep is a logical vectors of features to preserve in the final dataset
    toKeep <- grepl("(mean|std)\\(\\)", features$name)

    # normalize names of variables to keep removing parentheses and running
    # make.names on the result
    features[toKeep, 'name'] <- make.names(
        gsub("\\(\\)", "", features[toKeep, 'name']), unique=TRUE)
    
    # create a vector of class names for the X data file columns
    # we know all the variables are numeric, the "NULL" classes will be skipped
    classes <- lapply(toKeep, function(x) ifelse(x, "numeric", "NULL"))

    # read the descriptive activity names
    actLabels <- read.table(file.path(datadir, 'activity_labels.txt'),
        col.names=c("activityId", "activity"))
    
    
    # initialize result
    tidy <- data.frame()
    
    # for the diferent subsets of data
    for (set in c("test", "train")) {
            
        ## read the X_* file containint all the measures
        
        filePathX <- file.path(datadir, set, sprintf("X_%s.txt", set))
        
        # load in memory only the columns we want to keep with the tidy names
        data <- read.table(filePathX, header=FALSE, comment.char="", 
            colClasses=classes, quote="", blank.lines.skip=TRUE,
            col.names = features$name)

        ## read the activities ids from the y_* file
        filePathY <- file.path(datadir, set, sprintf("y_%s.txt", set))
        
        # the activity id will be in the column 'activityId' (dropped later)
        actIds <- read.table(filePathY, header=FALSE, comment.char="", 
            quote="", blank.lines.skip=TRUE, col.names = c("activityId")
        )
        
        ## read the subject ids
        filePathSubject <- file.path(datadir, set, sprintf("subject_%s.txt", set))
        
        # the subject id will be in the column 'subject'
        subjects <- read.table(filePathSubject, header=FALSE, comment.char="", 
            quote="", blank.lines.skip=TRUE, col.names = c("subject")
        )
        
        # add the subject and activityId columns to the full data frame
        data <- cbind(subjects, actIds, data)
        
        ## compute means

        # we know the subsets do not overlap (the same subject cannot be in
        # 2 different files), so we can group the subset separately

        # append aggregates to result
        tidy <- rbind(tidy, 
            aggregate(data[, -(1:2)], data[, c('subject', 'activityId')], mean))
        
        # note: data.table would probably be faster, but this way we have no
        # external dependencies
    }

    ## replace activity ids with descriptive names
    
    # add the activity name - will be the first column in result
    tidy <- merge(x=actLabels, y=tidy, by='activityId')
    
    # reorder the result by ascending subject and activity name
    # drop the activityId column and reorder the columns so as subject and
    # activity are the fist ones
    tidy <- tidy[order(tidy$subject, tidy$activity), c(3, 2, 4:ncol(tidy))]
    
    # drops the row names automatically added by R but not useful in the final result
    row.names(tidy) <- NULL

    # write result to a file, if outputFile parameter is set
    if (!is.null(outputFile)) {
        write.table(tidy, outputFile)
    }
    
    return(tidy)
}

# gets the tidy final data
tidy <- getTidyData()

# to save the results to a file, run:
# tidy <- getTidyData(outputFile='tidyMeans.txt')

# to look for the data in a different folder, run:
# tidy <- getTidyData(datadir='/my/path/to/dataset')
