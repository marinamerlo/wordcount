setwd("C:/Users/6837258/Desktop")
df <-read.csv("COMMENTS_sample.csv", sep=";", encoding="latin1", stringsAsFactors=FALSE)

#função pra contar todas as palavras
wordcount <- function(str) {
  sapply(gregexpr("\\b\\W+\\b", str, perl=TRUE), function(x) sum(x>0) ) + 1 
}

#criando variáveis para o total de palavras
df$post_wordcount_total <- wordcount(df$Post.title)
df$comment_wordcount_total <- wordcount(df$Comment_text)

#pacote de Text Mining         
install.packages('tm')
library(tm)
         
#criando um corpus para tirar stopwords - comentários
comments <- Corpus(VectorSource(df$Comment_text))
#removendo stopwords, acentos e espaços
comments  <- tm_map(comments , removeWords, stopwords("pt")) 
comments  <- tm_map(comments , removePunctuation) 
comments <- tm_map(comments, stripWhitespace)
#voltando para o formato de banco de dados
dtm <- DocumentTermMatrix(comments)
#incluindo a contagem total no banco de dados original
df$comment_wordcount_clean <-rowSums(as.matrix(dtm))


#criando um corpus para tirar stopwords - post
post <- Corpus(VectorSource(df$Post.title))
#removendo stopwords, acentos e espaços
post  <- tm_map(post , removeWords, stopwords("pt")) 
post <- tm_map(post, stripWhitespace)
#voltando para o formato de banco de dados
dtm <- DocumentTermMatrix(post)
#incluindo a contagem total no banco de dados original
df$post_wordcount_clean <-rowSums(as.matrix(dtm))
