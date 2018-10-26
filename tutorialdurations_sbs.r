library(RMySQL)

studyDb <- dbConnect(MySQL(), user='larkin', password='password', dbname='data_for_cleaning')

query <- paste("
        SELECT Participant, 
               TIME_TO_SEC(TIMEDIFF(tutorial_teleport, tutorial_start)) AS teleport_duration,
               TIME_TO_SEC(TIMEDIFF(tutorial_abutton, tutorial_teleport)) AS abutton_duration,
               TIME_TO_SEC(TIMEDIFF(tutorial_gaze, tutorial_abutton)) AS gaze_duration,
               TIME_TO_SEC(TIMEDIFF(tutorial_select, tutorial_gaze)) AS select_duration,
               TIME_TO_SEC(TIMEDIFF(tutorial_connect, tutorial_select)) AS connect_duration,
               TIME_TO_SEC(TIMEDIFF(tutorial_grab, tutorial_connect)) AS grab_duration
          FROM (
                SELECT l.letter AS participant,
                       (SELECT timestamp FROM learner_interaction WHERE key_ = 'tutorial_start' AND game_registration_id = li.game_registration_id) AS tutorial_start,
                       (SELECT timestamp FROM learner_interaction WHERE key_ = 'tutorial_teleport' AND game_registration_id = li.game_registration_id) AS tutorial_teleport,
                       (SELECT timestamp FROM learner_interaction WHERE key_ = 'tutorial_gaze' AND game_registration_id = li.game_registration_id) AS tutorial_gaze,
                       (SELECT timestamp FROM learner_interaction WHERE key_ = 'tutorial_select' AND game_registration_id = li.game_registration_id) AS tutorial_select,
                       (SELECT timestamp FROM learner_interaction WHERE key_ = 'tutorial_connect' AND game_registration_id = li.game_registration_id) AS tutorial_connect,
                       (SELECT timestamp FROM learner_interaction WHERE key_ = 'tutorial_grab' AND game_registration_id = li.game_registration_id) AS tutorial_grab
                 FROM learner_interaction li, game_registration gr, learner l
                WHERE li.game_registration_id = gr.id
                  AND gr.learner_id = l.id
                  AND li.key_ = 'tutorial_start') times
         ORDER BY participant;")

rs = dbSendQuery(studyDb, query)
dbRows <- dbFetch(rs)

num_participants <- 19

data = t(matrix(c(dbRows$teleport_duration, dbRows$gaze_duration, dbRows$select_duration, dbRows$connect_duration, dbRows$grab_duration),
              nrow = num_participants,
              ncol = 5))

# Barchart of side-by-side total of exercise durations
barplot(data, names.arg = dbRows$Participant, beside=T, xlab = "Participant", ylab="Seconds", col=c("orange","darkgreen","lightblue", "gray", "maroon"), border="black", main = "Time to Carry Out Tutorial Task")
legend(50,230, legend=c("Teleport", "Gaze", "Select", "Connect", "Grab"), fill=c("orange","darkgreen","lightblue", "gray", "maroon"))

dbDisconnect(studyDb)