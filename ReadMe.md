---
title: "ReadMe"
author: "Brad Bailey"
date: "October 13, 2015"
output: html_document
---

First I read the variable names from the features.txt file.

Next, I read the data from the X_test.txt and X_train.txt files.


I immediately read the subject identification numbers and the activity number from the files, subject_test.txt and y_test.txt (or used "_train" for the training data) and attached these as columns to the two "X_" files.  

Recall, the y_test and y_train text files have the activities listed as numbers.  I defined a character vector, called ActivityVector, which I used to replace the Activity.


I used the select command (from the dplyr package) to simultaneously rearrange columns to put Subject_ID_Number and Activity in the first two columns while keeping only the variables whose names included the character string "mean" or "std" (with or without capitalization).  I excluded the variables that included the string "Freq" because these are the mean frequencies of these measurements, and the mean frequency is a different statistics (different from just a mean).


Next, I merged the two data files together to create CombinedFile.


I used a set of nested For-loops to create a dataframe, I called PenultimateFile.  This dataframe had no column headings and lacked the Subject_ID_numbers and Activity variables, but each row was the average of the variable for one of the columns from the previous file, subsetted for just one subject and activity at a time.  

The last step was to append the Subject_ID_numbers and Activity columns.  I used cbind to place these two variables in the first two columns of the file I named UltimateFile.
