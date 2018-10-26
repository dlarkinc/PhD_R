library(RMySQL)

studyDb <- dbConnect(MySQL(), user='larkin', password='password', dbname='data_for_cleaning')

query <- paste("SELECT distinct 
                  l.letter as Participant, TIME_TO_SEC(TIMEDIFF(
                  (SELECT timestamp FROM learner_interaction WHERE game_registration_id = li.game_registration_id AND key_ = 'real_world_example_1'),
                  (SELECT timestamp FROM learner_interaction WHERE game_registration_id = li.game_registration_id AND key_ = 'level2_begin')
                   )) as Duration1,
                  TIME_TO_SEC(TIMEDIFF(
                  (SELECT timestamp FROM learner_interaction WHERE game_registration_id = li.game_registration_id AND key_ = 'real_world_example_2'),
                  (SELECT timestamp FROM learner_interaction WHERE game_registration_id = li.game_registration_id AND key_ = 'real_world_example_1')
                   )) as Duration2
                FROM learner_interaction li, game_registration gr, learner l
                WHERE li.game_registration_id = gr.id
                AND gr.learner_id = l.id
                ORDER BY li.timestamp ASC")

rs = dbSendQuery(studyDb, query)
dbRows <- dbFetch(rs)

num_participants <- 19

data = t(matrix(c(dbRows$Duration1, dbRows$Duration2),
              nrow = num_participants,
              ncol = 2))

#plot a grouped bar chart
barplot(data, names.arg = dbRows$Participant, xlab = "Participant", ylab = "seconds", col=c("orange","darkgreen"), border="black", main = "Examples Participant Durations")
legend(8,570, legend=c("Social", "NLP"), fill=c("orange","darkgreen"))

# Calculate mean, media and standard deviation
mean(dbRows$Duration)
median(dbRows$Duration)
sd(dbRows$Duration)

dbDisconnect(studyDb)