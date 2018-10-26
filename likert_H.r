library(RMySQL)
library(likert)
library(ggplot2)

studyDb <- dbConnect(MySQL(), user='larkin', password='password', dbname='study_1_data')

query <- paste("SELECT answer FROM likert_answers where question_code = 'H2'")
rs = dbSendQuery(studyDb, query)
H2 <- dbFetch(rs)

query <- paste("SELECT answer FROM likert_answers where question_code = 'H3'")
rs = dbSendQuery(studyDb, query)
H3 <- dbFetch(rs)

query <- paste("SELECT answer FROM likert_answers where question_code = 'H4'")
rs = dbSendQuery(studyDb, query)
H4 <- dbFetch(rs)
#H4[,c("answer")] = H4[,c("answer")]

query <- paste("SELECT answer FROM likert_answers where question_code = 'H5'")
rs = dbSendQuery(studyDb, query)
H5 <- dbFetch(rs)

query <- paste("SELECT answer FROM likert_answers where question_code = 'H6'")
rs = dbSendQuery(studyDb, query)
H6 <- dbFetch(rs)
#H6[,c("answer")] = H6[,c("answer")]

answers <- data.frame(H2, H3, H4, H5, H6)
colnames(answers) <- c("H2", "H3", "H4", "H5", "H6")

levels = c("1", "2", "3", "4", "5")
levels_rev = c("5", "4", "3", "2", "1")
labels = c("Strongly Disagree", "Somewhat Disagree", "Neutral", "Somewhat Agree", "Strongly Agree")

answers$H2 = factor(answers$H2,
                    levels = levels,
                    labels = labels,
                    ordered = TRUE)
answers$H3 = factor(answers$H3,
                    levels = levels,
                    labels = labels,
                    ordered = TRUE)
answers$H4 = factor(answers$H4,
                    levels = levels,
                    labels = labels,
                    ordered = TRUE)
answers$H5 = factor(answers$H5,
                    levels = levels,
                    labels = labels,
                    ordered = TRUE)
answers$H6 = factor(answers$H6,
                    levels = levels,
                    labels = labels,
                    ordered = TRUE)

result = likert(answers)

update_geom_defaults("bar", list(colour="white", size=0.15))
plot(result, ordered=FALSE, type="bar",
     plot.percents=FALSE,
     plot.percent.low=FALSE, 
     plot.percent.high=FALSE, 
     plot.percent.neutral=FALSE, 
     legend.position='right') + 
  ggtitle("Virtual Reality")

data = as.data.frame(matrix(c(H2$answer, H3$answer, H4$answer, H5$answer, H6$answer),
                nrow = 13,
                ncol = 5))

psych::alpha(data, check.keys=T)

dbDisconnect(studyDb)