library(RMySQL)
library(ggplot2)

studyDb <- dbConnect(MySQL(), user='larkin', password='password', dbname='data_for_cleaning')

participant <- "S"
exercise <- "3"

query <- paste0("SELECT TIME_TO_SEC(TIMEDIFF(li.timestamp,start_time.timestamp)) AS time_since_start,
       SUBSTRING_INDEX(SUBSTRING_INDEX(li.value, ':', 1), ':', -1) as correct,
       SUBSTRING_INDEX(SUBSTRING_INDEX(li.value, ':', 2), ':', -1) as incorrect
  FROM learner_interaction li,
       learner_interaction_type lit,
       game_registration gr,
       learner l,
       (SELECT MIN(li.timestamp) AS timestamp
		  FROM learner_interaction li,
			   learner_interaction_type lit,
			   game_registration gr,
			   learner l
		 WHERE l.letter = '", participant, "'
		   AND li.game_registration_id = gr.id
		   AND gr.learner_id = l.id
		   AND li.learner_interaction_type_id = lit.id
		   AND lit.name = 'trail'
		   AND (li.key_ LIKE '%", exercise, "%exercise%')) start_time
 WHERE l.letter = '", participant, "'
   AND li.game_registration_id = gr.id
   AND gr.learner_id = l.id
   AND li.learner_interaction_type_id = lit.id
   AND lit.name = 'trail'
   AND li.key_ = 'level", exercise, "_exercise'")

rs = dbSendQuery(studyDb, query)
dbRows <- dbFetch(rs)

query <- paste0("SELECT 0 AS correct, 0 AS time_since_start
              UNION
              SELECT 1 AS correct, AVG(ex3_duration) AS time_since_start FROM (SELECT DISTINCT lo.letter, 
              (SELECT TIME_TO_SEC(TIMEDIFF(MAX(li.timestamp), MIN(timestamp))) AS duration3
                FROM learner_interaction li,
                learner_interaction_type lit,
                game_registration gr,
                learner l
                WHERE li.game_registration_id = lio.game_registration_id
                AND li.game_registration_id = gr.id
                AND gr.learner_id = l.id
                AND li.learner_interaction_type_id = lit.id
                AND lit.name = 'trail'
                AND li.key_ IN ('level3_exercise','level_3_exercise_start','speed_run_1')
                AND SUBSTRING_INDEX(SUBSTRING_INDEX(li.value, ':', 1), ':', -1) <= '1') AS ex3_duration
                FROM learner_interaction lio, game_registration gro, learner lo
                WHERE lio.game_registration_id = gro.id
                AND gro.learner_id = lo.id) x
                WHERE letter >= 'I'
                UNION
                SELECT 2 AS correct, AVG(ex3_duration) AS time_since_start FROM (SELECT DISTINCT lo.letter, 
                (SELECT TIME_TO_SEC(TIMEDIFF(MAX(li.timestamp), MIN(timestamp))) AS duration3
                FROM learner_interaction li,
                learner_interaction_type lit,
                game_registration gr,
                learner l
                WHERE li.game_registration_id = lio.game_registration_id
                AND li.game_registration_id = gr.id
                AND gr.learner_id = l.id
                AND li.learner_interaction_type_id = lit.id
                AND lit.name = 'trail'
                AND li.key_ IN ('level3_exercise','level_3_exercise_start','speed_run_1')
                AND SUBSTRING_INDEX(SUBSTRING_INDEX(li.value, ':', 1), ':', -1) <= '2') AS ex3_duration
                FROM learner_interaction lio, game_registration gro, learner lo
                WHERE lio.game_registration_id = gro.id
                AND gro.learner_id = lo.id) x
                WHERE letter >= 'I'
                UNION
                SELECT 3 AS correct, AVG(ex3_duration) AS time_since_start FROM (SELECT DISTINCT lo.letter, 
                (SELECT TIME_TO_SEC(TIMEDIFF(MAX(li.timestamp), MIN(timestamp))) AS duration3
                FROM learner_interaction li,
                learner_interaction_type lit,
                game_registration gr,
                learner l
                WHERE li.game_registration_id = lio.game_registration_id
                AND li.game_registration_id = gr.id
                AND gr.learner_id = l.id
                AND li.learner_interaction_type_id = lit.id
                AND lit.name = 'trail'
                AND li.key_ IN ('level3_exercise','level_3_exercise_start','speed_run_1')
                AND SUBSTRING_INDEX(SUBSTRING_INDEX(li.value, ':', 1), ':', -1) <= '3') AS ex3_duration
                FROM learner_interaction lio, game_registration gro, learner lo
                WHERE lio.game_registration_id = gro.id
                AND gro.learner_id = lo.id) x
                WHERE letter >= 'I'
                UNION
                SELECT 4 AS correct, AVG(ex3_duration) AS time_since_start FROM (SELECT DISTINCT lo.letter, 
                (SELECT TIME_TO_SEC(TIMEDIFF(MAX(li.timestamp), MIN(timestamp))) AS duration3
                FROM learner_interaction li,
                learner_interaction_type lit,
                game_registration gr,
                learner l
                WHERE li.game_registration_id = lio.game_registration_id
                AND li.game_registration_id = gr.id
                AND gr.learner_id = l.id
                AND li.learner_interaction_type_id = lit.id
                AND lit.name = 'trail'
                AND li.key_ IN ('level3_exercise','level_3_exercise_start','speed_run_1')
                AND SUBSTRING_INDEX(SUBSTRING_INDEX(li.value, ':', 1), ':', -1) <= '4') AS ex3_duration
                FROM learner_interaction lio, game_registration gro, learner lo
                WHERE lio.game_registration_id = gro.id
                AND gro.learner_id = lo.id) x
                WHERE letter >= 'I'
                UNION
                SELECT 5 AS correct, AVG(ex3_duration) AS time_since_start FROM (SELECT DISTINCT lo.letter, 
                (SELECT TIME_TO_SEC(TIMEDIFF(MAX(li.timestamp), MIN(timestamp))) AS duration3
                FROM learner_interaction li,
                learner_interaction_type lit,
                game_registration gr,
                learner l
                WHERE li.game_registration_id = lio.game_registration_id
                AND li.game_registration_id = gr.id
                AND gr.learner_id = l.id
                AND li.learner_interaction_type_id = lit.id
                AND lit.name = 'trail'
                AND li.key_ IN ('level3_exercise','level_3_exercise_start','speed_run_1')
                AND SUBSTRING_INDEX(SUBSTRING_INDEX(li.value, ':', 1), ':', -1) <= '5') AS ex3_duration
                FROM learner_interaction lio, game_registration gro, learner lo
                WHERE lio.game_registration_id = gro.id
                AND gro.learner_id = lo.id) x
                WHERE letter >= 'I'
                UNION
                SELECT 6 AS correct, AVG(ex3_duration) AS time_since_start FROM (SELECT DISTINCT lo.letter, 
                (SELECT TIME_TO_SEC(TIMEDIFF(MAX(li.timestamp), MIN(timestamp))) AS duration3
                FROM learner_interaction li,
                learner_interaction_type lit,
                game_registration gr,
                learner l
                WHERE li.game_registration_id = lio.game_registration_id
                AND li.game_registration_id = gr.id
                AND gr.learner_id = l.id
                AND li.learner_interaction_type_id = lit.id
                AND lit.name = 'trail'
                AND li.key_ IN ('level3_exercise','level_3_exercise_start','speed_run_1')
                AND SUBSTRING_INDEX(SUBSTRING_INDEX(li.value, ':', 1), ':', -1) <= '6') AS ex3_duration
                FROM learner_interaction lio, game_registration gro, learner lo
                WHERE lio.game_registration_id = gro.id
                AND gro.learner_id = lo.id) x
                WHERE letter >= 'I'
                UNION
                SELECT 7 AS correct, AVG(ex3_duration) AS time_since_start FROM (SELECT DISTINCT lo.letter, 
                (SELECT TIME_TO_SEC(TIMEDIFF(MAX(li.timestamp), MIN(timestamp))) AS duration3
                FROM learner_interaction li,
                learner_interaction_type lit,
                game_registration gr,
                learner l
                WHERE li.game_registration_id = lio.game_registration_id
                AND li.game_registration_id = gr.id
                AND gr.learner_id = l.id
                AND li.learner_interaction_type_id = lit.id
                AND lit.name = 'trail'
                AND li.key_ IN ('level3_exercise','level_3_exercise_start','speed_run_1')
                AND SUBSTRING_INDEX(SUBSTRING_INDEX(li.value, ':', 1), ':', -1) <= '7') AS ex3_duration
                FROM learner_interaction lio, game_registration gro, learner lo
                WHERE lio.game_registration_id = gro.id
                AND gro.learner_id = lo.id) x
                WHERE letter >= 'I'
                UNION
                SELECT 8 AS correct, AVG(ex3_duration) AS time_since_start FROM (SELECT DISTINCT lo.letter, 
                (SELECT TIME_TO_SEC(TIMEDIFF(MAX(li.timestamp), MIN(timestamp))) AS duration3
                FROM learner_interaction li,
                learner_interaction_type lit,
                game_registration gr,
                learner l
                WHERE li.game_registration_id = lio.game_registration_id
                AND li.game_registration_id = gr.id
                AND gr.learner_id = l.id
                AND li.learner_interaction_type_id = lit.id
                AND lit.name = 'trail'
                AND li.key_ IN ('level3_exercise','level_3_exercise_start','speed_run_1')
                AND SUBSTRING_INDEX(SUBSTRING_INDEX(li.value, ':', 1), ':', -1) <= '8') AS ex3_duration
                FROM learner_interaction lio, game_registration gro, learner lo
                WHERE lio.game_registration_id = gro.id
                AND gro.learner_id = lo.id) x
                WHERE letter >= 'I'
                UNION
                SELECT 9 AS correct, AVG(ex3_duration) AS time_since_start FROM (SELECT DISTINCT lo.letter, 
                (SELECT TIME_TO_SEC(TIMEDIFF(MAX(li.timestamp), MIN(timestamp))) AS duration3
                FROM learner_interaction li,
                learner_interaction_type lit,
                game_registration gr,
                learner l
                WHERE li.game_registration_id = lio.game_registration_id
                AND li.game_registration_id = gr.id
                AND gr.learner_id = l.id
                AND li.learner_interaction_type_id = lit.id
                AND lit.name = 'trail'
                AND li.key_ IN ('level3_exercise','level_3_exercise_start','speed_run_1')
                AND SUBSTRING_INDEX(SUBSTRING_INDEX(li.value, ':', 1), ':', -1) <= '9') AS ex3_duration
                FROM learner_interaction lio, game_registration gro, learner lo
                WHERE lio.game_registration_id = gro.id
                AND gro.learner_id = lo.id) x
                WHERE letter >= 'I'")

rs = dbSendQuery(studyDb, query)
dbRows2 <- dbFetch(rs)

dbRows$correct <- as.numeric(dbRows$correct)
dbRows$incorrect <- as.numeric(dbRows$incorrect)

# Plot correct versus incorrect over time elapsed
ggplot() + 
  geom_line(data=dbRows,aes(x= time_since_start, y = incorrect, colour = "incorrect", group="incorrect"), linetype=6) +
  geom_line(data=dbRows,aes(x= time_since_start, y = correct, colour = "correct", group="correct"), linetype=2) +
  geom_line(data=dbRows2,aes(x= time_since_start, y = correct, colour = "average", group="average"), linetype=1) +
  xlab("Seconds Elapsed") +
  ylab("No. of Edges Correct/Incorrect") +
  #ggtitle(paste0("Correct vs. Incorrect over Time (compared to avg)"," - Part. ", participant, " - Ex. ", exercise)) + 
  scale_color_manual(values=c("#0043aa","#11BB65","#CC6666"), guide=guide_legend(override.aes=list(linetype=c(1,2,6), lwd=c(1, 1,1)))) +
  scale_y_continuous(breaks = function(x) unique(floor(pretty(seq(0, (max(x) + 1) * 1.1)))))

dbDisconnect(studyDb)