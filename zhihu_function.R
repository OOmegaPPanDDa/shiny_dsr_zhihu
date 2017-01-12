library(rJava)
library(tm)
library(SnowballC)
library(slam)
library(XML)
library(RCurl)
library(Matrix)


library(fpc)
library(cluster)
library(ggplot2)
library(scatterplot3d)



if (!require('tmcn')) {
  devtools::install_github("OOmegaPPanDDa/tmcn")
}
library(tmcn)

if (!require('Rwordseg')) {
  devtools::install_github("OOmegaPPanDDa/Rwordseg")
}
library(Rwordseg)











# 排除未被按讚答案
number_filter <- function(df) {
  return(subset(df, df$ans_upvote_num != 0))
}







# clean_text and omit na
text_filter <- function(df) {
  
  # Remove symbols 
  df$question_title <- clean_text(df$question_title)
  df$question_detail <- clean_text(df$question_detail)
  df$ans <- clean_text(df$ans)
  
  
  df$question_title[is.na(df$question_title)] <- ''
  df$question_detail[is.na(df$question_detail)] <- ''
  df$ans[is.na(df$ans)] <- ''
  # Remove empty rows or NA
  df[df==""] <- NA
  return(df %>% na.omit())
}










# Similarity
space_tokenizer <- function(x){
  unlist(strsplit(as.character(x[[1]]),'[[:space:]]+'))
}


tf_idf_score <- function(df){
  # df <- text_filter(df)
  # stop_words <- stop_word_vector(df)
  df$ans_seg <- sapply(df$ans, function(x) paste(seg_worker[x], collapse = ' '))
  
  # Transform the entire answer column into a corpus
  d_corpus <- VCorpus(VectorSource(as.vector(df$ans_seg)))
  
  # Remove punctuation
  d_corpus <- tm_map(d_corpus, removePunctuation)
  
  # Remove numbers
  d_corpus <- tm_map(d_corpus, removeNumbers)
  #inspect(d_corpus)
  #print(toTrad(stopwordsCN()))
  
  #Remove stopwords
  d_corpus <- tm_map(d_corpus, removeWords, toTrad(stopwordsCN()))
  d_corpus <- tm_map(d_corpus, removeWords, all_stop_word)
  
  # Remove whitespace
  d_corpus = tm_map(d_corpus, stripWhitespace)
  
  # Transform back into vector
  d_corpus <- Corpus(VectorSource(d_corpus))
  
  # Use control list with space tokenizer
  control_list=list(wordLengths=c(2,Inf),tokenize=space_tokenizer)
  tdm <- TermDocumentMatrix(Corpus(VectorSource(d_corpus)), control = control_list)
  
  # Tf-idf computation
  tf <- apply(tdm, 2, sum) # term frequency
  idf <- function(word_doc){ log2( (length(word_doc)) / (nnzero(word_doc)+1)) }
  idf <- apply(tdm, 1, idf)
  dic_tfidf <- as.matrix(tdm)
  for(i in 1:nrow(tdm)){
    for(j in 1:ncol(tdm)){
      dic_tfidf[i,j] <- (dic_tfidf[i,j] / tf[j]) * idf[i]
    }
  }
  
  # Dealing with query
  q = paste(df$question_title[1], df$question_detail[1])
  q_seg <- filter_segment(seg_worker[q], all_stop_word)
  query_frame <- as.data.frame(table(q_seg))
  query_frame <- query_frame %>% na.omit()
  
  # Get short doc matrix
  all_term <- rownames(dic_tfidf)
  loc <- which(is.element(all_term, query_frame$q_seg))
  s_tdm <- dic_tfidf[loc,]
  query_frame <- query_frame[is.element(query_frame$q_seg, rownames(s_tdm)),]
  s_tdm[is.na(s_tdm)]=0
  
  # Result : cos similarity ranking
  cos_tdm <- function(x, y){ x%*%y / sqrt(x%*%x * y%*%y) }
  #print(s_tdm)
  #print(query_frame)
  doc_cos <- apply(s_tdm, 2, cos_tdm, y = query_frame$Freq)
  doc_cos[is.nan(doc_cos)] <- 0
  return(doc_cos)
  
}




# Clustering

# ans 是一在同一問題下的所有資料
# ans 輸入進去後會回傳增加  km1, km2, km3, pc1, p2, pc3 的 dataframe
get_cluster_feature <- function(ans, cluster_num){
  
  #cutter <- worker()
  kmIterMax = 100000000
  
  
  ans$ans <- clean_text(ans$ans)
  stop_word <- get_stop_word(ans$ans)
  ans$aid <- seq(1:nrow(ans))
  
  ans_word <- ans
  data_number <- nrow(ans_word)
  
  ans_word$ans_seg <- sapply(ans_word$ans, function(x) paste(filter_segment(segment(x,seg_worker),stop_word),collapse = ' '))
  
  
  # Transform the entire answer column into a corpus
  d_corpus <- VCorpus(VectorSource(as.vector(ans_word$ans_seg)))
  
  # Remove punctuation
  d_corpus <- tm_map(d_corpus, removePunctuation)
  
  # Remove numbers
  d_corpus <- tm_map(d_corpus, removeNumbers)
  #inspect(d_corpus)
  #print(toTrad(stopwordsCN()))
  
  #Remove stopwords
  d_corpus <- tm_map(d_corpus, removeWords, toTrad(stopwordsCN()))
  d_corpus <- tm_map(d_corpus, removeWords, all_stop_word)
  
  # Remove whitespace
  d_corpus = tm_map(d_corpus, stripWhitespace)
  
  # Transform back into vector
  d_corpus <- Corpus(VectorSource(d_corpus))
  
  # Use control list with space tokenizer
  control_list=list(wordLengths=c(2,Inf),tokenize=space_tokenizer)
  tdm <- TermDocumentMatrix(Corpus(VectorSource(d_corpus)), control = control_list)
  
  # # Tf-idf computation
  # tf <- apply(tdm, 2, sum) # term frequency
  # idf <- function(word_doc){ log2( (length(word_doc)) / (nnzero(word_doc)+1)) }
  # idf <- apply(tdm, 1, idf)
  # ans_km_input <- as.matrix(tdm)
  # for(i in 1:nrow(tdm)){
  #   for(j in 1:ncol(tdm)){
  #     ans_km_input[i,j] <- (ans_km_input[i,j] / tf[j]) * idf[i]
  #   }
  # }
  
  
  ans_km_input <- as.matrix(tdm)

  ans_km_input <- as.data.frame(ans_km_input)
  ans_km_input[is.na(ans_km_input)] <- 0

  # ans_km_input <- ans_km_input[rowSums(ans_km_input)> 0.2,]
  ans_km_input <- ans_km_input[rowSums(ans_km_input)> 10,]
  ans_km_input <- ans_km_input[rowSums(ans_km_input)< 80,]

  #ans_km_input <- and_tfidf*1000


  ans_km_input <- t(ans_km_input)
  
  
  
  
  
  
  
  t_ans_kmeans <- kmeans(t(ans_km_input), cluster_num, iter.max = kmIterMax, nstart = 100, algorithm = 'Forgy')
  t_ans_kmeans$cluster <- as.factor(t_ans_kmeans$cluster)
  #View(t_ans_kmeans$centers)
  
  # plotcluster(t(ans_km_input), t_ans_kmeans$cluster)
  # clusplot(t(ans_km_input), t_ans_kmeans$cluster, color=TRUE, shade=TRUE, labels=2, lines=0)
  
  ans$km1 <- t_ans_kmeans$centers[1,]
  ans$km2 <- t_ans_kmeans$centers[2,]
  ans$km3 <- t_ans_kmeans$centers[3,]
  
  
  
  
  
  ans_kmeans <- kmeans(ans_km_input, cluster_num, iter.max = kmIterMax, nstart = 100, algorithm = 'Forgy')
  ans_kmeans$cluster <- as.factor(ans_kmeans$cluster)
  #View(ans_kmeans$centers)
  print(plot(ans_kmeans$centers))
  
  ans_km <- plotcluster(ans_km_input, ans_kmeans$cluster)
  # clusplot(ans_km_input, ans_kmeans$cluster, color=TRUE, shade=TRUE, labels=2, lines=0)
  
  
  ans_pca <- prcomp(ans_km_input,
                    center = TRUE, # standarization
                    scale. = FALSE) 
  
  ans_rotated <- ans_pca$x %>% # data projected in pca space
    as.data.frame()
  
  # 查看 ans_kmeans 是否與 PCA 互相對照
  ans_km_vs_pca <- (ggplot(ans_rotated, aes(PC1, PC2, color = ans_kmeans$cluster)) + geom_point())
  
  # ans_km_vs_pca_3d <- with(ans_rotated, {
  #   scatterplot3d(PC1,    # x axis
  #                 PC2,    # y axis
  #                 PC3,    # z axis
  #                 color = ans_kmeans$cluster,
  #                 main="3-D Scatterplot")
  # })
  
  
  # ans_km_vs_pca_3d <- scatterplot3d(x=ans_rotated$PC1, y=ans_rotated$PC2, z=ans_rotated$PC3,
  #                                   color = ans_kmeans$cluster, main="3-D Scatterplot")
  
  
  ans_PCACluster <- kmeans(ans_rotated[, 1:2], cluster_num, iter.max = kmIterMax, nstart = 100, algorithm = 'Forgy') # run kmeans model
  ans_PCACluster$cluster <- as.factor(ans_PCACluster$cluster)
  #View(ans_PCACluster$centers)
  
  # PCA 自己分群後的結果
  ans_pca <- (ggplot(ans_rotated, aes(PC1, PC2, color = ans_PCACluster$cluster)) + geom_point())
  
  # ans_pca_3d <- with(ans_rotated, {
  #   scatterplot3d(PC1,    # x axis
  #                 PC2,    # y axis
  #                 PC3,    # z axis
  #                 color = ans_PCACluster$cluster,
  #                 main="3-D Scatterplot")
  # })
  
  # ans_pca_3d <- scatterplot3d(x=ans_rotated$PC1, y=ans_rotated$PC2, z=ans_rotated$PC3,
  #                             color = ans_PCACluster$cluster, main="3-D Scatterplot")
  
  
  ans$pc1 <- ans_rotated$PC1
  ans$pc2 <- ans_rotated$PC2
  ans$pc3 <- ans_rotated$PC3
  
  return(list(ans = ans, 
              #ans_km = ans_km, 
              ans_km_vs_pca = ans_km_vs_pca, 
              #ans_km_vs_pca_3d = ans_km_vs_pca_3d, 
              ans_pca = ans_pca,
              #ans_pca_3d = ans_pca_3d
              ans_pca_cluster_label = ans_PCACluster$cluster
              ))
}









