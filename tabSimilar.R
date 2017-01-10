output$similar_question_ui <- renderUI({
  
  input$similar_topic
  
  similar_data <<- all_data %>% filter(topic == input$similar_topic)
  
  selectInput('similar_question', choices = unique(similar_data$question_title), selected = NULL, label = '請選擇一個問題', multiple = FALSE)
  
  
})


output$similar_ans_ui <- renderUI({
  
  input$similar_topic
  input$similar_question

  selectInput('similar_ans', choices = 1:length(similar_data$ans), label = '請選擇一個答案', selected = NULL, multiple = FALSE)
  
})



output$similar_question_detail <- renderText({
  
  input$similar_topic
  
  similar_question_data <<- subset(similar_data, question_title == input$similar_question)
  
  question_detail <- subset(similar_data, question_title == input$similar_question)$question_detail[1]
  question_detail <- clean_text(question_detail)
  question_detail
})




output$similar_ans_detail <- renderText({
  
  input$similar_topic
  input$similar_question
  
  ans_detail <- subset(similar_data, question_title == input$similar_question)
  ans_detail <- ans_detail$ans[as.integer(input$similar_ans)]
  ans_detail <- clean_text(ans_detail)
  ans_detail
})

output$similar_similarity <- renderText({
  input$similar_topic
  input$similar_question
  input$similar_ans
  
  similar_question_data
  similar_question_data_filtered <- text_filter(similar_question_data)
  similar_result <- try(similar_question_data_filtered$tf_idf_score <- tf_idf_score(similar_question_data_filtered),silent = T)
  
  # View(similar_question_data_filtered)
  
  if (class(similar_result) == "try-error") {
    return('0 %')
  }else{
    sim_score <- similar_question_data_filtered$tf_idf_score[as.integer(input$similar_ans)]
    sim_score <- paste(substring(as.character(sim_score*100),1,5), '%', collapse = '')
    return(sim_score)
  }
})








