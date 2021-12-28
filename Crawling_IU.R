setRepositories(ind = 1:8)

library(tidyverse)
library(lubridate)
library(janitor)
library(glue)
library(rvest)
library(robotstxt)
library(stringr)
library(tidyr)
library(plyr)

#setwd("C:\\Users\\tykim")
#getwd()

Sys.setlocale("LC_ALL","Korean")
Sys.setlocale("LC_ALL","English")

Iu_url <- 'https://en.wikipedia.org/wiki/IU_(singer)'
Iu_page <- read_html(Iu_url)

Iu_table <- Iu_page %>% 
  html_nodes(xpath  = '//*[@id="mw-content-text"]/div[1]/table[4]')

Iu <- html_table(Iu_table)[[1]]

#view(Iu)

Iu2 <- Iu[,-c(5)]
names(Iu2)

Iu2 <- Iu2 %>% 
  separate('Year', "Year", sep = "???") %>% 
  separate('Title', "Title", sep = "\n")
#view(Iu2)

Country <- as.tibble(unique(Iu2$Region))
Country

Iu2
Data1<-c()

Data1 <- Iu2 %>% 
  group_by(Region) %>% 
  summarize(
    Shows_count = sum(Shows)
  )

Data1

Data1 %>% arrange(desc(Shows))


Cap_url <- 'https://en.wikipedia.org/wiki/List_of_national_capitals'
Cap_page <- read_html(Cap_url)

Cap_table <- Cap_page %>% 
  html_nodes(xpath  = '//*[@id="mw-content-text"]/div[1]/table[2]')

Cap<- html_table(Cap_table)[[1]]

#view(Cap)

Cap2 <- Cap[,-c(3)]
#view(Cap2)
names(Cap2)
head(Cap2)

Cap2 <- Cap2 %>% 
  separate('City/Town', "Capital", sep = "\\(") 

names(Cap2) <- c("Capital", "Region")

#Cap2 <- rename('Region' = "Country/Territory") 

Final <- left_join(Iu2, Cap2, by = "Region")
Final <- Final %>% 
  select(Year, Title, Region, Capital, Shows)
view(Final)

