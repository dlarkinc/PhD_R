library(RMySQL)
library(likert)
library(ggplot2)
library(viridis)

studyDb <- dbConnect(MySQL(), user='larkin', password='password', dbname='study_1_data')

query <- paste("SELECT answer FROM likert_answers where question_code = 'I1'")
rs = dbSendQuery(studyDb, query)
I01 <- dbFetch(rs)

query <- paste("SELECT answer FROM likert_answers where question_code = 'I2'")
rs = dbSendQuery(studyDb, query)
I02 <- dbFetch(rs)

query <- paste("SELECT answer FROM likert_answers where question_code = 'I3'")
rs = dbSendQuery(studyDb, query)
I03 <- dbFetch(rs)

query <- paste("SELECT answer FROM likert_answers where question_code = 'I4'")
rs = dbSendQuery(studyDb, query)
I04 <- dbFetch(rs)

query <- paste("SELECT answer FROM likert_answers where question_code = 'I5'")
rs = dbSendQuery(studyDb, query)
I05 <- dbFetch(rs)

query <- paste("SELECT answer FROM likert_answers where question_code = 'I6'")
rs = dbSendQuery(studyDb, query)
I06 <- dbFetch(rs)

query <- paste("SELECT answer FROM likert_answers where question_code = 'I7'")
rs = dbSendQuery(studyDb, query)
I07 <- dbFetch(rs)

query <- paste("SELECT answer FROM likert_answers where question_code = 'I8'")
rs = dbSendQuery(studyDb, query)
I08 <- dbFetch(rs)

query <- paste("SELECT answer FROM likert_answers where question_code = 'I9'")
rs = dbSendQuery(studyDb, query)
I09 <- dbFetch(rs)

query <- paste("SELECT answer FROM likert_answers where question_code = 'I10'")
rs = dbSendQuery(studyDb, query)
I10 <- dbFetch(rs)

query <- paste("SELECT answer FROM likert_answers where question_code = 'I11'")
rs = dbSendQuery(studyDb, query)
I11 <- dbFetch(rs)

query <- paste("SELECT answer FROM likert_answers where question_code = 'I12'")
rs = dbSendQuery(studyDb, query)
I12 <- dbFetch(rs)

query <- paste("SELECT answer FROM likert_answers where question_code = 'I13'")
rs = dbSendQuery(studyDb, query)
I13 <- dbFetch(rs)

query <- paste("SELECT answer FROM likert_answers where question_code = 'I14'")
rs = dbSendQuery(studyDb, query)
I14 <- dbFetch(rs)

query <- paste("SELECT answer FROM likert_answers where question_code = 'I15'")
rs = dbSendQuery(studyDb, query)
I15 <- dbFetch(rs)

answers <- data.frame(I01, I02, I03,I04, I05, I06,I07, I08, I09,I10, I11, I12, I13, I14)
colnames(answers) <- c("I01", "I02", "I03", "I04", "I05", "I06","I07", "I08", "I09","I10", "I11", "I12", "I13", "I14")

levels = c("1", "2", "3", "4", "5")
labels = c("Strongly Disagree", "Somewhat Disagree", "Neutral", "Somewhat Agree", "Strongly Agree")

answers$I01 = factor(answers$I01,
                    levels = levels,
                    labels = labels,
                    ordered = TRUE)
answers$I02 = factor(answers$I02,
                    levels = levels,
                    labels = labels,
                    ordered = TRUE)
answers$I03 = factor(answers$I03,
                    levels = levels,
                    labels = labels,
                    ordered = TRUE)
answers$I04 = factor(answers$I04,
                    levels = levels,
                    labels = labels,
                    ordered = TRUE)
answers$I05 = factor(answers$I05,
                    levels = levels,
                    labels = labels,
                    ordered = TRUE)
answers$I06 = factor(answers$I06,
                    levels = levels,
                    labels = labels,
                    ordered = TRUE)
answers$I07 = factor(answers$I07,
                    levels = levels,
                    labels = labels,
                    ordered = TRUE)
answers$I08 = factor(answers$I08,
                    levels = levels,
                    labels = labels,
                    ordered = TRUE)
answers$I09 = factor(answers$I09,
                    levels = levels,
                    labels = labels,
                    ordered = TRUE)
answers$I10 = factor(answers$I10,
                    levels = levels,
                    labels = labels,
                    ordered = TRUE)
answers$I11 = factor(answers$I11,
                    levels = levels,
                    labels = labels,
                    ordered = TRUE)
answers$I12 = factor(answers$I12,
                    levels = levels,
                    labels = labels,
                    ordered = TRUE)
answers$I13 = factor(answers$I13,
                     levels = levels,
                     labels = labels,
                     ordered = TRUE)
answers$I14 = factor(answers$I14,
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
     include.mean=TRUE,
     legend.position='right') + 
  ggtitle("Universal Design for Learning")

data = as.data.frame(matrix(c(I01$answer, I02$answer, I03$answer,I04$answer, I05$answer, I06$answer,
                              I07$answer, I08$answer, I09$answer,I10$answer, I11$answer, I12$answer, 
                              I13$answer, I14$answer),
                nrow = 20,
                ncol = 14))

psych::alpha(data, check.keys = T)

dbDisconnect(studyDb)