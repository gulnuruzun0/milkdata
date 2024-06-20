#calling the libraries to be used in case
library(dplyr)
library(ggplot2)
library(tidyr)

#MilK.CSV file have read with read.table() function, rownames have removed from this table

milk.data =read.table("Milk.csv", header = TRUE, sep = ",", row.names = 1)
head(milk.data)

#assign the centered plot title to centered.plot.title
#element_text() is used to specify the appearance of text elements.
#hjust = 0.5: align the title centrally in page.

centered.plot.title = theme(plot.title = element_text(hjust = 0.5)) 

#Part a:

boxplot.protein.vs.diet = ggplot(data = milk.data)+
  aes(x = Diet, #categoric attribe in x-axes
      y = protein, #numeric attribute in y-axes
      color = Diet)+
  geom_boxplot()+ #boxplot have added
  geom_point()+ #data points have added
  geom_jitter(alpha=0.4)+ #density of data point, with alpha option have added the transparency
  labs(title = "Boxplot of Protein Measurements by Feeding Strategy (All Data Points)",
       x = "Feeding Strategy", 
       y = "Protein Measurements")+
  centered.plot.title #title have set to center
boxplot.protein.vs.diet

#Part b

boxplot.w1.filter = milk.data %>% 
  filter(Time == 1) %>% #filtering the first week
  ggplot(aes(x = Diet,
             y = protein,
             color = Diet))+ #color scale by Diet type
  geom_boxplot()+ #boxplot have added
  geom_point()+
  labs(title = "Boxplot of Protein Measurements by Feeding Strategy (First Week Data)",
       x = "Feeding Strategy", 
       y = "Protein Measurements")+
  centered.plot.title #title have set to center
boxplot.w1.filter

#Part c

select.cow.line.plot = milk.data %>% 
  filter(Cow %in% c("B01", "B02", "BL01", "BL02", "L01", "L02") & Time <= 18) %>% #relevant cows and time scale have defined
  ggplot(aes(x = Time,
             y = protein,
             color = Cow))+ #different color for each cow
  geom_line()+ #lines have added
  geom_point()+ #points have added
  labs(title = "Protein Content Changes Over Time for Selected Cows",
       x = "Week",
       y = "Protein Content")+
  centered.plot.title #title have set to center
select.cow.line.plot

#Part d

subplot.feeding.cow = select.cow.line.plot+
  facet_wrap(~Diet)
subplot.feeding.cow

#Part e

avg.protein.vs.week.scatter.plot = milk.data %>% 
  group_by(Time) %>% #group by the time (week)
  summarise(n_cows = n(), #for each week, number of cows
            average.protein.content = mean(protein)) %>% #for each week, average of the protein measurments
  ggplot(aes(x = Time,
             y = average.protein.content,
             label = n_cows, #number of cows labels have defined
             color = Time))+ #color scales by the time
  geom_point()+ #points have added
  geom_text(hjust = -0.2, nudge_x = 0.2)+ #in relevant week, number of cows 
  
  #The code adjusts text elements on the plot using geom_text(). 
  #hjust = -0.2 aligns the text horizontally to the left, and 
  #nudge_x = 0.2 shifts the text 0.2 units to the right along the x-axis.
  
  labs(title = "Week Number vs. Mean Protein Content",
       x = "Week Number",
       y = "Mean Protein Content")+
  centered.plot.title #title have set to center
avg.protein.vs.week.scatter.plot


#Part g

time.diet.filter.scatter.plot = milk.data %>% 
  group_by(Time, Diet) %>% #grouped by time and diet features
  summarise(n.cow.time.diet = n(), #number of cows by the time and diet
            avg.protein.content.time.diet = mean(protein)) %>% #mean of the protein measurment by the time and diet feature
  ggplot(aes(x = Time,
             y = avg.protein.content.time.diet,
             label = n.cow.time.diet))+ #label have set for the number of cows by diet and week
  geom_point(aes(color = Diet))+ #color scaled by the type of diet
  geom_text(hjust = -0.2, nudge_x = 0.2)+ #in relevant week and diet type number of cows 
  labs(title = "Week Number vs. Mean Protein Content",
       x = "Week Number",
       y = "Mean Protein Content")+
  centered.plot.title #title have set to center
time.diet.filter.scatter.plot

#Part h

new.milk.data <- milk.data %>% #with pivot_wider converted to wide format 
  pivot_wider(names_from = Time, #new column information have assigned
              values_from = protein) %>% #for wide format, new values have assigned as the protein measurment info
  as.data.frame() #have converted the dataframe
head(new.milk.data)
