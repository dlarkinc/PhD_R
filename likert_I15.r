library(RMySQL)
library(likert)
library(ggplot2)

studyDb <- dbConnect(MySQL(), user='larkin', password='password', dbname='study_1_data')

query <- paste("SELECT answer FROM likert_answers where question_code = 'I15'")
rs = dbSendQuery(studyDb, query)
I15 <- dbFetch(rs)

answers <- data.frame(I15)
colnames(answers) <- c("I15")

levels = c("1", "2", "3", "4", "5")
levels_rev = c("5", "4", "3", "2", "1")
labels = c("Strongly Disagree", "Somewhat Disagree", "Neutral", "Somewhat Agree", "Strongly Agree")

answers$I15 = factor(answers$I15,
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
  ggtitle("Use of Gameplay Data")

data = as.data.frame(matrix(c(I15$answer),
                            nrow = 13,
                            ncol = 1))

apply(I15,2,sd)

dbDisconnect(studyDb)