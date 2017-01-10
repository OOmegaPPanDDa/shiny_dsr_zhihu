library(readr)
library(dplyr)
library(tidytext)
source('zhihu_preprocessing.R')

all_data_file <- list.files('./data_collect', pattern="*.csv")
all_data_file <- all_data_file

all_data_name <- gsub('.csv','',all_data_file)
all_data <- as.data.frame(read_csv(paste0('./data_collect/', all_data_file[1]))) %>% mutate(topic = all_data_name[1])

# lighten the burden for server
all_data <- sample_n(all_data,as.integer(nrow(all_data)*0.5))

for (i in (2:length(all_data_file))){
  add_in <- as.data.frame(read_csv(paste0('./data_collect/',all_data_file[i]))) %>% mutate(topic = all_data_name[i])
  
  # lighten the burden for server
  add_in <- sample_n(add_in,as.integer(nrow(add_in)*0.5))
  
  all_data <- rbind(all_data,add_in)
}


# ans <- clean_text(unique(all_data$ans))
# all_stop_word <- get_stop_word(unique(ans))
# all_stop_word_df <- get_stop_word_df(unique(ans))

# write(all_stop_word,'all_stop_word.txt')
# write.csv(all_stop_word_df,'all_stop_word_df.csv',row.names = F)


all_stop_word_df <- as.data.frame(read_csv('all_stop_word_df.csv'))
all_stop_word <- all_stop_word_df$word




positive_dict <- read_csv('./ntusd/traditional_ntusd_positive.csv')$x
negative_dict <- read_csv('./ntusd/traditional_ntusd_negative.csv')$x

positive_dict <- unique(c(positive_dict,read_csv('./der3318/positive.csv')$x))
negative_dict <- unique(c(negative_dict,read_csv('./der3318/negative.csv')$x))

bing <- get_sentiments("bing")
positive_dict <- unique(c(positive_dict,bing[bing$sentiment=='positive',]$word))
negative_dict <- unique(c(negative_dict,bing[bing$sentiment=='negative',]$word))




library(fpc)
library(cluster)
library(ggplot2)
library(scatterplot3d)

zhihu_data <- all_data %>% filter(topic=='basketball')
zhihu_data <- as.data.frame(zhihu_data)

ans_count_limit = 200
qid = 1


# 篩選回答數夠多的問題
zhihu_data <- zhihu_data %>% 
  group_by(question_title) %>%
  mutate(ans_count = n()) %>%
  ungroup() %>%
  filter(ans_count > ans_count_limit)


# 透過 qid 找出鎖定某一問題
ans <- zhihu_data[zhihu_data$question_title == unique(zhihu_data$question_title)[qid],]

ans$ans <- clean_text(ans$ans)
stop_word <- get_stop_word(ans$ans)
ans$aid <- seq(1:nrow(ans))

ans_word <- ans
data_number <- nrow(ans_word)

ans_word$ans_seg <- sapply(ans_word$ans, function(x) paste(filter_segment(segment(x,seg_worker),stop_word),collapse = ' '))



library(rJava)
library(tm)
library(SnowballC)
library(slam)
library(XML)
library(RCurl)
library(Matrix)


if (!require('tmcn')) {
  devtools::install_github("OOmegaPPanDDa/tmcn")
}
library(tmcn)

if (!require('Rwordseg')) {
  devtools::install_github("OOmegaPPanDDa/Rwordseg")
}
library(Rwordseg)




space_tokenizer <- function(x){
  unlist(strsplit(as.character(x[[1]]),'[[:space:]]+'))
}



# Transform the entire answer column into a corpus
d_corpus <- VCorpus(VectorSource(as.vector(ans_word$ans_seg)))

# Remove punctuation
d_corpus <- tm_map(d_corpus, removePunctuation)

# Remove numbers
d_corpus <- tm_map(d_corpus, removeNumbers)
#inspect(d_corpus)
#print(toTrad(stopwordsCN()))

#Remove stopwords
d_corpus <- tm_map(d_corpus, removeWords, toTrad(stopwordsCN()))
d_corpus <- tm_map(d_corpus, removeWords, all_stop_word)

# Remove whitespace
d_corpus = tm_map(d_corpus, stripWhitespace)

# Transform back into vector
d_corpus <- Corpus(VectorSource(d_corpus))

# Use control list with space tokenizer
control_list=list(wordLengths=c(2,Inf),tokenize=space_tokenizer)
tdm <- TermDocumentMatrix(Corpus(VectorSource(d_corpus)), control = control_list)

# Tf-idf computation
tf <- apply(tdm, 2, sum) # term frequency
idf <- function(word_doc){ log2( (length(word_doc)) / (nnzero(word_doc)+1)) }
idf <- apply(tdm, 1, idf)
ans_tfidf <- as.matrix(tdm)
for(i in 1:nrow(tdm)){
  for(j in 1:ncol(tdm)){
    ans_tfidf[i,j] <- (ans_tfidf[i,j] / tf[j]) * idf[i]
  }
}

ans_tfidf <- as.data.frame(ans_tfidf)
ans_tfidf[is.na(ans_tfidf)] <- 0

ans_tfidf <- ans_tfidf[rowSums(ans_tfidf)> 0.2,]


ans_tfidf <- t(ans_tfidf)




t_ans_kmeans <- kmeans(t(ans_tfidf), 3)
t_ans_kmeans$cluster <- as.factor(t_ans_kmeans$cluster)

# plotcluster(t(ans_tfidf), t_ans_kmeans$cluster)
# clusplot(t(ans_tfidf), t_ans_kmeans$cluster, color=TRUE, shade=TRUE, labels=2, lines=0)

ans$km1 <- t_ans_kmeans$centers[1,]
ans$km2 <- t_ans_kmeans$centers[2,]
ans$km3 <- t_ans_kmeans$centers[3,]

