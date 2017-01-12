library(shiny)

# global variable
num_observe_all_data <- data.frame()
text_topic_data <- data.frame()
similar_data <- data.frame()
similar_question_data <- data.frame()
cluster_data <- data.frame()
cluster_ans_tbl <- data.frame()


shinyServer(function(input, output) {
  
  # source each tab
  
  source('tabNumObserve.R', local=TRUE)
  source('tabTextPre.R', local=TRUE)
  source('tabTextTopic.R', local = TRUE)
  source('tabSenti.R', local = TRUE)
  source('tabSimilar.R', local = TRUE)
  source('tabCluster.R', local = TRUE)
  source('tabSVM.R', local = TRUE)
  
})
