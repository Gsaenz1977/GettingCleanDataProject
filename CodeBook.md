## Getting and Cleaning Data Project

### Description
Additional information about the variables, data and transformations used in the course project for the Johns Hopkins Getting and Cleaning Data course.

### Source Data
A full description of the data used in this project can be found at [The UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

[The source data for this project can be found here.](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

# Variables

* `xTrain`, `yTrain`, `xTest`, `yTest`, `subjectTrain`, `activityType`, `features` and `subjectTest` contain the data from the downloaded files.
* `trainingData` and `testData` combines the previous datasets to further analysis.
* `finalData` combines `trainingData` and `testData` in a big dataset. After that, it is merged with `activityType`
* Finally, `tidyData` contains the relevant averages which will be later stored in a `.txt` file.
