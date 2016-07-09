# Set up workspace (removing data sets)
rm(list=ls())

# Sets working directory. Here is where the UCI HAR Dataset was unzipped
setwd("C:/Users/Gilberto/Documents/Project/UCI HAR Dataset")

# Reads data from files and stores in variable
features <- read.table('./features.txt',header=FALSE)
activityType <- read.table('./activity_labels.txt',header=FALSE)
subjectTrain <- read.table('./train/subject_train.txt',header=FALSE)
xTrain <- read.table('./train/x_train.txt',header=FALSE)
yTrain <- read.table('./train/y_train.txt',header=FALSE)

# Assigins column names to the data imported on previuos step
colnames(activityType) <- c('activityId','activityType')
colnames(subjectTrain) <- "subjectId"
colnames(xTrain) <- features[,2] 
colnames(yTrain) <- "activityId"

# Creates the final training data set by combining yTrain, subjectTrain and xTrain
trainingData <- cbind(yTrain,subjectTrain,xTrain)

# Reads test data and stores in variable
subjectTest <- read.table('./test/subject_test.txt',header=FALSE)
xTest <- read.table('./test/x_test.txt',header=FALSE)
yTest <- read.table('./test/y_test.txt',header=FALSE)

# Assigins column names to the data imported on previuos step
colnames(subjectTest) <- "subjectId"
colnames(xTest) <- features[,2]
colnames(yTest) <- "activityId"

# Creates the final test data set by combining yTest, subjectTest and xTest
testData <- cbind(yTest,subjectTest,xTest)

# Combines both training and test data to get the final data set
finalData <- rbind(trainingData,testData)

# Creates vector for the column names from the finalData
colNames <- colnames(finalData)

# Logical Vector containing TRUE for the ID, mean() & stddev() columns and FALSE for others
logicalVector <- (grepl("activity..",colNames) | grepl("subject..",colNames) | grepl("-mean..",colNames) & !grepl("-meanFreq..",colNames) & !grepl("mean..-",colNames) | grepl("-std..",colNames) & !grepl("-std()..-",colNames))

# Subsets finalData table by using the logical Vector
finalData <- finalData[logicalVector==TRUE]

# Merges the final data set with the acitivityType table to include descriptive activity names
finalData <- merge(finalData,activityType,by='activityId',all.x=TRUE)

# Updating colNames to include the new column names after merge
colNames <- colnames(finalData)

# Cleaning up the variable names
for (i in 1:length(colNames)) 
{
  colNames[i] <- gsub("\\()","",colNames[i])
  colNames[i] <- gsub("-std$","StdDev",colNames[i])
  colNames[i] <- gsub("-mean","Mean",colNames[i])
  colNames[i] <- gsub("^(t)","time",colNames[i])
  colNames[i] <- gsub("^(f)","freq",colNames[i])
  colNames[i] <- gsub("([Gg]ravity)","Gravity",colNames[i])
  colNames[i] <- gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",colNames[i])
  colNames[i] <- gsub("[Gg]yro","Gyro",colNames[i])
  colNames[i] <- gsub("AccMag","AccMagnitude",colNames[i])
  colNames[i] <- gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",colNames[i])
  colNames[i] <- gsub("JerkMag","JerkMagnitude",colNames[i])
  colNames[i] <- gsub("GyroMag","GyroMagnitude",colNames[i])
}

# Reassigning new column names to the finalData set
colnames(finalData) <- colNames

# Creates a new table, finalDataNoActivityType without the activityType column
finalDataNoActivityType <- finalData[,names(finalData) != 'activityType']

# Summarizing finalDataNoActivityType table to include just the mean of each variable for each activity and each subject
tidyData <- aggregate(finalDataNoActivityType[,names(finalDataNoActivityType) != c('activityId','subjectId')],by=list(activityId=finalDataNoActivityType$activityId,subjectId = finalDataNoActivityType$subjectId),mean)

# Merging tidyData with activityType to include descriptive acitvity names
tidyData <- merge(tidyData,activityType,by='activityId',all.x=TRUE)

# Exports tidyData set 
write.table(tidyData, './tidyData.txt',row.names=TRUE,sep='\t')