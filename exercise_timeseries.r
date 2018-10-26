library(RMySQL)
library(ggplot2)

studyDb <- dbConnect(MySQL(), user='larkin', password='password', dbname='data_for_cleaning')

participant <- "T"
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
		   AND li.key_ = 'level3_exercise') start_time
 WHERE l.letter = '", participant, "'
   AND li.game_registration_id = gr.id
   AND gr.learner_id = l.id
   AND li.learner_interaction_type_id = lit.id
   AND lit.name = 'trail'
   AND li.key_ = 'level", exercise, "_exercise'")

rs = dbSendQuery(studyDb, query)
dbRows <- dbFetch(rs)

# Plot correct versus incorrect over time elapsed
ggplot(dbRows, aes(time_since_start)) + 
  geom_line(aes(y = incorrect, colour = "incorrect", group="incorrect"), linetype=2) +
  geom_line(aes(y = correct, colour = "correct", group="correct")) +
  xlab("Seconds Elapsed") +
  ylab("No. of Edges Correct/Incorrect") +
  #ggtitle("No. of Correct versus Incorrect Edges over Time Elapsed") + 
  scale_color_manual(values=c("#1111CC","#CC6666"), guide=guide_legend(override.aes=list(linetype=c(1,2), lwd=c(1, 1))))

dbDisconnect(studyDb)