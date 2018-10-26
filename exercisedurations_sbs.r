library(RMySQL)

studyDb <- dbConnect(MySQL(), user='larkin', password='password', dbname='data_for_cleaning')

query <- paste("
        SELECT distinct 
               lo.letter as Participant, 
               (SELECT TIME_TO_SEC(TIMEDIFF(MAX(li.timestamp), MIN(timestamp))) AS duration1
					  FROM learner_interaction li,
						   game_registration gr,
						   learner l
					 WHERE li.game_registration_id = gr.id
                       AND li.game_registration_id = lio.game_registration_id
					   AND gr.learner_id = l.id
					   AND li.key_ IN ('level1_exercise','tutorial_grab', 'tutorial_end')) as ex1_duration,
               (SELECT TIME_TO_SEC(TIMEDIFF(MAX(li.timestamp), MIN(timestamp))) AS duration2
					  FROM learner_interaction li,
						   game_registration gr,
						   learner l
					 WHERE li.game_registration_id = gr.id
                       AND li.game_registration_id = lio.game_registration_id
					   AND gr.learner_id = l.id
					   AND li.key_ IN ('level2_exercise','level_2_exercise_begin','graph_simple_rule')) AS ex2_duration,
              (SELECT TIME_TO_SEC(TIMEDIFF(MAX(li.timestamp), MIN(timestamp))) AS duration3
					  FROM learner_interaction li,
						   game_registration gr,
						   learner l
					 WHERE li.game_registration_id = lio.game_registration_id
                       AND li.game_registration_id = gr.id
					   AND gr.learner_id = l.id
					   AND li.key_ IN ('level3_exercise','level_3_exercise_start','speed_run_1')) ex3_duration
               FROM learner_interaction lio, game_registration gro, learner lo
			  WHERE lio.game_registration_id = gro.id
                AND gro.learner_id = lo.id
			  ORDER BY Participant ASC;")

rs = dbSendQuery(studyDb, query)
dbRows <- dbFetch(rs)

num_participants <- 19

data = t(matrix(c(dbRows$ex1_duration, dbRows$ex2_duration, dbRows$ex3_duration),
              nrow = num_participants,
              ncol = 3))

# Barchart of side-by-side total of exercise durations
barplot(data, names.arg = dbRows$Participant, beside=T, xlab = "Participant", col=c("orange","darkgreen","lightblue"), border="black", main = "Examples Durations, side-by-side")
legend(24,700, legend=c("Exercise 1", "Exercise 2", "Exercise 3"), fill=c("orange","darkgreen","lightblue"))

# Calculate mean, media and standard deviation
#mean(dbRows$Duration)
#median(dbRows$Duration)
#sd(dbRows$Duration)

dbDisconnect(studyDb)