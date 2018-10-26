library(RMySQL)
library(likert)
library(ggplot2)

studyDb <- dbConnect(MySQL(), user='larkin', password='password', dbname='study_1_data')

query <- paste("SELECT answer FROM likert_answers where question_code = 'B1'")
rs = dbSendQuery(studyDb, query)
B1 <- dbFetch(rs)

query <- paste("SELECT answer FROM likert_answers where question_code = 'B2'")
rs = dbSendQuery(studyDb, query)
B2 <- dbFetch(rs)

query <- paste("SELECT answer FROM likert_answers where question_code = 'B3'")
rs = dbSendQuery(studyDb, query)
B3 <- dbFetch(rs)

query <- paste("SELECT answer FROM likert_answers where question_code = 'B4'")
rs = dbSendQuery(studyDb, query)
B4 <- dbFetch(rs)

query <- paste("SELECT answer FROM likert_answers where question_code = 'C1'")
rs = dbSendQuery(studyDb, query)
C1 <- dbFetch(rs)

query <- paste("SELECT answer FROM likert_answers where question_code = 'C2'")
rs = dbSendQuery(studyDb, query)
C2 <- dbFetch(rs)

query <- paste("SELECT answer FROM likert_answers where question_code = 'C3'")
rs = dbSendQuery(studyDb, query)
C3 <- dbFetch(rs)

query <- paste("SELECT answer FROM likert_answers where question_code = 'D1'")
rs = dbSendQuery(studyDb, query)
D1 <- dbFetch(rs)

query <- paste("SELECT answer FROM likert_answers where question_code = 'D2'")
rs = dbSendQuery(studyDb, query)
D2 <- dbFetch(rs)

answers <- data.frame(B1, B2, B3, B4, C1, C2, C3, D1, D2)
colnames(answers) <- c("B1", "B2", "B3", "B4", "C1", "C2", "C3", "D1", "D2")

levels = c("1", "2", "3", "4", "5")
levels_rev = c("5", "4", "3", "2", "1")
labels = c("Strongly Disagree", "Somewhat Disagree", "Neutral", "Somewhat Agree", "Strongly Agree")
answers$C1 = factor(answers$C1,
            levels = levels,
            labels = labels,
            ordered = TRUE)
answers$C2 = factor(answers$C2,
            levels = levels,
            labels = labels,
            ordered = TRUE)
answers$C3 = factor(answers$C3,
                    levels = levels,
                    labels = labels,
            ordered = TRUE)
answers$B1 = factor(answers$B1,
                    levels = levels,
                    labels = labels,
                    ordered = TRUE)
answers$B2 = factor(answers$B2,
                    levels = levels,
                    labels = labels,
                    ordered = TRUE)
answers$B3 = factor(answers$B3,
                    levels = levels,
                    labels = labels,
                    ordered = TRUE)
answers$B4 = factor(answers$B4,
                    levels = levels,
                    labels = labels,
                    ordered = TRUE)
answers$D1 = factor(answers$D1,
                    levels = levels,
                    labels = labels,
                    ordered = TRUE)
answers$D2 = factor(answers$D2,
                    levels = levels,
                    labels = labels,
                    ordered = TRUE)

result = likert(answers)
#colnames(result) <- c("Strongly Disagree", "Somewhat Disagree", "Neutral", "Somewhat Agree", "Strongly Agree")
update_geom_defaults("bar", list(colour="white", size=0.15))
plot(result, ordered=FALSE, type="bar",
     plot.percents=FALSE,
     plot.percent.low=FALSE, 
     plot.percent.high=FALSE, 
     plot.percent.neutral=FALSE, 
     legend.position='right') + 
  ggtitle("Perceived Effectiveness of the Graph Game") 

data = as.data.frame(matrix(c(B1$answer, B2$answer, B3$answer, B4$answer, C1$answer, C2$answer, C3$answer, D1$answer, D2$answer),
                nrow = 20,
                ncol = 9))

psych::alpha(data, check.keys = T)

dbDisconnect(studyDb)