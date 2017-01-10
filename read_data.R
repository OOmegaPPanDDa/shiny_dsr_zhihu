library(readr)
library(dplyr)
library(tidytext)
source('zhihu_preprocessing.R')
source('zhihu_function.R')

all_data_file <- list.files('./data_collect', pattern="*.csv")


all_data_name <- gsub('.csv','',all_data_file)
all_data <- as.data.frame(read_csv(paste0('./data_collect/', all_data_file[1]))) %>% mutate(topic = all_data_name[1])

# the ratio to lighten the burden for server
to_light = 0.3


# lighten the burden for server
all_data <- sample_n(all_data,as.integer(nrow(all_data)*to_light))

for (i in (2:length(all_data_file))){
  add_in <- as.data.frame(read_csv(paste0('./data_collect/',all_data_file[i]))) %>% mutate(topic = all_data_name[i])
  
  # lighten the burden for server
  add_in <- sample_n(add_in,as.integer(nrow(add_in)*to_light))
  
  all_data <- rbind(all_data,add_in)
}



# question_combined <- paste(all_data$question_title, all_data$question_detail)
# doc <- c(unique(all_data$question_combined),unique(all_data$ans))
# all_stop_word <- get_stop_word(unique(doc))
# all_stop_word_df <- get_stop_word_df(unique(doc))

# library(tmcn)
# all_stop_word <- unique(c(all_stop_word, toTrad(stopwordsCN())))

# write(all_stop_word,'all_stop_word.txt')
# write.csv(all_stop_word_df,'all_stop_word_df.csv',row.names = F)


all_stop_word_df <- as.data.frame(read_csv('all_stop_word_df.csv'))
all_stop_word <- readLines('all_stop_word.txt')



# positive_dict <- read_csv('./ntusd/traditional_ntusd_positive.csv')$x
# negative_dict <- read_csv('./ntusd/traditional_ntusd_negative.csv')$x
# 
# positive_dict <- unique(c(positive_dict,read_csv('./der3318/positive.csv')$x))
# negative_dict <- unique(c(negative_dict,read_csv('./der3318/negative.csv')$x))
# 
# bing <- get_sentiments("bing")
# positive_dict <- unique(c(positive_dict,bing[bing$sentiment=='positive',]$word))
# negative_dict <- unique(c(negative_dict,bing[bing$sentiment=='negative',]$word))


# write.csv(positive_dict, 'all_positive.csv', row.names = F)
# write.csv(negative_dict, 'all_negative.csv', row.names = F)

positive_dict <- read_csv('all_positive.csv')$x
negative_dict <- read_csv('all_negative.csv')$x


