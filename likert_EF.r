library(RMySQL)
library(likert)
library(ggplot2)

studyDb <- dbConnect(MySQL(), user='larkin', password='password', dbname='study_1_data')

query <- paste("SELECT answer FROM likert_answers where question_code = 'E1'")
rs = dbSendQuery(studyDb, query)
E1 <- dbFetch(rs)

query <- paste("SELECT answer FROM likert_answers where question_code = 'E2'")
rs = dbSendQuery(studyDb, query)
E2 <- dbFetch(rs)

query <- paste("SELECT answer FROM likert_answers where question_code = 'E3'")
rs = dbSendQuery(studyDb, query)
E3 <- dbFetch(rs)

query <- paste("SELECT answer FROM likert_answers where question_code = 'E4'")
rs = dbSendQuery(studyDb, query)
E4 <- dbFetch(rs)

query <- paste("SELECT answer FROM likert_answers where question_code = 'F1'")
rs = dbSendQuery(studyDb, query)
F1 <- dbFetch(rs)

query <- paste("SELECT answer FROM likert_answers where question_code = 'F2'")
rs = dbSendQuery(studyDb, query)
F2 <- dbFetch(rs)

query <- paste("SELECT answer FROM likert_answers where question_code = 'F3'")
rs = dbSendQuery(studyDb, query)
F3 <- dbFetch(rs)

query <- paste("SELECT answer FROM likert_answers where question_code = 'F4'")
rs = dbSendQuery(studyDb, query)
F4 <- dbFetch(rs)

query <- paste("SELECT answer FROM likert_answers where question_code = 'F5'")
rs = dbSendQuery(studyDb, query)
F5 <- dbFetch(rs)

query <- paste("SELECT answer FROM likert_answers where question_code = 'F6'")
rs = dbSendQuery(studyDb, query)
F6 <- dbFetch(rs)

query <- paste("SELECT answer FROM likert_answers where question_code = 'F7'")
rs = dbSendQuery(studyDb, query)
F7 <- dbFetch(rs)

query <- paste("SELECT answer FROM likert_answers where question_code = 'F8'")
rs = dbSendQuery(studyDb, query)
F8 <- dbFetch(rs)

query <- paste("SELECT answer FROM likert_answers where question_code = 'F9'")
rs = dbSendQuery(studyDb, query)
F9 <- dbFetch(rs)

answers <- data.frame(E1, E2, E3, E4, F1, F2, F3, F4, F5, F6, F7, F8, F9)
colnames(answers) <- c("E1", "E2", "E3", "E4", "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9")

levels = c("1", "2", "3", "4", "5")
levels_rev = c("5", "4", "3", "2", "1")
labels = c("Strongly Disagree", "Somewhat Disagree", "Neutral", "Somewhat Agree", "Strongly Agree")

answers$E1 = factor(answers$E1,
                    levels = levels,
                    labels = labels,
                    ordered = TRUE)
answers$E2 = factor(answers$E2,
                    levels = levels,
                    labels = labels,
                    ordered = TRUE)
answers$E3 = factor(answers$E3,
                    levels = levels,
                    labels = labels,
                    ordered = TRUE)
answers$E4 = factor(answers$E4,
                    levels = levels,
                    labels = labels,
                    ordered = TRUE)
answers$F1 = factor(answers$F1,
                    levels = levels,
                    labels = labels,
                    ordered = TRUE)
answers$F2 = factor(answers$F2,
                    levels = levels,
                    labels = labels,
                    ordered = TRUE)
answers$F3 = factor(answers$F3,
                    levels = levels,
                    labels = labels,
                    ordered = TRUE)
answers$F4 = factor(answers$F4,
                    levels = levels,
                    labels = labels,
                    ordered = TRUE)
answers$F5 = factor(answers$F5,
                    levels = levels,
                    labels = labels,
                    ordered = TRUE)
answers$F6 = factor(answers$F6,
                    levels = levels,
                    labels = labels,
                    ordered = TRUE)
answers$F7 = factor(answers$F7,
                    levels = levels,
                    labels = labels,
                    ordered = TRUE)
answers$F8 = factor(answers$F8,
                    levels = levels,
                    labels = labels,
                    ordered = TRUE)
result = likert(answers)
answers$F9 = factor(answers$F9,
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
  ggtitle("Progression of Understanding & Formative Feedback")

data = as.data.frame(matrix(c(E1$answer, E2$answer, E3$answer, E4$answer, F1$answer, F2$answer, F3$answer, F4$answer, F5$answer, F6$answer, F7$answer, F8$answer, F9$answer),
                nrow = 20,
                ncol = 13))

psych::alpha(data, check.keys = T)

dbDisconnect(studyDb)