library(NLP)


if (!require('jiebaRD')) {
  devtools::install_github("qinwf/jiebaRD")
}
library(jiebaRD)


if (!require('jiebaR')) {
  devtools::install_github("qinwf/jiebaR")
}
library(jiebaR)



library(dplyr)


# cutter = worker(dict = "www/jieba.dict.utf8", hmm = "www/hmm_model.utf8", user = "www/user.dict.utf8",
#                 idf = "www/idf.utf8", stop_word ="www/stop_words.utf8")
# keys = worker("keywords",dict = "www/jieba.dict.utf8", hmm = "www/hmm_model.utf8", user = "www/user.dict.utf8",
#               idf = "www/idf.utf8", stop_word ="www/stop_words.utf8", topn = 10)


DICTPATH <- "www/jieba.dict.utf8"
HMMPATH <- "www/hmm_model.utf8"
IDFPATH <- "www/idf.utf8"

seg_worker = worker(dict = "www/jieba.dict.utf8", hmm = "www/hmm_model.utf8", idf = "www/idf.utf8")




# 清理文本
clean_text <-  function(text){
  
  # 濾網頁標籤元素
  text <- gsub('<br>','',text)
  
  text <- gsub('<ul.*?>','',text)
  text <- gsub('</ul>','',text)
  text <- gsub('<li.*?>','',text)
  text <- gsub('</li>','',text)
  text <- gsub('<ol.*?>','',text)
  text <- gsub('</ol>','',text)
  
  text <- gsub('<blockquote>','',text)
  text <- gsub('</blockquote>','',text)
  text <- gsub('<strong>','',text)
  text <- gsub('</strong>','',text)
  text <- gsub('<i.*?>','',text)
  text <- gsub('</i>','',text)
  text <- gsub('<u.*?>','',text)
  text <- gsub('</u>','',text)
  text <- gsub('<b.*?>','',text)
  text <- gsub('</b>','',text)
  text <- gsub('<p.*?>','',text)
  text <- gsub('</p>','',text)
  
  text <- gsub('&gt;','',text)
  text <- gsub('&lt;','',text)
  text <- gsub('&amp;','',text)
  text <- gsub('&quot;','',text)
  text <- gsub('&nbsp;','',text)
  
  text <- gsub('<img.*?>','',text)
  
  text <- gsub('<a.*?>','',text)
  text <- gsub('</a>','',text)
  
  text <- gsub('<span.*?>','',text)
  text <- gsub('</span>','',text)
  
  # 濾 url
  text<- gsub('https?://(\\w|[[:punct:]])*','',text)
  
  # 濾過多的重複無意義字元
  text <- gsub('\n',' ',text)
  text <- gsub('\t',' ',text)
  text <- gsub('\r',' ',text)
  text <- gsub('\\s\\s+',' ',text)
  text <- gsub('[[:punct:]][[:punct:]][[:punct:]]+',' ',text)
  
  return(text)
}







# 取得 stop word
get_stop_word <- function(document){
  
  # seg_worker <- worker()
  
  # prevent open error
  document <- gsub('/var/log', 'var log', document)
  
  # method1
  doc_seg_list <- list(c(seg_worker['The Seg List']))
  for (doc in document){
    if(is.na(doc)){
      doc_seg_list <- c(doc_seg_list,list(NA))
    }else if(doc == '.'){
      doc_seg_list <- c(doc_seg_list,list(NA))
    }else{
      doc_seg_list <- c(doc_seg_list,list(c(seg_worker[doc])))
    }
  }
  doc_seg_list <- doc_seg_list[2:length(doc_seg_list)]
  doc_idf <- get_idf(doc_seg_list, stop_word = NULL)
  doc_idf_sorted <- doc_idf[order(-doc_idf$count),]
  stop_word <- doc_idf_sorted$name[1:as.integer((0.0025*nrow(doc_idf_sorted)))]
  stop_word <- as.vector(stop_word)
  return (stop_word)
  
  
  
  # method2
  # seg_word <- seg_worker[document]
  # seg_word <- unique(seg_word)
  # seg_word_df <- data.frame(word = seg_word, df_value = rep(0, length(seg_word)))
  # for (doc in document){
  #   doc_seg <- seg_worker[doc]
  #   for (w in seg_word){
  #     if(is.element(w, doc_seg)){
  #       seg_word_df$df_value[seg_word_df$word == w] <- seg_word_df$df_value[seg_word_df$word == w] + 1
  #     }
  #   }
  # }
  # 
  # seg_word_df_sorted <- seg_word_df[order(-seg_word_df$df_value),]
  # stop_word <- seg_word_df_sorted$word[1:as.integer(0.01*nrow(seg_word_df_sorted))]
  # stop_word <- as.vector(stop_word)
  # return (stop_word)
  
  # method3
  # seg_word <- seg_worker[document]
  # word_freq <- as.data.frame(table(seg_word))
  # word_freq_sorted <- word_freq[order(-word_freq$Freq),]
  # stop_word <- word_freq_sorted$seg_word[1:as.integer(0.01*nrow(word_freq_sorted))]
  # stop_word <- as.vector(stop_word)
  # return (stop_word)
}








get_stop_word_df <- function(document){
  
  # seg_worker <- worker()
  
  # prevent open error
  document <- gsub('/var/log', 'var log', document)
  
  # method1
  doc_seg_list <- list(c(seg_worker['The Seg List']))
  for (doc in document){
    if(is.na(doc)){
      doc_seg_list <- c(doc_seg_list,list(NA))
    }else if(doc == '.'){
      doc_seg_list <- c(doc_seg_list,list(NA))
    }else{
      doc_seg_list <- c(doc_seg_list,list(c(seg_worker[doc])))
    }
  }
  doc_seg_list <- doc_seg_list[2:length(doc_seg_list)]
  doc_idf <- get_idf(doc_seg_list, stop_word = NULL)
  doc_idf_sorted <- doc_idf[order(-doc_idf$count),]
  stop_word_df <- doc_idf_sorted[1:as.integer((0.0025*nrow(doc_idf_sorted))),]
  stop_word_df$freqRatio <- stop_word_df$count/length(document)
  colnames(stop_word_df) <- c('word','count','freqRatio')
  
  return (stop_word_df)
}


# Example of Using

# library(readr)
# 
# zhihu_data <- read_csv("./data_collect/taiwan.csv")
# zhihu_data <- as.data.frame(zhihu_data)
# 
# zhihu_data$question_title <- clean_text(zhihu_data$question_title)
# zhihu_data$question_detail <- clean_text(zhihu_data$question_detail)
# zhihu_data$ans <- clean_text(zhihu_data$ans)
# 
# zhihu_data$question_title[is.na(zhihu_data$question_title)] <- ''
# zhihu_data$question_detail[is.na(zhihu_data$question_detail)] <- ''
# zhihu_data$ans[is.na(zhihu_data$ans)] <- ''
# 
# 
# zhihu_data$question <- paste(zhihu_data$question_title, zhihu_data$question_detail)
# 
# View(zhihu_data)
# 
# document <- c(unique(zhihu_data$question),unique(zhihu_data$ans))
# 
# stop_word <- get_stop_word(document)
# 
# cutter = worker()
# with_stop_word <- cutter[document[100]]
# print(with_stop_word)
# without_stop_word <- filter_segment(with_stop_word, stop_word)
# print(without_stop_word)
