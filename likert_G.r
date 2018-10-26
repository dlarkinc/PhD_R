library(RMySQL)
library(likert)
library(ggplot2)
library(viridis)

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

answers <- data.frame(E1, E2, E3)
colnames(answers) <- c("E1", "E2", "E3")

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
result = likert(answers)

update_geom_defaults("bar", list(colour="white", size=0.15))
plot(result, ordered=FALSE, type="bar",
     plot.percents=FALSE,
     plot.percent.low=FALSE, 
     plot.percent.high=FALSE, 
     plot.percent.neutral=FALSE, 
     legend.position='right') + 
  ggtitle("Progression of Understanding & Formative Feedback") +
  scale_fill_viridis(discrete=TRUE) 

data = as.data.frame(matrix(c(E1$answer, E2$answer, E3$answer),
                nrow = 20,
                ncol = 3))

psych::alpha(data, check.keys = T)

dbDisconnect(studyDb)