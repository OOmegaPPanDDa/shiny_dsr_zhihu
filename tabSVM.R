
# load 已經 train 好的 SVM model
load('svm_model.rda')
load('svm_question_detail.rda')
load('svm_question_title.rda')


output$svm_question_title <- renderText({
  svm_question_title
  
})



output$svm_question_detail <- renderText({
  svm_question_detail
  
})




# 用 svm model predict 該回答者回答的分數
output$svm_ans_quality <- renderText({
  
  if(input$svm_text=='Input your answer!'){
    return('0')
  }
  
  svm_ans_text <- clean_text(input$svm_text)
  svm_nchar <- nchar(svm_ans_text)
  svm_seg_text <- seg_worker[svm_ans_text]
  svm_nword <- length(svm_seg_text)
  svm_nstop <- sapply(svm_seg_text, function(x) sum(is.element(x, all_stop_word)))
  svm_per_stop <- svm_nstop/svm_nword
  
  
  pos_result<-try(svm_pos <- sum(is.element(svm_seg_text,positive_dict)))
  if (class(pos_result) == "try-error") {
    return('0')}
  
  
  neg_result<-try(svm_neg <- sum(is.element(svm_seg_text,negative_dict)))
  if (class(neg_result) == "try-error") {
    return('0')}
  
  
  
  senti_result<-try(if((svm_pos+svm_neg)==0){
    svm_senti_score = 0.5
  }else{
    svm_senti_score = svm_pos/(svm_pos+svm_neg)
  })
  
  if (class(neg_result) == "try-error") {
    return('0 %')}
  
  
  
  
  
  svm_input <- data.frame(author_follower_num=c(input$svm1),
                          author_followee_num=c(input$svm2),
                          author_upvote_num=c(input$svm3),
                          author_thank_num=c(input$svm4),
                          author_answer_num=c(input$svm5),
                          author_question_num=c(input$svm6),
                          author_post_num=c(input$svm7),
                          n_char=c(svm_nchar),
                          n_word=c(svm_nword),
                          n_stop=c(svm_nstop),
                          per_stop=c(svm_per_stop),
                          senti_score=c(svm_senti_score)
                          )
  
  
  input$svm7
  
  svm_result <- try(pred <- predict(svm_model, svm_input, probability = TRUE))
  if (class(svm_result) == "try-error") {
    return('0')
  }else{
    quality <- attr(pred, "probabilities")[1,1]
    quality <- substring(as.character(quality*100),1,5)
    return(quality)
  }
  
  
  
})