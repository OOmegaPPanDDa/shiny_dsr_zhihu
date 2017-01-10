
library(wordcloud)
library(dplyr)


output$senti_score <- renderText({
  pos_words <- positive_dict
  neg_words <- negative_dict
  senti_score <- 50 
  pos_words <- unique(c(pos_words, unlist(strsplit(input$senti_add_pos,' '))))
  neg_words <- unique(c(neg_words, unlist(strsplit(input$senti_add_neg,' '))))
  seg_vec <- filter_segment(seg_worker[input$senti_text], all_stop_word)
  pos_count <- sum(is.element(seg_vec, pos_words))
  neg_count <- sum(is.element(seg_vec, neg_words))
  senti_score <- pos_count/(pos_count+neg_count)
  senti_score <- as.integer(senti_score*100)
  if(is.na(senti_score)){
    senti_score = 50
  }
  as.character(senti_score)
})



output$senti_image <- renderImage({
  
  
  input$senti_text
  input$senti_add_pos
  input$senti_add_neg
  
  pos_words <- positive_dict
  neg_words <- negative_dict
  senti_score <- 50 
  pos_words <- unique(c(pos_words, unlist(strsplit(input$senti_add_pos,' '))))
  neg_words <- unique(c(neg_words, unlist(strsplit(input$senti_add_neg,' '))))
  seg_vec <- filter_segment(seg_worker[input$senti_text], all_stop_word)
  pos_count <- sum(is.element(seg_vec, pos_words))
  neg_count <- sum(is.element(seg_vec, neg_words))
  senti_score <- pos_count/(pos_count+neg_count)
  senti_score <- as.integer(senti_score*100)
  if(is.na(senti_score)){
    senti_score = 50
  }
  
  if(senti_score==100){
    emotion_image = './www/pika100.gif'
    
  }else if(senti_score>=90){
    emotion_image = './www/pika90.gif'
  
  }else if(senti_score>=80){
    emotion_image = './www/pika80.gif'
    
  }else if(senti_score>=70){
    emotion_image = './www/pika70.gif'
    
  }else if(senti_score>=60){
    emotion_image = './www/pika60.gif'
    
  }else if(senti_score>=50){
    emotion_image = './www/pika50.gif'
    
  }else if(senti_score>=40){
    emotion_image = './www/pika40.gif'
    
  }else if(senti_score>=30){
    emotion_image = './www/pika30.gif'
    
  }else if(senti_score>=20){
    emotion_image = './www/pika20.gif'
    
  }else if(senti_score>=10){
    emotion_image = './www/pika10.gif'
    
  }else if(senti_score>0){
    emotion_image = './www/pika0.gif'
    
  }else if(senti_score==0){
    emotion_image = './www/pikaDown.gif'
    
  }
  
  list(src = emotion_image,
       contentType = 'image/gif',
       width = 400,
       height = 400,
       alt = "Your sentiment")
  
}, deleteFile = FALSE)





output$senti_hist <- renderPlot({
  
  input$senti_text
  input$senti_add_pos
  input$senti_add_neg
  
  pos_words <- positive_dict
  neg_words <- negative_dict
  senti_score <- 50 
  pos_words <- unique(c(pos_words, unlist(strsplit(input$senti_add_pos,' '))))
  neg_words <- unique(c(neg_words, unlist(strsplit(input$senti_add_neg,' '))))
  seg_vec <- filter_segment(seg_worker[input$senti_text], all_stop_word)
  pos_count <- sum(is.element(seg_vec, pos_words))
  neg_count <- sum(is.element(seg_vec, neg_words))
  
  senti_df <- data.frame(sentiment=c('正向','負向'), count=c(pos_count,neg_count))
  senti_bar <- ggplot(senti_df,aes(x=sentiment,y=count)) +
    geom_bar(stat='identity',fill = c('lightcoral','lightblue')) + 
    geom_text(aes(label=count),vjust=-0.5) +
    theme(text = element_text(size = 20, family= 'Arial Unicode MS'))
  
  
  senti_bar
  
})



output$senti_pos_word_cloud <- renderPlot({
  
  
  input$senti_text
  input$senti_add_pos
  input$senti_add_neg
  
  if(input$senti_text!=''){
  
  pos_words <- positive_dict
  neg_words <- negative_dict
  
  pos_words <- as.vector(unique(c(pos_words, unlist(strsplit(input$senti_add_pos,' ')))))
  neg_words <- as.vector(unique(c(neg_words, unlist(strsplit(input$senti_add_neg,' ')))))
  seg_vec <- as.vector(filter_segment(seg_worker[input$senti_text], all_stop_word))
  
  
  text_df <- data.frame(word=seg_vec)
  sentiment_df <- data.frame(word = c(pos_words,neg_words), sentiment = as.vector(c(rep('pos',length(pos_words)),rep('neg',length(neg_words)))))
  text_df <- text_df %>%
    group_by(word) %>%
    mutate(freq = n()) %>%
    ungroup()
  
  text_df <- merge(x = text_df, y = sentiment_df, by = 'word')
  # text_df <- unique(text_df)
  
  if(!is.null(text_df[text_df$sentiment=='pos',])){


    par(family=('Arial Unicode MS'))
  
    senti_cloud <- wordcloud(words = text_df$word[text_df$sentiment=='pos'], freq = text_df$freq[text_df$sentiment=='pos'], min.freq = 1,
                                       max.words=200, random.order=FALSE, rot.per=0.35,
                                       colors=brewer.pal(8, "Dark2"))
  
    senti_cloud
  }
  }
  
})




output$senti_neg_word_cloud <- renderPlot({
  
  
  input$senti_text
  input$senti_add_pos
  input$senti_add_neg
  
  if(input$senti_text!=''){
  
  pos_words <- positive_dict
  neg_words <- negative_dict
  
  pos_words <- as.vector(unique(c(pos_words, unlist(strsplit(input$senti_add_pos,' ')))))
  neg_words <- as.vector(unique(c(neg_words, unlist(strsplit(input$senti_add_neg,' ')))))
  seg_vec <- as.vector(filter_segment(seg_worker[input$senti_text], all_stop_word))
  
  
  
  
  text_df <- data.frame(word=seg_vec)
  sentiment_df <- data.frame(word = c(pos_words,neg_words), sentiment = as.vector(c(rep('pos',length(pos_words)),rep('neg',length(neg_words)))))
  text_df <- text_df %>%
    group_by(word) %>%
    mutate(freq = n()) %>%
    ungroup()
  
  text_df <- merge(x = text_df, y = sentiment_df, by = 'word')
  # text_df <- unique(text_df)
  
  
  if(!is.null(text_df[text_df$sentiment=='neg',])){
  
  par(family=('Arial Unicode MS'))
  
  senti_cloud <- wordcloud(words = text_df$word[text_df$sentiment=='neg'], freq = text_df$freq[text_df$sentiment=='neg'], min.freq = 1,
                           max.words=200, random.order=FALSE, rot.per=0.35,
                           colors=brewer.pal(8, "Dark2"))
  
  senti_cloud
  
  }
  }
  
})