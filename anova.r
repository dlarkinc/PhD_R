library(RMySQL)
library(lavaan)
library(dplyr)

studyDb <- dbConnect(MySQL(), user='larkin', password='password', dbname='study_1_data')
studyDbGP <- dbConnect(MySQL(), user='larkin', password='password', dbname='data_for_cleaning')

# Get tutorial durations

query <- paste("
        SELECT Participant, 
               TIME_TO_SEC(TIMEDIFF(tutorial_teleport, tutorial_start)) AS teleport_duration,
               TIME_TO_SEC(TIMEDIFF(tutorial_abutton, tutorial_teleport)) AS abutton_duration,
               TIME_TO_SEC(TIMEDIFF(tutorial_gaze, tutorial_abutton)) AS gaze_duration,
               TIME_TO_SEC(TIMEDIFF(tutorial_select, tutorial_gaze)) AS select_duration,
               TIME_TO_SEC(TIMEDIFF(tutorial_connect, tutorial_select)) AS connect_duration,
               TIME_TO_SEC(TIMEDIFF(tutorial_grab, tutorial_connect)) AS grab_duration,
               TIME_TO_SEC(TIMEDIFF(tutorial_grab, tutorial_start)) AS total_duration
               FROM (
               SELECT l.letter AS participant,
               (SELECT timestamp FROM learner_interaction WHERE key_ = 'tutorial_start' AND game_registration_id = li.game_registration_id) AS tutorial_start,
               (SELECT timestamp FROM learner_interaction WHERE key_ = 'tutorial_teleport' AND game_registration_id = li.game_registration_id) AS tutorial_teleport,
               (SELECT timestamp FROM learner_interaction WHERE key_ = 'tutorial_abutton' AND game_registration_id = li.game_registration_id) AS tutorial_abutton,
               (SELECT timestamp FROM learner_interaction WHERE key_ = 'tutorial_gaze' AND game_registration_id = li.game_registration_id) AS tutorial_gaze,
               (SELECT timestamp FROM learner_interaction WHERE key_ = 'tutorial_select' AND game_registration_id = li.game_registration_id) AS tutorial_select,
               (SELECT timestamp FROM learner_interaction WHERE key_ = 'tutorial_connect' AND game_registration_id = li.game_registration_id) AS tutorial_connect,
               (SELECT timestamp FROM learner_interaction WHERE key_ = 'tutorial_grab' AND game_registration_id = li.game_registration_id) AS tutorial_grab
               FROM learner_interaction li, game_registration gr, learner l
               WHERE li.game_registration_id = gr.id
               AND gr.learner_id = l.id
               AND li.key_ = 'tutorial_start'
              UNION
               SELECT 'H', NULL, NULL, NULL, NULL, NULL, NULL, NULL
              ) times
               ORDER BY participant;")

rs = dbSendQuery(studyDbGP, query)
TutDur <- dbFetch(rs)


# Get exercise durations

query <- paste("
        SELECT *, ex1_duration + ex2_duration + ex3_duration AS total_duration 
          FROM (SELECT distinct 
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
               UNION
               SELECT 'H', NULL, NULL, NULL) c
               order by participant;")

rs = dbSendQuery(studyDbGP, query)
ExDur <- dbFetch(rs)

# Get examples durations
query <- paste("SELECT *, Duration1 + Duration2 AS total_duration FROM (
                SELECT distinct 
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
               UNION
               SELECT 'H', NULL, NULL) x
               ORDER BY Participant ASC")

rs = dbSendQuery(studyDbGP, query)
EgDur <- dbFetch(rs)

#Get example engagements
query <- paste("
            SELECT * FROM (
               SELECT distinct 
               l.letter as Participant,
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
              UNION
               SELECT 'A', NULL
              UNION
               SELECT 'B', NULL
              UNION
               SELECT 'C', NULL
              UNION
               SELECT 'D', NULL
              UNION
               SELECT 'E', NULL
              UNION
               SELECT 'F', NULL
              UNION
               SELECT 'G', NULL
              UNION
               SELECT 'H', NULL) x
               ORDER BY Participant ASC")

rs = dbSendQuery(studyDbGP, query)
EgEng <- dbFetch(rs)

query <- paste("SELECT letter, id, answer FROM likert_answers, id_letter where question_code = 'A2' AND id = p_id ORDER BY letter")
rs = dbSendQuery(studyDb, query)
A2 <- dbFetch(rs)

query <- paste("SELECT id, answer FROM likert_answers, id_letter where question_code = 'A3' AND id = p_id ORDER BY letter")
rs = dbSendQuery(studyDb, query)
A3 <- dbFetch(rs)

query <- paste("SELECT id, answer FROM likert_answers, id_letter where question_code = 'A7' AND id = p_id ORDER BY letter")
rs = dbSendQuery(studyDb, query)
A7 <- dbFetch(rs)

query <- paste("SELECT id, answer FROM likert_answers, id_letter where question_code = 'B1' AND id = p_id ORDER BY letter")
rs = dbSendQuery(studyDb, query)
B1 <- dbFetch(rs)

query <- paste("SELECT id, answer FROM likert_answers, id_letter where question_code = 'B2' AND id = p_id ORDER BY letter")
rs = dbSendQuery(studyDb, query)
B2 <- dbFetch(rs)

query <- paste("SELECT id, answer FROM likert_answers, id_letter where question_code = 'B3' AND id = p_id ORDER BY letter")
rs = dbSendQuery(studyDb, query)
B3 <- dbFetch(rs)

query <- paste("SELECT id, answer FROM likert_answers, id_letter where question_code = 'B4' AND id = p_id ORDER BY letter")
rs = dbSendQuery(studyDb, query)
B4 <- dbFetch(rs)
B4[,c("answer")] = 6 - B4[,c("answer")]

query <- paste("SELECT id, answer FROM likert_answers, id_letter where question_code = 'C1' AND id = p_id ORDER BY letter")
rs = dbSendQuery(studyDb, query)
C1 <- dbFetch(rs)

query <- paste("SELECT id, answer FROM likert_answers, id_letter where question_code = 'C2' AND id = p_id ORDER BY letter")
rs = dbSendQuery(studyDb, query)
C2 <- dbFetch(rs)

query <- paste("SELECT id, answer FROM likert_answers, id_letter where question_code = 'C3' AND id = p_id ORDER BY letter")
rs = dbSendQuery(studyDb, query)
C3 <- dbFetch(rs)
C3[,c("answer")] = 6 - C3[,c("answer")]

query <- paste("SELECT id, answer FROM likert_answers, id_letter where question_code = 'D1' AND id = p_id ORDER BY letter")
rs = dbSendQuery(studyDb, query)
D1 <- dbFetch(rs)

query <- paste("SELECT id, answer FROM likert_answers, id_letter where question_code = 'D2' AND id = p_id ORDER BY letter")
rs = dbSendQuery(studyDb, query)
D2 <- dbFetch(rs)
D2[,c("answer")] = 6 - D2[,c("answer")]

query <- paste("SELECT id, answer FROM likert_answers, id_letter where question_code = 'E1' AND id = p_id ORDER BY letter")
rs = dbSendQuery(studyDb, query)
E1 <- dbFetch(rs)

query <- paste("SELECT id, answer FROM likert_answers, id_letter where question_code = 'E2' AND id = p_id ORDER BY letter")
rs = dbSendQuery(studyDb, query)
E2 <- dbFetch(rs)

query <- paste("SELECT id, answer FROM likert_answers, id_letter where question_code = 'E3' AND id = p_id ORDER BY letter")
rs = dbSendQuery(studyDb, query)
E3 <- dbFetch(rs)

query <- paste("SELECT id, answer FROM likert_answers, id_letter where question_code = 'E4' AND id = p_id ORDER BY letter")
rs = dbSendQuery(studyDb, query)
E4 <- dbFetch(rs)
E4[,c("answer")] = 6 - E4[,c("answer")]

query <- paste("SELECT id, answer FROM likert_answers, id_letter where question_code = 'F1' AND id = p_id ORDER BY letter")
rs = dbSendQuery(studyDb, query)
F1 <- dbFetch(rs)

query <- paste("SELECT id, answer FROM likert_answers, id_letter where question_code = 'F2' AND id = p_id ORDER BY letter")
rs = dbSendQuery(studyDb, query)
F2 <- dbFetch(rs)

query <- paste("SELECT id, answer FROM likert_answers, id_letter where question_code = 'F3' AND id = p_id ORDER BY letter")
rs = dbSendQuery(studyDb, query)
F3 <- dbFetch(rs)

query <- paste("SELECT id, answer FROM likert_answers, id_letter where question_code = 'F4' AND id = p_id ORDER BY letter")
rs = dbSendQuery(studyDb, query)
F4 <- dbFetch(rs)
F4[,c("answer")] = 6 - F4[,c("answer")]

query <- paste("SELECT id, answer FROM likert_answers, id_letter where question_code = 'F5' AND id = p_id ORDER BY letter")
rs = dbSendQuery(studyDb, query)
F5 <- dbFetch(rs)
F5[,c("answer")] = 6 - F5[,c("answer")]

query <- paste("SELECT id, answer FROM likert_answers, id_letter where question_code = 'F6' AND id = p_id ORDER BY letter")
rs = dbSendQuery(studyDb, query)
F6 <- dbFetch(rs)

query <- paste("SELECT id, answer FROM likert_answers, id_letter where question_code = 'F7' AND id = p_id ORDER BY letter")
rs = dbSendQuery(studyDb, query)
F7 <- dbFetch(rs)

query <- paste("SELECT id, answer FROM likert_answers, id_letter where question_code = 'F8' AND id = p_id ORDER BY letter")
rs = dbSendQuery(studyDb, query)
F8 <- dbFetch(rs)

query <- paste("SELECT id, answer FROM likert_answers, id_letter where question_code = 'F9' AND id = p_id ORDER BY letter")
rs = dbSendQuery(studyDb, query)
F9 <- dbFetch(rs)

query <- paste("SELECT id, answer FROM likert_answers, id_letter where question_code = 'H1' AND id = p_id ORDER BY letter")
rs = dbSendQuery(studyDb, query)
H1 <- dbFetch(rs)

query <- paste("SELECT id, answer FROM likert_answers, id_letter where question_code = 'H2' AND id = p_id ORDER BY letter")
rs = dbSendQuery(studyDb, query)
H2 <- dbFetch(rs)
for (n in 1:7) { H2 <- rbind(c(NA, NA), H2) }

query <- paste("SELECT id, answer FROM likert_answers, id_letter where question_code = 'H3' AND id = p_id ORDER BY letter")
rs = dbSendQuery(studyDb, query)
H3 <- dbFetch(rs)
for (n in 1:7) { H3 <- rbind(c(NA, NA), H3) }

query <- paste("SELECT id, answer FROM likert_answers, id_letter where question_code = 'H4' AND id = p_id ORDER BY letter")
rs = dbSendQuery(studyDb, query)
H4 <- dbFetch(rs)
for (n in 1:7) { H4 <- rbind(c(NA, NA), H4) }

query <- paste("SELECT id, answer FROM likert_answers, id_letter where question_code = 'H5' AND id = p_id ORDER BY letter")
rs = dbSendQuery(studyDb, query)
H5 <- dbFetch(rs)
for (n in 1:7) { H5 <- rbind(c(NA, NA), H5) }

query <- paste("SELECT id, answer FROM likert_answers, id_letter where question_code = 'H6' AND id = p_id ORDER BY letter")
rs = dbSendQuery(studyDb, query)
H6 <- dbFetch(rs)
for (n in 1:7) { H6 <- rbind(c(NA, NA), H6) }

query <- paste("SELECT id, answer FROM likert_answers, id_letter where question_code = 'I1' AND id = p_id ORDER BY letter")
rs = dbSendQuery(studyDb, query)
I1 <- dbFetch(rs)

query <- paste("SELECT id, answer FROM likert_answers, id_letter where question_code = 'I2' AND id = p_id ORDER BY letter")
rs = dbSendQuery(studyDb, query)
I2 <- dbFetch(rs)

query <- paste("SELECT id, answer FROM likert_answers, id_letter where question_code = 'I3' AND id = p_id ORDER BY letter")
rs = dbSendQuery(studyDb, query)
I3 <- dbFetch(rs)

query <- paste("SELECT id, answer FROM likert_answers, id_letter where question_code = 'I4' AND id = p_id ORDER BY letter")
rs = dbSendQuery(studyDb, query)
I4 <- dbFetch(rs)
I4[,c("answer")] = 6 - I4[,c("answer")]

query <- paste("SELECT id, answer FROM likert_answers, id_letter where question_code = 'I5' AND id = p_id ORDER BY letter")
rs = dbSendQuery(studyDb, query)
I5 <- dbFetch(rs)

query <- paste("SELECT id, answer FROM likert_answers, id_letter where question_code = 'I6' AND id = p_id ORDER BY letter")
rs = dbSendQuery(studyDb, query)
I6 <- dbFetch(rs)

query <- paste("SELECT id, answer FROM likert_answers, id_letter where question_code = 'I7' AND id = p_id ORDER BY letter")
rs = dbSendQuery(studyDb, query)
I7 <- dbFetch(rs)
I7[,c("answer")] = 6 - I7[,c("answer")]

query <- paste("SELECT id, answer FROM likert_answers, id_letter where question_code = 'I8' AND id = p_id ORDER BY letter")
rs = dbSendQuery(studyDb, query)
I8 <- dbFetch(rs)

query <- paste("SELECT id, answer FROM likert_answers, id_letter where question_code = 'I9' AND id = p_id ORDER BY letter")
rs = dbSendQuery(studyDb, query)
I9 <- dbFetch(rs)

query <- paste("SELECT id, answer FROM likert_answers, id_letter where question_code = 'I10' AND id = p_id ORDER BY letter")
rs = dbSendQuery(studyDb, query)
I10 <- dbFetch(rs)
I10[,c("answer")] = 6 - I10[,c("answer")]

query <- paste("SELECT id, answer FROM likert_answers, id_letter where question_code = 'I11' AND id = p_id ORDER BY letter")
rs = dbSendQuery(studyDb, query)
I11 <- dbFetch(rs)

query <- paste("SELECT id, answer FROM likert_answers, id_letter where question_code = 'I12' AND id = p_id ORDER BY letter")
rs = dbSendQuery(studyDb, query)
I12 <- dbFetch(rs)

query <- paste("SELECT id, answer FROM likert_answers, id_letter where question_code = 'I13' AND id = p_id ORDER BY letter")
rs = dbSendQuery(studyDb, query)
I13 <- dbFetch(rs)

query <- paste("SELECT id, answer FROM likert_answers, id_letter where question_code = 'I14' AND id = p_id ORDER BY letter")
rs = dbSendQuery(studyDb, query)
I14 <- dbFetch(rs)
I14[,c("answer")] = 6 - I14[,c("answer")]

data = as.data.frame(matrix(c(
  A2$id, A2$answer, A3$answer, B1$answer, B2$answer, B3$answer, B4$answer, C1$answer, 
  C2$answer, C3$answer, D1$answer, D2$answer, E1$answer, #13
  E2$answer, E3$answer, E4$answer, F1$answer, F2$answer, #18
  F3$answer, F4$answer, F5$answer, F6$answer, F7$answer, #23
  F8$answer, F9$answer, H1$answer,                       #26
  I1$answer, I2$answer, I3$answer, I4$answer, I5$answer, #31
  I6$answer, I7$answer, I8$answer, I9$answer, I10$answer,#36
  I11$answer, I12$answer, I13$answer, I14$answer, A7$answer,#41
  TutDur$teleport_duration, TutDur$gaze_duration, TutDur$select_duration, #44
  TutDur$connect_duration, TutDur$grab_duration, TutDur$total_duration,   #47
  ExDur$ex1_duration, ExDur$ex2_duration, ExDur$ex3_duration,             #50
  ExDur$total_duration, EgDur$Duration1, EgDur$Duration2, EgDur$total_duration, #54
  EgEng$Engagements, H2$answer, H3$answer, H4$answer, H5$answer, H6$answer  #60
  ),
  nrow = 20,
  ncol = 60))

# Group by age (18-24 vs 25+)
data$V2 = factor(data$V2, ordered = TRUE)
levels(data$V2) <- list(Younger=c("1"), Older=c("2", "3", "4", "5", "6"))

# Group by iteration 1 and others
data$V1 = factor(data$V1, ordered = TRUE)
levels(data$V1) <- list(Iter1=c(384327,
                                160002,
                                268347,
                                854212,
                                904002,
                                597132,
                                687348), 
                        Iter2and3=c(527617,
                                    777403,
                                    841543,
                                    707103,
                                    777038,
                                    637373,
                                    964717,
                                    921252,
                                    993482,
                                    140432,
                                    943634,
                                    959794,
                                    114628))

# Group by VR Experience
data$V26 = factor(data$V26, ordered = TRUE)
levels(data$V26) <- list(NoVR=c("1"), SomeVR=c("2", "3"))

# Means and SD by group
group_by(data, V26) %>% 
#  summarise_all(funs(mean))
  summarise(
    count = n(),
    mean = mean(V60, na.rm = T),
    sd = sd(V60, na.rm = T)
  )

cor(F3$answer, F5$answer)

t.test(EgEng$Engagements ~ data$V2)

res.aov <- aov(V7 ~ V2, data = data)
summary(res.aov)

boxplot(F7$answer ~ data$V2)
