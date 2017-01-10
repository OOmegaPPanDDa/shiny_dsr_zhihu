source('zhihu_preprocessing.R')

library(wordcloud)
library(dplyr)
library(RTextTools)
library(topicmodels)
library(tidytext)


output$text_topic_word_cloud <- renderPlot({
  text_topic_data <<- all_data %>% filter(topic == input$text_topic_topic)
  
  # lighten the burden for server
  if(length(text_topic_data)>2000){
    text_topic_data <- sample(text_topic_data, 2000)
  }
  
  text_topic_data$question_title[is.na(text_topic_data$question_title)] <- ''
  text_topic_data$question_detail[is.na(text_topic_data$question_detail)] <- ''
  text_topic_data$ans[is.na(text_topic_data$ans)] <- ''
  
  text_topic_data$question <- paste(text_topic_data$question_title, text_topic_data$question_detail)
  text_topic_question <- clean_text(text_topic_data$question)
  text_topic_ans <- clean_text(text_topic_data$ans)
  
  text_topic_document <- unique(c(text_topic_question, text_topic_ans))
  text_topic_document_seg <- filter_segment(seg_worker[text_topic_document], all_stop_word)
  text_topic_word_df <- as.data.frame(table(text_topic_document_seg))
  colnames(text_topic_word_df) <- c('word','count')
  
  par(family=('Arial Unicode MS'))
  
  text_topic_word_cloud <- wordcloud(words = text_topic_word_df$word, freq = text_topic_word_df$count, min.freq = 1,
                                            max.words=200, random.order=FALSE, rot.per=0.35, 
                                            colors=brewer.pal(8, "Dark2"))
  
  text_topic_word_cloud
  
})




output$text_topic_question_ui <- renderUI({
  input$text_topic_topic
  
  selectInput('text_topic_question', choices = unique(text_topic_data$question_title), label = '請選擇一個問題', multiple = FALSE)
})


output$text_topic_question_detail <- renderText({
  
  input$text_topic_topic
  
  question_detail <- subset(text_topic_data, question_title == input$text_topic_question)$question_detail[1]
  question_detail <- clean_text(question_detail)
  question_detail
})


output$text_topic_answer <- renderTable({
  
  input$text_topic_topic
  
  question <- subset(text_topic_data, question_title == input$text_topic_question)
  ans_df <- question %>% 
    select(ans, ans_upvote_num) %>%
    arrange(desc(ans_upvote_num))
  
  ans_df$ans <- sapply(ans_df$ans, function(x) clean_text(x))
  colnames(ans_df) <- c('Ans','Upvote')
  head(ans_df)
})

output$text_topic_lda <- renderPlot({
  
  input$text_topic_topic
  
  topic_amount = input$text_topic_lda_num
  
  ans_text <- unique(text_topic_data$ans)
  ans_text <- unique(clean_text(ans_text))
  
  
  # lighten the burden for server
  if(length(ans_text)>500){
    ans_text <- sample(ans_text, 500)
  }
  
  
  
  
  ans_text <- sapply(ans_text, function(x) paste(filter_segment(seg_worker[x], all_stop_word), collapse = ' '))
  ans_matrix <- create_matrix(ans_text)
  rowTotals <- apply(ans_matrix , 1, sum)
  ans_matrix <- ans_matrix[rowTotals> 0, ]
  lda = LDA(ans_matrix, topic_amount)
  
  terms = terms(lda)
  #num_terms = paste(1:topic_amount, terms(lda))
  
  topics = topics(lda)
  lda_tb <- table(topics)
  
  names(lda_tb) <- terms
  
  #names(lda_tb) <- num_terms
  
  lda_frame<-as.data.frame(lda_tb)
  colnames(lda_frame) <- c('Topic','Documents_Related_to_The_Topic')
  
  lda_frame$Documents_Related_to_The_Topic <- sapply(lda_frame$Topic, function(x) sum(lda_frame[lda_frame$Topic == x,]$Documents_Related_to_The_Topic) )
  lda_frame <- unique(lda_frame) %>% arrange(desc(Documents_Related_to_The_Topic))
  
  lda_frame$Topic <- factor(lda_frame$Topic,levels = lda_frame$Topic)
  
  
  par(family=('Arial Unicode MS'))
  
  lda_plot <- ggplot(lda_frame, aes(x=Topic,y=Documents_Related_to_The_Topic)) + 
    geom_bar(stat='identity',fill='deepskyblue') + 
    theme(text = element_text(family= 'Arial Unicode MS')) + 
    theme(axis.text.x = element_text(angle=90, vjust=1)) +
    geom_text(aes(label=Documents_Related_to_The_Topic),vjust=-0.5)
  
  lda_plot
  
})



output$text_topic_tf_idf <- renderPlot({
  
  input$text_topic_topic
  
  data <- text_topic_data
  
  data <- unique(data) %>%  mutate(id = 1:nrow(unique(data))) 
  
  data$ans <- clean_text(data$ans)
  data$ans_seg = sapply(data$ans, function(x) paste(filter_segment(seg_worker[x], all_stop_word), collapse = '\n'))
  
  # term count 存在 data$n
  data_words <- unique(data) %>%
    unnest_tokens(word, ans_seg, token = 'lines') %>%
    count(id, word, sort = TRUE) %>%
    ungroup()
  
  data_words <- na.omit(data_words)
  data_words$id <- as.factor(data_words$id)
  
  # tf-idf
  data_words <- data_words %>%
    bind_tf_idf(word, id, n) %>%
    arrange(desc(tf_idf)) %>%
    mutate(word = factor(word, levels = rev(unique(word))))
  
  
  data_words <- data_words %>% arrange(id)
  #View(data_words[data_words$tf >= 1,])
  
  ggplot(data_words %>% 
           top_n(15),
         aes(x = word, y = tf_idf)) +
    geom_bar(aes(alpha = tf_idf), 
             stat="identity", 
             fill = "coral") +
    coord_flip() +
    #scale_y_continuous(limits = c(0, 0.002)) +
    labs(x = NULL, y = "tf-idf", title = 'TF-IDF Keywords') +
    scale_alpha_continuous(range = c(0.6, 1), guide = FALSE) + 
    theme(text = element_text(size = 20, family= 'Arial Unicode MS'))
  
  
  
})


