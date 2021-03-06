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
			  ORDER BY lio.timestamp ASC;")

rs = dbSendQuery(studyDb, query)
dbRows <- dbFetch(rs)

# derive the sum of durations for each participant
dbRows$total <- dbRows$ex1_duration + dbRows$ex2_duration + dbRows$ex3_duration

num_participants <- 19

data = t(matrix(c(dbRows$ex1_duration, dbRows$ex2_duration, dbRows$ex3_duration),
              nrow = num_participants,
              ncol = 3))

#plot a grouped bar chart
barplot(data, names.arg = dbRows$Participant, xlab = "Participant", ylab = "seconds", col=c("orange","darkgreen","lightblue"), border="black", main = "Exercise Durations")
legend(8,1500, legend=c("Exercise 1", "Exercise 2", "Exercise 3"), fill=c("orange","darkgreen", "lightblue"))

mean(dbRows$total)
median(dbRows$total)
sd(dbRows$total)

dbDisconnect(studyDb)