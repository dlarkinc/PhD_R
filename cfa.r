library(lavaan)

studyDb <- dbConnect(MySQL(), user='larkin', password='password', dbname='study_1_data')

query <- paste("SELECT answer FROM likert_answers where question_code = 'A2'")
rs = dbSendQuery(studyDb, query)
A2 <- dbFetch(rs)

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
B4[,c("answer")] = 6 - B4[,c("answer")]

query <- paste("SELECT answer FROM likert_answers where question_code = 'C1'")
rs = dbSendQuery(studyDb, query)
C1 <- dbFetch(rs)

query <- paste("SELECT answer FROM likert_answers where question_code = 'C2'")
rs = dbSendQuery(studyDb, query)
C2 <- dbFetch(rs)

query <- paste("SELECT answer FROM likert_answers where question_code = 'C3'")
rs = dbSendQuery(studyDb, query)
C3 <- dbFetch(rs)
C3[,c("answer")] = 6 - C3[,c("answer")]

query <- paste("SELECT answer FROM likert_answers where question_code = 'D1'")
rs = dbSendQuery(studyDb, query)
D1 <- dbFetch(rs)

query <- paste("SELECT answer FROM likert_answers where question_code = 'D2'")
rs = dbSendQuery(studyDb, query)
D2 <- dbFetch(rs)
D2[,c("answer")] = 6 - D2[,c("answer")]

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
E4[,c("answer")] = 6 - E4[,c("answer")]

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
F4[,c("answer")] = 6 - F4[,c("answer")]

query <- paste("SELECT answer FROM likert_answers where question_code = 'F5'")
rs = dbSendQuery(studyDb, query)
F5 <- dbFetch(rs)
F5[,c("answer")] = 6 - F5[,c("answer")]

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

query <- paste("SELECT answer FROM likert_answers where question_code = 'I1'")
rs = dbSendQuery(studyDb, query)
I1 <- dbFetch(rs)

query <- paste("SELECT answer FROM likert_answers where question_code = 'I2'")
rs = dbSendQuery(studyDb, query)
I2 <- dbFetch(rs)

query <- paste("SELECT answer FROM likert_answers where question_code = 'I3'")
rs = dbSendQuery(studyDb, query)
I3 <- dbFetch(rs)

query <- paste("SELECT answer FROM likert_answers where question_code = 'I4'")
rs = dbSendQuery(studyDb, query)
I4 <- dbFetch(rs)
I4[,c("answer")] = 6 - I4[,c("answer")]

query <- paste("SELECT answer FROM likert_answers where question_code = 'I5'")
rs = dbSendQuery(studyDb, query)
I5 <- dbFetch(rs)

query <- paste("SELECT answer FROM likert_answers where question_code = 'I6'")
rs = dbSendQuery(studyDb, query)
I6 <- dbFetch(rs)

query <- paste("SELECT answer FROM likert_answers where question_code = 'I7'")
rs = dbSendQuery(studyDb, query)
I7 <- dbFetch(rs)
I7[,c("answer")] = 6 - I7[,c("answer")]

query <- paste("SELECT answer FROM likert_answers where question_code = 'I8'")
rs = dbSendQuery(studyDb, query)
I8 <- dbFetch(rs)

query <- paste("SELECT answer FROM likert_answers where question_code = 'I9'")
rs = dbSendQuery(studyDb, query)
I9 <- dbFetch(rs)

query <- paste("SELECT answer FROM likert_answers where question_code = 'I10'")
rs = dbSendQuery(studyDb, query)
I10 <- dbFetch(rs)
I10[,c("answer")] = 6 - I10[,c("answer")]

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
I14[,c("answer")] = 6 - I14[,c("answer")]

data = as.data.frame(matrix(c(
  B1$answer, B2$answer, B3$answer, B4$answer, C1$answer, 
  C2$answer, C3$answer, D1$answer, D2$answer, E1$answer, 
  E2$answer, E3$answer, E4$answer, F1$answer, F2$answer, 
  F3$answer, F4$answer, F5$answer, F6$answer, F7$answer, 
  F8$answer, F9$answer,
  I1$answer, I2$answer, I3$answer, I4$answer, I5$answer,
  I6$answer, I7$answer, I8$answer, I9$answer, I10$answer,
  I11$answer, I12$answer, I13$answer, I14$answer),
  nrow = 20,
  ncol = 36))

# 3-factor Model for effectiveness 
Effectiveness.model <- ' learning =~ V1 + V2 + V3 + V4 
              motivation =~ V5 + V6 + V7
              efficiency =~ V8 + V9 '
#              feedback =~ V10 + V11 + V12 + V13 + V14 + V15 + V16 + V17 + V18 + V19 + V20 + V21 + V22
#              universality =~ V23 + V24 + V25 + V26 + V27 + V28 + V29 + V30 + V31 + V32 + V33 + V34 + V35 + V36 '

fit <- cfa(Effectiveness.model, data=data)
summary(fit, fit.measures=TRUE)

# 2-factor model for feedback
Feedback.model <- '  progression_of_learning =~ V10 + V11 + V12 + V13 
               formative_feedback =~ V14 + V15 + V16 + V17 + V18 + V19 + V20 + V21 + V22 '
#              universality =~ V23 + V24 + V25 + V26 + V27 + V28 + V29 + V30 + V31 + V32 + V33 + V34 + V35 + V36 '

fit <- cfa(Feedback.model, data=data)
summary(fit, fit.measures=TRUE)
