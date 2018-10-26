library(RMySQL)
library(ggplot2)

studyDb <- dbConnect(MySQL(), user='larkin', password='password', dbname='data_for_cleaning')

tutorial_task1 = "connect"
tutorial_task2 = "grab"

query <- paste0("
        SELECT Participant, 
               TIME_TO_SEC(TIMEDIFF(tutorial_", tutorial_task2, ", tutorial_", tutorial_task1, ")) AS duration
          FROM (
                SELECT l.letter AS participant,
                       (SELECT timestamp FROM learner_interaction WHERE key_ = 'tutorial_", tutorial_task1, "' AND game_registration_id = li.game_registration_id) AS tutorial_", tutorial_task1, ",
                       (SELECT timestamp FROM learner_interaction WHERE key_ = 'tutorial_", tutorial_task2, "' AND game_registration_id = li.game_registration_id) AS tutorial_", tutorial_task2, "
                 FROM learner_interaction li, game_registration gr, learner l
                WHERE li.game_registration_id = gr.id
                  AND gr.learner_id = l.id
                  AND li.key_ = 'tutorial_start') times
         ORDER BY participant;")

rs = dbSendQuery(studyDb, query)
dbRows <- dbFetch(rs)

#Stats
lowerq = quantile(dbRows$duration)[2]
upperq = quantile(dbRows$duration)[4]
iqr = IQR(dbRows$duration)
mild.threshold.upper = (iqr*.5) + upperq
mild.threshold.lower = lowerq - (iqr*.5)

ggplot(data=dbRows, aes(x=Participant,y=duration, fill=duration*-1)) +
  ggtitle(paste0(tutorial_task2, "durations with interquartile range (green area) and inner ")) + 
  geom_bar(stat="identity") +
  annotate("rect", xmin=0, xmax=Inf, ymin=lowerq, ymax=upperq, alpha=0.3, fill="green") +
  annotate("rect", xmin=0, xmax=Inf, ymin=mild.threshold.lower, ymax=mild.threshold.upper, alpha=0.2, fill="red")

dbDisconnect(studyDb)