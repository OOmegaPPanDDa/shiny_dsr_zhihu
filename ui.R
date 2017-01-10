library(shiny)
library(shinythemes)
source('read_data.R')




navbarPage( theme = shinytheme("spacelab"),
  #shinythemes::themeSelector(),
  HTML("DSR Team 10: 知乎: <a href='https://oomegappandda.shinyapps.io/shiny_dsr_zhihu/'>https://oomegappandda.shinyapps.io/shiny_dsr_zhihu/</a>"),
  
  tabPanel('Introduction',
           fluidPage(
             titlePanel(h1('介紹')),
             mainPanel(
               HTML("<br><hr><br>"),
               HTML('<center><img src="zhihu.jpeg" height=100% width=100%></center>'),
               HTML("<center><a href='https://www.zhihu.com'><h2>https://www.zhihu.com</h2></a></center>"),
               HTML("<br><hr><br>"),
               HTML("<center><h2>中國版的 Yahoo奇摩知識+</h2><center>"),
               HTML('<center><img src="zhihu_interface1.jpeg" height=100% width=100%></center>'),
               HTML("<br><hr><br>"),
               HTML("<center><h2>話題多元</h2><center>"),
               HTML('<center><img src="zhihu_topic.jpeg" height=100% width=100%></center>'),
               HTML("<br><hr><br>"),
               HTML("<center><h2>規模龐大、用戶眾多</h2><center>"),
               HTML('<center><img src="zhihu_interface2.jpeg" height=100% width=100%></center>'),
               HTML("<br>"),
               HTML('<center><img src="zhihu_interface3.jpeg" height=100% width=100%></center>'),
               HTML("<br><hr><br>"),
               HTML("<center><h2>文本豐富、回答專業</h2><center>"),
               HTML("<center><h3><問題></h3><center>"),
               HTML('<center><img src="question.jpeg" height=100% width=100%></center>'),
               HTML('<br>'),
               HTML("<center><h3><回答></h3><center>"),
               HTML('<img src="ans1.jpeg" height=50% width=50%><img src="ans2.jpeg" height=50% width=50%>'),
               HTML('<img src="ans3.jpeg" height=50% width=50%><img src="ans4.jpeg" height=50% width=50%>'),
               HTML('<br>')
             )
             
           )
  ),
  
  tabPanel('Data Collecting', 
           fluidPage(
             titlePanel(h1('資料蒐集')),
             mainPanel(
               HTML('<center>'),
               HTML("<font size='7' color='coral'><i>21 份 Dataset</i></font><br>"),
               HTML("<font size='7' color='coral'><i>1,300,000 筆 Data</i></font><br>"),
               HTML("<font size='7' color='coral'><i>17 種 Variable</i></font>"),
               HTML('</center>'),
               HTML("<br><hr><br>"),
               HTML("<center><h2>我們使用</h2><center>"),
               HTML("<center><h2>非知乎官方的 API</h2><center>"),
               HTML("<center><h2>自己撰寫</h2><center>"),
               HTML("<center><h2>Python 程式</h2><center>"),
               HTML("<center><h2>來爬資料</h2><center>"),
               HTML("<center><a href='https://github.com/7sDream/zhihu-oauth'><h2>7sDream zhihu-oauth</h2></a></center>"),
               HTML("<br><hr><br>"),
               HTML("<center><h2>爬取資料欄位</h2><center>"),
               HTML('<center><img src="colnames.jpeg" height=100% width=100%></center>'),
               HTML('<br>')
               )
           )
  ),
  
  tabPanel('Numeric Data Observing',
           fluidPage(
             titlePanel(h1('數據資料檢視')),
             sidebarLayout(
               sidebarPanel(
                 checkboxGroupInput("num_observe_dataset", label = h2("請選擇資料集"),
                                    choices = all_data_name,
                                    selected = all_data_name[1]
                                    ),
                 submitButton("更新頁面")
               ),
               mainPanel(
                 plotOutput("num_observe_hist"),
                 HTML("<br><hr><br>"),
                 plotOutput("num_observe_time_span"),
                 HTML("<br><hr><br>"),
                 plotOutput("num_observe_time_span_color"),
                 HTML("<br><hr><br>"),
                 plotOutput("num_observe_author_upvote"),
                 HTML("<br><hr><br>"),
                 plotOutput("num_observe_author_upvote_color"),
                 HTML("<br><hr><br>"),
                 plotOutput("num_observe_author_follower"),
                 HTML("<br><hr><br>"),
                 plotOutput("num_observe_author_follower_color"),
                 HTML("<br><hr><br>"),
                 plotOutput("num_observe_author_followee"),
                 HTML("<br><hr><br>"),
                 plotOutput("num_observe_author_followee_color"),
                 HTML("<br><hr><br>"),
                 plotOutput("num_observe_author_thank"),
                 HTML("<br><hr><br>"),
                 plotOutput("num_observe_author_thank_color"),
                 HTML("<br><hr><br>"),
                 plotOutput("num_observe_author_question"),
                 HTML("<br><hr><br>"),
                 plotOutput("num_observe_author_question_color"),
                 HTML("<br><hr><br>"),
                 plotOutput("num_observe_author_answer"),
                 HTML("<br><hr><br>"),
                 plotOutput("num_observe_author_answer_color"),
                 HTML("<br><hr><br>"),
                 plotOutput("num_observe_author_post"),
                 HTML("<br><hr><br>"),
                 plotOutput("num_observe_author_post_color"),
                 HTML("<br><hr><br>"),
                 plotOutput("num_observe_ans_collect"),
                 HTML("<br><hr><br>"),
                 plotOutput("num_observe_ans_collect_color"),
                 HTML("<br><hr><br>"),
                 plotOutput("num_observe_ans_comment"),
                 HTML("<br><hr><br>"),
                 plotOutput("num_observe_ans_comment_color"),
                 HTML("<br><hr><br>")
                 
               )
             )
           )
  ),
  
  tabPanel('Text Preprocessing',
         fluidPage(
           titlePanel(h1('文本前處理')),
           mainPanel(
             HTML("<br><hr><br>"),
             textAreaInput('text_pre_text', label='請輸入要清理的文本', value = "", width= '500px', height = '500px'),
             submitButton("送出文本"),
             HTML("<br><hr><br>"),
             HTML("<center><h2><font color='blue'>clean_text()</font></h2><center>"),
             HTML("<center><h6><font color='orange'>過濾</font></h6><center>"),
             HTML("<center><h6><font color='orange'>網頁標籤、url、</font></h6><center>"),
             HTML("<center><h6><font color='orange'>過多的連續標點符號與空白</font></h6><center>"),
             textOutput('text_pre_clean_text'),
             HTML("<br><hr><br>"),
             HTML("<center><h2><font color='blue'>Jieba 斷詞後濾掉 stop word 的結果</font></h2><center>"),
             textOutput('text_pre_filtered_text'),
             HTML("<br><hr><br>"),
             HTML("<center><h2><font color='blue'>get_stop_word()</font></h2><center>"),
             HTML("<center><h6><font color='orange'>取出所有文本中</font></h6><center>"),
             HTML("<center><h6><font color='orange'>df 值排名在 2.5‰ 以上的字詞</font></h6><center>"),
             plotOutput('text_pre_all_stop_word_cloud'),
             tableOutput('text_pre_all_stop_word_df'),
             HTML("..."),
             HTML("<br><hr><br>"),
             HTML("<center><h2><font color='blue'>範例文本</font></h2><center>"),
             helpText('(<i>個人調節</i>）②參加附近行業的沙龍和論壇培訓等，
                      跟他人接觸靠別人來提升自己。
                      （<i>圈子調節</i>）③如果你有團隊那就團隊之間互相討論開會什麼的
                      （我就有個合伙人，是我高中好基友，連哄帶騙好歹給拉過來了）
                      相互扶持相互努力，這樣快樂X2 痛苦÷2 真的非常非常感謝有朋友的一路相伴！
                      （<i>團隊調節</i>）<img src="https://pic4.zhimg.com/50/919cc17e9cf57882b9d47b73a8a9e2a7_b.jpg" data-rawwidth="357" data-rawheight="220" class="content_image" width="357"><br><br><br>濕貨說完了 該說重頭戲了
                      ：<b><i><u>乾貨</u></i></b><br>技巧和方法 思路（這玩意我自己都沒啥）
                      <br>這個是一個系統的科學，從頭開始。。。<br>
                      打字太多了 好累啊 休息休息 看看有沒有人跟著看吧······
                      <img src="https://pic3.zhimg.com/50/72a2133a1804c997387e4e9efd920cfa_b.jpg" data-rawwidth="96" data-rawheight="150" class="content_image" width="96"><br><br>
                      ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                      <br>貌似被群嘲了··· 來吧 讓濃白的雨點來的更猛烈點 <br><br>'),
             HTML("</center>")

         )
      )
  ),
  
  
  tabPanel('Text Topic', 
           fluidPage(
             titlePanel(h1('文本主題')),
             mainPanel(
               HTML("<center>"),
               HTML("<br><hr><br>"),
               selectInput('text_topic_topic', choices = all_data_name, label = '請選擇一個主題', multiple = FALSE),
               submitButton("更新頁面"),
               HTML("<br><hr><br>"),
               HTML("<center><h2><font color='blue'>主題文字雲</font></h2></center>"),
               plotOutput('text_topic_word_cloud'),
               HTML("<br><hr><br>"),
               HTML("<center><h2><font color='blue'>TF-IDF 主題關鍵詞</font></h2></center>"),
               plotOutput('text_topic_tf_idf'),
               HTML("<br><hr><br>"),
               HTML("<center><h2><font color='blue'>主題 LDA</font></h2></center>"),
               HTML("<center><h3><font color='blue'>Latent Dirichlet Allocation</font></h3></center>"),
               HTML("<center><h4><font color='purple'>Topics in Topics</font></h4></center>"),
               sliderInput('text_topic_lda_num', label = '請選擇 LDA 主題數', min = 5, max = 25, value = 10, step = 1),
               HTML("<center><h4><font color='purple'>視 LDA 結果，合併類似的主題後，再以圖表呈現</font></h4></center>"),
               HTML("<center><h4><font color='purple'>所以圖表上的主題數可能小於所選的主題數</font></h4></center>"),
               submitButton("更新 LDA"),
               plotOutput('text_topic_lda'),
               helpText('x 軸所代表的是各個主題，而顯示出來的代表文字為在該主題中頻率（重要性）最高的字詞'),
               HTML("<br><hr><br>"),
               uiOutput('text_topic_question_ui'),
               submitButton("看問題內容與熱門回答"),
               HTML("<br><hr><br>"),
               HTML("<center><h4><font color='blue'>問題內容</font></h4></center>"),
               textOutput('text_topic_question_detail'),
               HTML("<br><hr><br>"),
               HTML("<center><h4><font color='blue'>熱門回答</font></h4></center>"),
               tableOutput('text_topic_answer'),
               HTML("<br><hr><br>")
               
               )
    
    )
  ),
  
  tabPanel('Sentiment',
           fluidPage(
             titlePanel(h1('情感分析')),
             mainPanel(
              HTML("<br><hr><br>"),
              textAreaInput('senti_text', label='你正在想什麼呢？', value = "", width= '500px', height = '500px'),
              HTML("<center>"),
              submitButton("告訴我"),
              HTML("</center>"),
              HTML("<br>"),
              helpText('範例文本：'),
              helpText('藍瘦，香菇，本來今顛高高興興，泥為什莫要說這種話？藍瘦，香菇在這裡。第一翅為一個女孩使這麼香菇，藍瘦。泥為什摸要說射種話，丟我一個人晒這裡，香菇，藍瘦在這裡，香菇…'),
              HTML("<br><hr><br>"),
              HTML("<center>你現在的心情指標是"),
              HTML("<font size='7' color='coral'>"),
              textOutput('senti_score'),
              HTML("</font>"),
              imageOutput('senti_image'),
              helpText('總共有 12 隻皮卡丘喔～'),
              HTML("<br><hr><br></center>"),
              HTML("<center><h4><font color='blue'>不準啦ˋˊ</font></h4>"),
              HTML("<h4><font color='blue'>我要...</font></h4>"),
              helpText('請以空白相隔詞彙'),
              helpText('輸入範例：藍瘦 香菇'),
              textInput('senti_add_pos', label = '', value=''),
              submitButton("增加正向詞彙"),
              HTML("<br>"),
              textInput('senti_add_neg', label = '', value=''),
              submitButton("增加負向詞彙"),
              HTML("</center>"),
              HTML("<br><hr><br>"),
              HTML("<center><h2><font color='blue'>詞頻統計</font></h2></center>"),
              plotOutput("senti_hist"),
              HTML("<br><hr><br>"),
              HTML("<center><h2><font color='blue'>Positive WordCloud</font></h2></center>"),
              plotOutput('senti_pos_word_cloud'),
              HTML("<br><hr><br>"),
              HTML("<center><h2><font color='blue'>Negative WordCloud</font></h2></center>"),
              plotOutput('senti_neg_word_cloud'),
              HTML("<br><hr><br>"),
              HTML("<center><h3><font color='blue'>情感字典來源</font></h3></center>"),
              HTML("<center><a href='https://docs.google.com/forms/d/e/1FAIpQLSe20EyOE3bp9cKT0gF6R4DodTHOmriIGegkGYa03oHYejhi9g/viewform?c=0&w=1'>NTUSD</a></center>"),
              HTML("<center><a href='https://github.com/der3318/SentimentAnalyzer/tree/master/docs'>der3318</a></center>"),
              HTML("<center><a href='https://github.com/juliasilge/tidytext'>Tidytext bing</a></center>"),
              HTML("<br><hr><br>"),
              HTML("<center><h3><font color='blue'>PIKACHU 來源</font></h3></center>"),
              HTML("<center><a href='http://giphy.com/gifs/l41YlPWig6sceoHfi'>http://giphy.com/gifs/l41YlPWig6sceoHfi</a></center>"),
              HTML("<center><a href='https://i.redd.it/eapyp8asu0fx.gif'>https://i.redd.it/eapyp8asu0fx.gif</a></center>"),
              HTML("<center><a href='https://media.tenor.co/images/bfac1126632bc577493614f8bc1c5e13/tenor.gif'>https://media.tenor.co/images/bfac1126632bc577493614f8bc1c5e13/tenor.gif</a></center>"),
              HTML("<center><a href='http://25.media.tumblr.com/tumblr_m4wqgofzSa1rs1aa4o5_500.gif'>http://25.media.tumblr.com/tumblr_m4wqgofzSa1rs1aa4o5_500.gif</a></center>"),
              HTML("<center><a href='https://s-media-cache-ak0.pinimg.com/originals/d4/43/1d/d4431d293e50f9e833602759faea1e35.jpg'>https://s-media-cache-ak0.pinimg.com/originals/d4/43/1d/d4431d293e50f9e833602759faea1e35.jpg</a></center>"),
              HTML("<center><a href='http://i1248.photobucket.com/albums/hh484/dama_prk/tumblr_lwc2zzJTzl1qhy6c9o2_400.gif'>http://i1248.photobucket.com/albums/hh484/dama_prk/tumblr_lwc2zzJTzl1qhy6c9o2_400.gif</a></center>"),
              HTML("<center><a href='http://24.media.tumblr.com/3cbec42c49f925945cb58d1ab436c2b3/tumblr_mqm6yqvYMs1rq9h94o1_400.gif'>http://24.media.tumblr.com/3cbec42c49f925945cb58d1ab436c2b3/tumblr_mqm6yqvYMs1rq9h94o1_400.gif</a></center>"),
              HTML("<center><a href='http://orig08.deviantart.net/2f19/f/2011/116/b/5/easter_pikachu_by_ditto9-d3ez9rn.gif'>http://orig08.deviantart.net/2f19/f/2011/116/b/5/easter_pikachu_by_ditto9-d3ez9rn.gif</a></center>"),
              HTML("<center><a href='http://wifflegif.com/gifs/437847-floating-pikachu-gif'>http://wifflegif.com/gifs/437847-floating-pikachu-gif</a></center>"),
              HTML("<center><a href='https://dribbble.com/shots/1740890-GIF-Pikachu-Burger'>https://dribbble.com/shots/1740890-GIF-Pikachu-Burger</a></center>"),
              HTML("<center><a href='http://orig15.deviantart.net/00e6/f/2011/362/3/9/pikachu___dance_by_mnrart-d4kgxsd.gif'>http://orig15.deviantart.net/00e6/f/2011/362/3/9/pikachu___dance_by_mnrart-d4kgxsd.gif</a></center>"),
              HTML("<center><a href='http://rs376.pbsrc.com/albums/oo207/bad_moon_reasing/emoticon-gif/pikachu.gif~c200'>http://rs376.pbsrc.com/albums/oo207/bad_moon_reasing/emoticon-gif/pikachu.gif~c200</a></center>")
              
              
            )
              
              
              
              
           )
  ),
  
  tabPanel('Essay Similarity', 
           fluidPage(
             titlePanel(h1('文本相似度')),
             HTML("<br><hr><br>"),
             HTML("<i>如何計算文本相似度</i>？"),
             HTML("<center><h3><font color='purple'> >>> 餘弦相似性  !!!</font></h3></center>"),
             HTML('<center><img src="similarity.png" width = 80%></center>'),
             HTML("<center><h5><font size = 5 color='purple'> A = 問題 詞頻 </font></h3></center>"),
             HTML("<center><h5><font size = 5 color='purple'> B = 答案 tf_idf </font></h3></center>"),
             HTML("<center><br><hr><br>"),
             selectInput('similar_topic', choices = all_data_name, label = '請選擇一個主題', multiple = FALSE),
             submitButton("更換資料集"),
             HTML("<br><hr><br></center>"),
               fluidRow(
                 column(12,
                        HTML("<font color='purple'>"),
                        h2("以下是我們將 <問題詞頻> 與 <答案 tf_idf> 這兩串向量", align = 'center'),
                        h2("通過 cosine 所計算出來的相似度", align = 'center'),
                        HTML("</font>"),
                        HTML("<br><hr><br>"),
                        fluidRow(
                          column(5, align="center",
                            uiOutput('similar_question_ui'),
                            submitButton("看問題內容"),
                            HTML("<br><br>")
                          ),
                          column(5,  align="center",
                                 uiOutput('similar_ans_ui'),
                                 submitButton("看答案"),
                                 HTML("<br><br>")
                          ),
                          column(2, align="center",
                                 h3("相似度", align = "center"),
                                 HTML("<br><br>")
                          )
                                 
                        ),
                        fluidRow(
                          column(5, align="center",
                                 
                                 HTML("<br><hr><br>"),
                                 textOutput('similar_question_detail'),
                                 HTML("<br><br>")
                          ),
                          column(5,  align="center",
                                 
                                 HTML("<br><hr><br>"),
                                 textOutput('similar_ans_detail'),
                                 HTML("<br><br>")
                                 
                          ),
                          column(2, align="center",
                                 
                                 HTML("<br><hr><br>"),
                                 HTML("<font size='7' color='coral'>"),
                                 textOutput('similar_similarity'),
                                 HTML("</font>"),
                                 HTML("<br><br>")
                          )
                        )
                 ),
               
               HTML("<br><hr><br>")
             
           )
      )
),
  
  tabPanel('Clustering', 
           fluidPage(
             titlePanel(h1('文本分群')),
             mainPanel(
               HTML("<center><br><hr><br>"),
               selectInput('cluster_topic', choices = all_data_name, label = '請選擇一個主題', multiple = FALSE),
               submitButton("更換資料集"),
               HTML("<br><hr><br>"),
               uiOutput('cluster_question_ui'),
               submitButton("選擇問題"),
               HTML("<br><hr><br>"),
               sliderInput('cluster_num', label='選擇答案分群數', min=2, value=3, max=8),
               submitButton("開始分群"),
               HTML("<br><hr><br>"),
               HTML("<center><h4><font color='blue'>分群是將 Term Document Matrix</font></h4></center>"),
               HTML("<center><h4><font color='blue'>用 PCA 降階後再餵給 kmeans</font></h4></center>"),
               HTML("<center><h4><font color='blue'>下圖只有藉由 PC1 和 PC2 將分群結果部分展現</font></h4></center>"),
               plotOutput('cluster_pca_plot'),
               HTML("<br><hr><br>"),
               tableOutput('cluster_ans_table'),
               HTML("<br><hr><br></center>")
               
               
               
             )
             
             
             
    )
  ),

  # ('author_follower_num','author_followee_num','author_upvote_num','author_thank_num','author_answer_num','author_question_num','author_post_num',
  #'n_char','n_word','n_stop','per_stop','senti_score','quality')
  
  tabPanel('SVM',
           fluidPage(
           mainPanel(
             includeHTML("./final/zhihu_final.html"),
             HTML("<center><br><hr><br>"),
             textOutput('svm_question_title'),
             HTML("<hr>"),
             textOutput('svm_question_detail'),
             HTML("<hr></center>"),
             textAreaInput('svm_text', label='請輸入你的答案', value = "Input your answer!", width= '680px', height = '500px'),
             HTML("<center>"),
             numericInput('svm1',label='author_follower_num',value=0),
             numericInput('svm2',label='author_followee_num',value=0),
             numericInput('svm3',label='author_upvote_num',value=0),
             numericInput('svm4',label='author_thank_num',value=0),
             numericInput('svm5',label='author_answer_num',value=0),
             numericInput('svm6',label='author_question_num',value=0),
             numericInput('svm7',label='author_post_num',value=0),
             HTML("<br><hr><br>"),
             submitButton('看看我的回答水準'),
             HTML("<font size='7' color='coral'>"),
             textOutput('svm_ans_quality'),
             HTML("</font>"),
             HTML("<br><hr><br></center>")
             
           )
           )),
  
  #tabPanel('Team Member')
  

  tags$style(type="text/css",
             ".shiny-output-error { visibility: hidden; }",
             ".shiny-output-error:before { visibility: hidden; }"
)
)
