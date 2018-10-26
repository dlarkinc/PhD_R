library(RMySQL)

studyDb <- dbConnect(MySQL(), user='larkin', password='password', dbname='data_for_cleaning')

query <- paste("SELECT distinct 
               l.letter as Participant, TIME_TO_SEC(TIMEDIFF(
               (SELECT timestamp FROM learner_interaction WHERE game_registration_id = li.game_registration_id AND key_ = 'real_world_example_1'),
               (SELECT timestamp FROM learner_interaction WHERE game_registration_id = li.game_registration_id AND key_ = 'level2_begin')))
                +               
                TIME_TO_SEC(TIMEDIFF(
               (SELECT timestamp FROM learner_interaction WHERE game_registration_id = li.game_registration_id AND key_ = 'real_world_example_2'),
               (SELECT timestamp FROM learner_interaction WHERE game_registration_id = li.game_registration_id AND key_ = 'real_world_example_1')
               )) as Durations,
               (SELECT value FROM learner_interaction WHERE game_registration_id = li.game_registration_id AND key_ = 'real_world_example_1_teleports')
                +
               (SELECT value FROM learner_interaction WHERE game_registration_id = li.game_registration_id AND key_ = 'real_world_example_1_pickups')
                +
               (SELECT value FROM learner_interaction WHERE game_registration_id = li.game_registration_id AND key_ = 'real_world_example_2_teleports')
                +
               (SELECT value FROM learner_interaction WHERE game_registration_id = li.game_registration_id AND key_ = 'real_world_example_2_pickups')
                AS Engagements
               FROM learner_interaction li, game_registration gr, learner l
               WHERE li.game_registration_id = gr.id
               AND gr.learner_id = l.id
               AND li.timestamp >= '2018-05-10 14:36:47'
               ORDER BY li.timestamp ASC")

rs = dbSendQuery(studyDb, query)
dbRows <- dbFetch(rs)

num_participants <- 12

data = t(matrix(c(dbRows$Durations, dbRows$Engagements*9.75),
              nrow = num_participants,
              ncol = 2))

# Barchart of side-by-side total durations and engagements
barplot(data, names.arg = dbRows$Participant, beside=T, xlab = "Participant", col=c("orange","darkgreen"), border="black", angle=c(135,15), density=seq(30,20))#, main = "Examples Engagement")
legend(1,570, legend=c("Total Duration", "No. Interactions x 9.75"), fill=c("orange","darkgreen"), angle=c(135,15), density=seq(30,20))

# Calculate statistics for durations and engagements
mean(dbRows$Durations)
median(dbRows$Durations)
sd(dbRows$Durations)
mean(dbRows$Engagements)
median(dbRows$Engagements)
sd(dbRows$Engagements)

dbDisconnect(studyDb)