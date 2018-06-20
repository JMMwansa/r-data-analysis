#Download data
download.file("https://ndownloader.figshare.com/files/2292169",
              "data/portal_data_joined.csv")
#Load the data
surveys <- read.csv("data/portal_data_joined.csv")
#Examine the first 6 lines 
head (surveys)
str(surveys)
#Indexing and subsettings 
surveys [1, 1] #First element in first column
surveys [1, 6] #First element in first column
surveys [1:3, 7] #First three elements in seventh column
surveys [, 1]#All the values in the first column
surveys [8:11, ]#All the values in rows 8 to 11
surveys_200 <-surveys[200,] #Create a new data.frame
nrow(surveys)#gives you the number of rows in a data.frame 
n_rows <- nrow(surveys)
surveys_last<- surveys[200, ]
#Compare that with what you see as the last row using tail () to make sure it's meeting expectations

tail(surveys)
middle_row <- nrow(surveys)/2
surveys_middle <- surveys[middle_row, ]

#Store the content of this row in an object named surveys_middle 

#Combine nrow() with the -notation to reproduce the behavious of head (surveys), keeping #just the first through 6th rows of the surveys database

