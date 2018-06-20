#Analysing data

#Installing Tidyverse
install.packages("tidyverse")

#Load the library to make available to scripts
library("tidyverse")

#Load the surveys data using read_csv from readr
download.file("https://ndownloader.figshare.com/files/2292169",
              "data/portal_data_joined.csv")
surveys <-read_csv("data/portal_data_joined.csv")
str(surveys)
head(surveys)
surveys
colnames(surveys)
head(surveys)

#Use the square bracket subsetting to select rows from 1978 only 
surveys [surveys$year == "1978", ]

#dplyr
#filter-used to select rows
filter(surveys, year == 1978)

#select - used to select columns 

select(surveys, year, plot_id, species_id)

#select only the three columns above but only from 1978 

surveys_filtered <- filter (surveys, year == 1978)
surveys_filtered

select(surveys_filtered, year, plot_id, species_id)

#Stitching it together with a pipe
# %>% shortcut to type a pipe is shift-ctryl-m (%>%)

surveys_short <- # this will allow you to save a short version of the data below 
  surveys %>% 
  filter(year == 1978) %>% 
  select(year, plot_id, species_id)
?select

#mutate- to create new columns based on existing columns or on some operations done on existing columns

surveys %>% 
  select(weight, species)

surveys %>% 
  mutate(weight_kg = weight/1000) %>%  This will create a new column with weight in kg
 select(starts_with("w"))
 
 #CHALLENGE 1
 
 #Create a new data frame from surveys that contains: only species_id column and a new column
 #called hindfoot_half containing half of values from column
 ##hindfoot_length.All the values in hindfoot_half should be smaller than 30 
 
#pipe surveys first 
 mutate(hindfoot_half = hindfoot_length/2) %>% 
filter(hindfoot_half < 30) %>% 
select(species_id, hindfoot_half)

 
#HOW TO REMOVE MISSING OBSERVATIONS 
 
 surveys %>% 
 select(starts_with("w")) %>% 
 filter(!is.na(weight)) #filters OUT rows in column weight that are NOT na(missing data)

#other functions and parameters to remove missing observations 
 
 ?complete.cases
 ?na.omit
 ?na.rm = true
 
 #how to have a summary overview of a dataset
 
 surveys
 
 table(surveys$year)
 
#cheching how many different years the observations were run for 
 
length(table(surveys$year)) 

#checking the range

range(surveys$year)

#checking the different ranges 

range(surveys$species) 

#a summary of the survey

summary(surveys)

#splitting and running calculations on groups 

surveys %>% 
  group_by(year) %>% 
summarise(mean_hindfoot_length = mean(hindfoot_length, na.rm = TRUE)) #TO GET RID OF N/A

surveys %>% 
  filter(!is.na(weight)) %>% 
  group_by(sex, species_id) %>% 
  summarise(mean_weight = mean(weight))

surveys %>% 
  filter(!is.na(weight)) %>% 
  group_by(sex, species_id) %>% 
  summarise(mean_weight = mean(weight),
            min_weight = min(weight), 
            sd_weight = sd(weight))
surveys %>% 
count(sex, species) %>% 
print(n = 81)  

surveys %>% 
  count(species, sort = TRUE)  #by default R will sort the species in descending order 

#Arrange - used to rearrange rows

surveys %>% 
  count(species, sort = TRUE)

surveys %>% 
  count(sex, species) %>% 
  arrange(species, desc(n))

#HOW MANY INDIVIDUALS WERE CAUGHT IN EACH PLOT_TYPE 

surveys %>% 
  count(plot_type)
  
surveys %>% 
  group_by(plot_type) %>% 
  tally()

#CHALLENGE 3
#What is the heaviest animal measured in each year? return columns year,genus,species_id and weight
#

surveys %>% 
  filter(!is.na(weight)) %>% 
  group_by(year) %>% 
  summarise(max_weight = max(weight)) %>%  
  arrange(desc(max_weight))

surveys %>% 
  filter(!is.na(weight)) %>% 
  group_by(year) %>% 
  filter(weight == max(weight)) %>% 
  select(year, genus, species_id, weight) %>% 
  arrange(desc(weight))

surveys_complete <-
  surveys %>% 
  filter(!is.na(weight),
         !is.na(hindfoot_length),
         !is.na(sex))

#keep the species for which there are atleast 50 observations
species_counts <- surveys_complete %>% 
  count(species_id) %>% 
  filter(n>=50)


num_species <- surveys_complete %>% 
  count(species_id) %>% 
  filter(n >= 1000)

surveys_complete %>% 
  filter(species_id %in% num_species$species_id)
  
#lets say you want to understand what the %in% sign does 

animals<- c("pig", "cat", "dog", "donkey", "gorilla", "mouse") 
animals

other_animals<- c("zebra", "parrot", "donkey", "cat", "camel")

animals<- c(animals, "zebra", "parrot", "camel")

animals %in% other_animals

other_animals %in% animals

intersect(animals, other_animals)

#reduce the surveys_complete object so that it only contains species with atleast 50 observation(these
#species are in object species_counts)

surveys_complete <-
  surveys_complete %>% 
  filter(species_id %in% species_counts$species_id)

dim(surveys_complete)

#to save 

write_csv(surveys_complete, "data/surveys_complete.csv")


#HOW TO PLOT WITH GGPLOT2

ggplot(data = surveys_complete, mapping =aes(x= weight, y = hindfoot_length)) + geom_point()

#ggplot enables you to plot data and addition of a + sign means you can keep adding elements to this plot 

surveys_plot <- ggplot(data = surveys_complete, mapping =aes(x= weight, y = hindfoot_length)) 

surveys_plot + geom_point()

#ggplot needs 3 things 

#ggplot needs data
#ggplot needs aesthetics or mapping of variables from the data to the plot
#ggplot also needs visualisation type of data 

ggplot(data = surveys_complete, mapping =aes(x= weight, y = hindfoot_length)) + geom_point(alpha = 0.1, aes(color = species_id))

#to make points less transparent enter alpha-0.1 indicates that this is 10% less transparent 
#to change colour just enter colour and name of colour 
#what does aes(color?) mean 

ggplot(data = surveys_complete, mapping =aes(x= species_id, y = hindfoot_length)) + geom_boxplot() + geom_jitter(alpha=0.1, color = "tomato")



#use geomjitter when you have too many point 

yearly_counts <- 
  surveys_complete %>% 
  group_by(year, species_id) %>% 
  tally()

surveys_complete %>% 
  group_by(year, species_id) %>% 
  tally()

yearly_counts

ggplot(data = yearly_counts, mapping = aes(x = year,y =n))+ geom_line()

ggplot(data = yearly_counts, mapping = aes(x = year,y =n, group = species_id))+ geom_line()

ggplot(data = yearly_counts, mapping = aes(x = year,y =n, colour = species_id))+ geom_line()

#if you put colour in the aes it will group your data in different colours.

#faceting-splitting display of data into multiple subgroups 

ggplot(data = yearly_counts, mapping = aes(x = year,y =n ))+ geom_line() + facet_wrap(~species_id)

#~ this tells ggplot to split the graphs indidividually 
#FACETING IS VERY GOOD IF YOU HAVE MULTIPLE DATA SETS OF DATA 

#IF YOU WANT TO DISPLAY BOTH DATA SETS FOR FEMALES AND MALES IN THE SAME FORMAT YOU NEED TO 
#CREATE A NEW GROUP

yearly_sex_counts<-surveys_complete %>% 
  group_by(year, species_id, sex) %>% 
  tally()

ggplot(data = yearly_sex_counts, mapping = aes(x = year,y =n, colour = sex ))+ geom_line() + facet_wrap(~species_id)+
  ggtitle("Species counts over time")

#if you need to add title to your graph just add ggtitle("title")

ggplot(data = yearly_sex_counts, mapping = aes(x = year,y =n, colour = sex ))+ geom_line() + facet_wrap(~species_id)+
 labs(title="Species counts over time", x="year of observation", y="Number of species")+ theme(axis.text.x=element_text(angle=45))

#this is if you want your axis to be displayed at an angle so that they are not overlapping.

#how to save your graph 
ggsave("data/my_fancy_plot.pdf")

#you can save this graph in format that you would like. 
#you can also change the width and height of your graph 

ggsave("data/my_fancy_plot.png", width = 15, height = 10, dpi=300)
