library(RMySQL)
library(likert)

studyDb <- dbConnect(MySQL(), user='larkin', password='password', dbname='study_1_data')

query <- paste("SELECT answer FROM study_1_data.likert_answers where question_code = 'B1'")
rs = dbSendQuery(studyDb, query)
B1 <- dbFetch(rs)

query <- paste("SELECT answer FROM study_1_data.likert_answers where question_code = 'B2'")
rs = dbSendQuery(studyDb, query)
B2 <- dbFetch(rs)

query <- paste("SELECT answer FROM study_1_data.likert_answers where question_code = 'B3'")
rs = dbSendQuery(studyDb, query)
B3 <- dbFetch(rs)

query <- paste("SELECT answer FROM study_1_data.likert_answers where question_code = 'B4'")
rs = dbSendQuery(studyDb, query)
B4 <- dbFetch(rs)

answers <- data.frame(B1, B2, B3, B4)
colnames(answers) <- c("B1", "B2", "B3", "B4")

answers$B1 = factor(answers$B1,
            levels = c("1", "2", "3", "4", "5"),
            ordered = TRUE)
answers$B2 = factor(answers$B2,
            levels = c("1", "2", "3", "4", "5"),
            ordered = TRUE)
answers$B3 = factor(answers$B3,
            levels = c("1", "2", "3", "4", "5"),
            ordered = TRUE)
answers$B4 = factor(answers$B4,
            levels = c("5", "4", "3", "2", "1"),
            ordered = TRUE)

result = likert(answers)

plot(result, type="bar")

data = as.data.frame(matrix(c(B1$answer, B2$answer, B3$answer),
                            nrow = 20,
                            ncol = 3))

psych::alpha(data)

dbDisconnect(studyDb)