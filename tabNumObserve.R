library(readr)
library(dplyr)
library(ggplot2)


# dataset <- read_csv(NULL)
# View(dataset)

output$num_observe_hist <- renderPlot({
  
  num_observe_all_data <<- all_data %>% filter(topic %in% input$num_observe_dataset)
  
  num_observe_all_data <<- num_observe_all_data %>%
    mutate(time_span = ans_time - question_time)
  
  all_hist <- ggplot(num_observe_all_data, aes(x = topic, fill = topic)) + 
    geom_bar() +
    # theme(axis.text.x = element_text(angle=90, hjust=0)) +
    geom_text(stat='count',aes(label=..count..),vjust=-0.5) + 
    ggtitle("各資料集的資料筆數") +
    theme(text = element_text(family= 'Arial Unicode MS'))
  
  all_hist

})



output$num_observe_time_span <- renderPlot({
  
  input$num_observe_dataset
  
  num_observe_time_span <- ggplot(num_observe_all_data, aes(x = log(time_span), y = ans_upvote_num)) + 
    geom_point() + 
    geom_smooth(method=lm) + 
    labs(title="Relationship between time_span \n and number of upvote", x="Time Span", y="Number of Upvote")
  
  num_observe_time_span
  
})


output$num_observe_time_span_color <- renderPlot({
  
  input$num_observe_dataset
    
  num_observe_time_span <- ggplot(num_observe_all_data, aes(x = log(time_span), y = ans_upvote_num, color = topic)) + 
    geom_point() + 
    geom_smooth(method=lm) + 
    labs(title="Relationship between time_span \n and number of upvote", x="Time Span", y="Number of Upvote")

  num_observe_time_span
  
  })


output$num_observe_author_upvote <- renderPlot({
  
  input$num_observe_dataset
  
  num_observe_author_upvote <- ggplot(num_observe_all_data, aes(x = author_upvote_num, y = ans_upvote_num)) + 
    geom_point() + 
    geom_smooth(method=lm) + 
    labs(title="Relationship between Author's Total Upvote Numbers \n and number of upvote", 
         x="Author's Total Upvote Numbers", y="Number of Upvote")
  
  num_observe_author_upvote
  
})

output$num_observe_author_upvote_color <- renderPlot({
  
  input$num_observe_dataset
  
  num_observe_author_upvote <- ggplot(num_observe_all_data, aes(x = author_upvote_num, y = ans_upvote_num, color = topic)) + 
    geom_point() + 
    geom_smooth(method=lm) + 
    labs(title="Relationship between Author's Total Upvote Numbers \n and number of upvote", 
         x="Author's Total Upvote Numbers", y="Number of Upvote")
  
  num_observe_author_upvote
  
})

output$num_observe_author_follower <- renderPlot({
  
  input$num_observe_dataset
  
  num_observe_author_follower <- ggplot(num_observe_all_data, aes(x = author_follower_num, y = ans_upvote_num)) + 
    geom_point() + 
    geom_smooth(method=lm) + 
    labs(title="Relationship between author_follower_num \n and number of upvote", 
         x="author_follower_num", y="Number of Upvote")
  
  num_observe_author_follower
  
})

output$num_observe_author_follower_color <- renderPlot({
  
  input$num_observe_dataset
  
  num_observe_author_follower <- ggplot(num_observe_all_data, aes(x = author_follower_num, y = ans_upvote_num, color = topic)) + 
    geom_point() + 
    geom_smooth(method=lm) + 
    labs(title="Relationship between author_follower_num \n and number of upvote", 
         x="author_follower_num", y="Number of Upvote")
  
  num_observe_author_follower
  
})

output$num_observe_author_followee <- renderPlot({
  
  input$num_observe_dataset
  
  num_observe_author_followee <- ggplot(num_observe_all_data, aes(x = author_followee_num, y = ans_upvote_num)) + 
    geom_point() + 
    geom_smooth(method=lm) + 
    labs(title="Relationship between author_followee_num \n and number of upvote", 
         x="author_followee_num", y="Number of Upvote")
  
  num_observe_author_followee
  
})

output$num_observe_author_followee_color <- renderPlot({
  
  input$num_observe_dataset
  
  num_observe_author_followee <- ggplot(num_observe_all_data, aes(x = author_followee_num, y = ans_upvote_num, color = topic)) + 
    geom_point() + 
    geom_smooth(method=lm) + 
    labs(title="Relationship between author_followee_num \n and number of upvote", 
         x="author_followee_num", y="Number of Upvote")
  
  num_observe_author_followee
  
})

output$num_observe_author_thank <- renderPlot({
  
  input$num_observe_dataset
  
  num_observe_author_thank <- ggplot(num_observe_all_data, aes(x = author_thank_num, y = ans_upvote_num)) + 
    geom_point() + 
    geom_smooth(method=lm) + 
    labs(title="Relationship between author_thank_num \n and number of upvote", 
         x="author_thank_num", y="Number of Upvote")
  
  num_observe_author_thank
  
})


output$num_observe_author_thank_color <- renderPlot({
  
  input$num_observe_dataset
  
  num_observe_author_thank <- ggplot(num_observe_all_data, aes(x = author_thank_num, y = ans_upvote_num, color = topic)) + 
    geom_point() + 
    geom_smooth(method=lm) + 
    labs(title="Relationship between author_thank_num \n and number of upvote", 
         x="author_thank_num", y="Number of Upvote")
  
  num_observe_author_thank
  
})

output$num_observe_author_question <- renderPlot({
  
  input$num_observe_dataset
  
  num_observe_author_question <- ggplot(num_observe_all_data, aes(x = author_question_num, y = ans_upvote_num)) + 
    geom_point() + 
    geom_smooth(method=lm) + 
    labs(title="Relationship between author_question_num \n and number of upvote", 
         x="author_question_num", y="Number of Upvote")
  
  num_observe_author_question
  
})

output$num_observe_author_question_color <- renderPlot({
  
  input$num_observe_dataset
  
  num_observe_author_question <- ggplot(num_observe_all_data, aes(x = author_question_num, y = ans_upvote_num, color = topic)) + 
    geom_point() + 
    geom_smooth(method=lm) + 
    labs(title="Relationship between author_question_num \n and number of upvote", 
         x="author_question_num", y="Number of Upvote")
  
  num_observe_author_question
  
})

output$num_observe_author_answer <- renderPlot({
  
  input$num_observe_dataset
  
  num_observe_author_answer <- ggplot(num_observe_all_data, aes(x = author_answer_num, y = ans_upvote_num)) + 
    geom_point() + 
    geom_smooth(method=lm) + 
    labs(title="Relationship between author_answer_num \n and number of upvote", 
         x="author_answer_num", y="Number of Upvote")
  
  num_observe_author_answer
  
})

output$num_observe_author_answer_color <- renderPlot({
  
  input$num_observe_dataset
  
  num_observe_author_answer <- ggplot(num_observe_all_data, aes(x = author_answer_num, y = ans_upvote_num, color = topic)) + 
    geom_point() + 
    geom_smooth(method=lm) + 
    labs(title="Relationship between author_answer_num \n and number of upvote", 
         x="author_answer_num", y="Number of Upvote")
  
  num_observe_author_answer
  
})

output$num_observe_author_post <- renderPlot({
  
  input$num_observe_dataset
  
  num_observe_author_post <- ggplot(num_observe_all_data, aes(x = author_post_num, y = ans_upvote_num)) + 
    geom_point() + 
    geom_smooth(method=lm) + 
    labs(title="Relationship between author_post_num \n and number of upvote", 
         x="author_post_num", y="Number of Upvote")
  
  num_observe_author_post
  
})

output$num_observe_author_post_color <- renderPlot({
  
  input$num_observe_dataset
  
  num_observe_author_post <- ggplot(num_observe_all_data, aes(x = author_post_num, y = ans_upvote_num, color = topic)) + 
    geom_point() + 
    geom_smooth(method=lm) + 
    labs(title="Relationship between author_post_num \n and number of upvote", 
         x="author_post_num", y="Number of Upvote")
  
  num_observe_author_post
  
})

output$num_observe_ans_collect <- renderPlot({
  
  input$num_observe_dataset
  
  num_observe_ans_collect <- ggplot(num_observe_all_data, aes(x = ans_collect_num, y = ans_upvote_num)) + 
    geom_point() + 
    geom_smooth(method=lm) + 
    labs(title="Relationship between ans_collect_num \n and number of upvote", 
         x="ans_collect_num", y="Number of Upvote")
  
  num_observe_ans_collect
  
})

output$num_observe_ans_collect_color <- renderPlot({
  
  input$num_observe_dataset
  
  num_observe_ans_collect <- ggplot(num_observe_all_data, aes(x = ans_collect_num, y = ans_upvote_num, color = topic)) + 
    geom_point() + 
    geom_smooth(method=lm) + 
    labs(title="Relationship between ans_collect_num \n and number of upvote", 
         x="ans_collect_num", y="Number of Upvote")
  
  num_observe_ans_collect
  
})

output$num_observe_ans_comment <- renderPlot({
  
  input$num_observe_dataset
  
  num_observe_ans_comment <- ggplot(num_observe_all_data, aes(x = ans_comment_num, y = ans_upvote_num)) + 
    geom_point() + 
    geom_smooth(method=lm) + 
    labs(title="Relationship between ans_comment_num \n and number of upvote", 
         x="ans_comment_num", y="Number of Upvote")
  
  num_observe_ans_comment
  
})

output$num_observe_ans_comment_color <- renderPlot({
  
  input$num_observe_dataset
  
  num_observe_ans_comment <- ggplot(num_observe_all_data, aes(x = ans_comment_num, y = ans_upvote_num, color = topic)) + 
    geom_point() + 
    geom_smooth(method=lm) + 
    labs(title="Relationship between ans_comment_num \n and number of upvote", 
         x="ans_comment_num", y="Number of Upvote")
  
  num_observe_ans_comment
  
})



