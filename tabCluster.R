output$cluster_question_ui <- renderUI({
  
  input$cluster_topic
  
  cluster_data <<- all_data %>% 
    filter(topic == input$cluster_topic) %>%
    group_by(question_title) %>%
    mutate(ans_count = n()) %>%
    ungroup %>%
    filter(ans_count>450*to_light)
  
  selectInput('cluster_question', choices = unique(cluster_data$question_title), selected = NULL, label = '請選擇一個問題', multiple = FALSE)
  
  
})




output$cluster_pca_plot <- renderPlot({
  
  cluster_ans <- subset(cluster_data, question_title == input$cluster_question)
  cluster_ans$ans <- clean_text(cluster_ans$ans)
  
  cluster_out <- get_cluster_feature(cluster_ans, input$cluster_num)
  
  cluster_ans$cluster_label <- cluster_out$ans_pca_cluster_label
  
  cluster_ans_tbl <<- cluster_ans
  
  cluster_out$ans_pca
  
})




output$cluster_ans_table <- renderTable({
  
  
  input$cluster_num
  input$cluster_question
  
  
  # cluster_ans$cluster <- rep(as.integer(0),nrow(cluster_ans))
  # 
  # cluster_ans[,c('ans','cluster')]
  
  
  a_tbl <- as.data.frame(cluster_ans_tbl[,c('ans','cluster_label','ans_upvote_num')])
  a_tbl <- a_tbl %>% arrange(cluster_label, ans_upvote_num)
  a_tbl$`#` <- 1:nrow(a_tbl)
  a_tbl[,c(4,1,2,3)]
  
})


