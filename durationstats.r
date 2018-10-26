library(RMySQL)

studyDb <- dbConnect(MySQL(), user='larkin', password='password', dbname='data_for_cleaning')

query <- paste("SELECT distinct 
               l.letter as Participant, TIME_TO_SEC(TIMEDIFF(
               (SELECT timestamp FROM learner_interaction WHERE game_registration_id = li.game_registration_id AND key_ = 'graph_complex_rule'),
               (SELECT timestamp FROM learner_interaction WHERE game_registration_id = li.game_registration_id AND key_ = 'tutorial_start')
               )) as Duration
               FROM learner_interaction li, game_registration gr, learner l
               WHERE li.game_registration_id = gr.id
               AND gr.learner_id = l.id
               ORDER BY li.timestamp ASC")

rs = dbSendQuery(studyDb, query)
dbRows <- dbFetch(rs)

mean(dbRows$Duration)
median(dbRows$Duration)
sd(dbRows$Duration)

dbDisconnect(studyDb)