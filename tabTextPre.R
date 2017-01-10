
library(wordcloud)


# cutter = worker(dict = "www/jieba.dict.utf8", hmm = "www/hmm_model.utf8", user = "www/user.dict.utf8",
#                 idf = "www/idf.utf8", stop_word ="www/stop_words.utf8")
# keys = worker("keywords",dict = "www/jieba.dict.utf8", hmm = "www/hmm_model.utf8", user = "www/user.dict.utf8",
#               idf = "www/idf.utf8", stop_word ="www/stop_words.utf8", topn = 10)


output$text_pre_clean_text <- renderText({
  clean_text <- clean_text(input$text_pre_text)
  clean_text
})


output$text_pre_all_stop_word_cloud <- renderPlot({
  # all_stop_word_df <- as.data.frame(matrix(all_stop_word[1:144], ncol = 12, nrow = 12))
  # colnames(all_stop_word_df) <- NULL
  # all_stop_word_df
  
  par(family=('Arial Unicode MS'))
  text_pre_all_stop_word_cloud <- wordcloud(words = all_stop_word_df$word, freq = all_stop_word_df$count, min.freq = 1,
            max.words=200, random.order=FALSE, rot.per=0.35, 
            colors=brewer.pal(8, "Dark2"))
  text_pre_all_stop_word_cloud
})



output$text_pre_all_stop_word_df <- renderTable({
    all_stop_word_df[1:10,]
})



output$text_pre_filtered_text <- renderText({
  filtered_text <- filter_segment(seg_worker[clean_text(input$text_pre_text)], all_stop_word)
  filtered_text <- paste0(filtered_text, collapse = ' / ')
  filtered_text
})