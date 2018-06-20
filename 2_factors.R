Factors 

sex <- factor (c("male", "female", "female", "male"))
levels (sex)
nlevels(sex)

#Plot of females capture against males
plot(surveys$sex)

#Create a subset of the sex data 
sex <-surveys$sex
levels(sex)

#Overwrite the missing label 
levels(sex)[1] <- "Undertermined"
levels(sex)

#Exercise -Change the label F to Female and M to Male 
levels(sex)[2]<-"F"
levels(sex)[3]<-"M"
levels(sex)

levels(sex)[2:3]<- c("Female", "Male")
levels(sex)
plot(sex)

#Reorder the position of the factors to put 'undetermine' last 
sex <- factor(sex, levels = c("Female", "Male", "Undetermined"))
plot(sex)
