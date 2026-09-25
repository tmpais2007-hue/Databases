-- Intentionally invalid rows

-- School table: NOT NULL violation
INSERT INTO School (name, city, country) VALUES (NULL, 'Paris', 'France');

-- Participant table: invalid foreign key + CHECK violation
INSERT INTO Participant (school_id, first_name, last_name, date_of_birth, gender, grade_level, consent_date)
VALUES (999, 'Bad', 'Student', '2015-01-15', 'M', 15, '2024-01-01');

-- Contact_Info table: duplicate primary key
INSERT INTO Contact_Info (contact_id, participant_id, contact_type, contact_value)
VALUES (1, 1, 'email', 'duplicate@example.com');

-- Contact_Info table: invalid foreign key
INSERT INTO Contact_Info (contact_id, participant_id, contact_type, contact_value)
VALUES (99, 999, 'phone', '+33123456789');

-- Assessor table: NOT NULL violation
INSERT INTO Assessor (first_name, last_name, role, organisation)
VALUES ('Bad', 'Assessor', NULL, 'Test Org');

-- Assessment table: invalid foreign key on assessor_id
INSERT INTO Assessment (participant_id, assessor_id, assessed_on, anxiety_score, depression_score, self_esteem_score, intervention_type)
VALUES (1, 999, '2024-10-10', 50, 45, 60, 'Bad Intervention');

-- Usage_Log table: invalid foreign key on platform_id
INSERT INTO Usage_Log (participant_id, platform_id, log_date, active_minutes, passive_minutes)
VALUES (1, 999, '2024-10-11', 30, 10);

-- Daily_Log table: invalid foreign key on participant_id
INSERT INTO Daily_Log (participant_id, log_date, sleep_hours, physical_activity_min, mood_rating)
VALUES (999, '2024-10-12', 7.5, 40, 4);

-- Incident table: invalid foreign key on platform_id
INSERT INTO Incident (participant_id, platform_id, reported_on, incident_type, severity)
VALUES (1, 999, '2024-10-13', 'Harassment', 3);