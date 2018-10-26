library(RMySQL)
library(ggplot2)

studyDb <- dbConnect(MySQL(), user='larkin', password='password', dbname='data_for_cleaning')

query <- paste("
        SELECT task,
	   TIME_TO_SEC(TIMEDIFF(task2, task1)) AS duration
               FROM (
               SELECT 'teleport' as task,
               (SELECT timestamp FROM learner_interaction WHERE key_ = 'tutorial_start' AND game_registration_id = li.game_registration_id) AS task1,
               (SELECT timestamp FROM learner_interaction WHERE key_ = 'tutorial_teleport' AND game_registration_id = li.game_registration_id) AS task2
               FROM learner_interaction li, game_registration gr, learner l
               WHERE li.game_registration_id = gr.id
               AND gr.learner_id = l.id
               AND li.key_ = 'tutorial_start') times
               UNION ALL
               SELECT task,
               TIME_TO_SEC(TIMEDIFF(task2, task1)) AS duration
               FROM (
               SELECT 'gaze' as task,
               (SELECT timestamp FROM learner_interaction WHERE key_ = 'tutorial_abutton' AND game_registration_id = li.game_registration_id) AS task1,
               (SELECT timestamp FROM learner_interaction WHERE key_ = 'tutorial_gaze' AND game_registration_id = li.game_registration_id) AS task2
               FROM learner_interaction li, game_registration gr, learner l
               WHERE li.game_registration_id = gr.id
               AND gr.learner_id = l.id
               AND li.key_ = 'tutorial_start') times
               UNION ALL
               SELECT task,
               TIME_TO_SEC(TIMEDIFF(task2, task1)) AS duration
               FROM (
               SELECT 'select' as task,
               (SELECT timestamp FROM learner_interaction WHERE key_ = 'tutorial_gaze' AND game_registration_id = li.game_registration_id) AS task1,
               (SELECT timestamp FROM learner_interaction WHERE key_ = 'tutorial_select' AND game_registration_id = li.game_registration_id) AS task2
               FROM learner_interaction li, game_registration gr, learner l
               WHERE li.game_registration_id = gr.id
               AND gr.learner_id = l.id
               AND li.key_ = 'tutorial_start') times
               UNION ALL
               SELECT task,
               TIME_TO_SEC(TIMEDIFF(task2, task1)) AS duration
               FROM (
               SELECT 'connect' as task,
               (SELECT timestamp FROM learner_interaction WHERE key_ = 'tutorial_select' AND game_registration_id = li.game_registration_id) AS task1,
               (SELECT timestamp FROM learner_interaction WHERE key_ = 'tutorial_connect' AND game_registration_id = li.game_registration_id) AS task2
               FROM learner_interaction li, game_registration gr, learner l
               WHERE li.game_registration_id = gr.id
               AND gr.learner_id = l.id
               AND li.key_ = 'tutorial_start') times
               UNION ALL
               SELECT task,
               TIME_TO_SEC(TIMEDIFF(task2, task1)) AS duration
               FROM (
               SELECT 'grab' as task,
               (SELECT timestamp FROM learner_interaction WHERE key_ = 'tutorial_connect' AND game_registration_id = li.game_registration_id) AS task1,
               (SELECT timestamp FROM learner_interaction WHERE key_ = 'tutorial_grab' AND game_registration_id = li.game_registration_id) AS task2
               FROM learner_interaction li, game_registration gr, learner l
               WHERE li.game_registration_id = gr.id
               AND gr.learner_id = l.id
               AND li.key_ = 'tutorial_start') times")

rs = dbSendQuery(studyDb, query)
dbRows <- dbFetch(rs)

ggplot(data=dbRows, aes(x=task, y=duration, color=task)) +
  ggtitle(paste0("Tutorial Tasks - Kernel Probability Density (Violin shape)")) + 
  geom_violin(trim=FALSE) +
  geom_jitter(shape=8, position=position_jitter(0.1), color="#777777")
#  geom_dotplot(binaxis='y', stackdir='center',
#                 position=position_dodge(1))

num_participants <- 19

data = t(matrix(c(dbRows$teleport_duration, dbRows$gaze_duration, dbRows$select_duration, dbRows$connect_duration, dbRows$grab_duration),
              nrow = num_participants,
              ncol = 5))



dbDisconnect(studyDb)