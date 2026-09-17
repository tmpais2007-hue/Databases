INSERT INTO School (name, city, country) VALUES
('Lycée International', 'Paris', 'France'),
('Green Valley Academy', 'London', 'United Kingdom'),
('Northwind College', 'Toronto', 'Canada');

INSERT INTO Participant (school_id, first_name, last_name, date_of_birth, gender, grade_level, consent_date) VALUES
(1, 'Alice', 'Martin', '2009-05-12', 'F', 10, '2024-09-01'),
(1, 'Lucas', 'Bernard', '2010-02-18', 'M', 11, '2024-09-01'),
(2, 'Emma', 'Wilson', '2008-11-07', 'F', 12, '2024-08-25'),
(2, 'Noah', 'Smith', '2011-04-22', 'M', 9, '2024-08-30'),
(3, 'Sofia', 'Garcia', '2009-08-15', 'F', 10, '2024-09-05');

INSERT INTO Contact_Info (contact_id, participant_id, contact_type, contact_value) VALUES
(1, 1, 'phone', '+33612345678'),
(2, 1, 'email', 'alice.martin@email.com'),
(3, 2, 'phone', '+33687654321'),
(4, 3, 'email', 'emma.wilson@email.com'),
(5, 4, 'phone', '+447700112233'),
(6, 5, 'email', 'sofia.garcia@email.com');

INSERT INTO Assessor (first_name, last_name, role, organisation) VALUES
('Claire', 'Dubois', 'Psychologist', 'School Wellness Center'),
('Daniel', 'Khan', 'Counselor', 'Youth Support Unit'),
('Marta', 'Lopez', 'Teacher', 'Academic Guidance Office');

INSERT INTO Assessment (participant_id, assessor_id, assessed_on, anxiety_score, depression_score, self_esteem_score, intervention_type) VALUES
(1, 1, '2024-10-02', 62, 40, 68, 'Counselling'),
(2, 2, '2024-10-03', 55, 52, 60, 'CBT'),
(3, 1, '2024-10-04', 71, 63, 57, 'Group Therapy'),
(4, 3, '2024-10-05', 48, 46, 72, 'Mindfulness'),
(5, 2, '2024-10-06', 59, 50, 65, 'Support Plan');

INSERT INTO Platform (name, company_name, minimum_age) VALUES
('YouTube', 'Google', 13),
('TikTok', 'ByteDance', 13),
('Discord', 'Discord', 13),
('Instagram', 'Meta', 13),
('Minecraft', 'Microsoft', 10);

INSERT INTO Usage_Log (participant_id, platform_id, log_date, active_minutes, passive_minutes) VALUES
(1, 1, '2024-10-01', 45, 30),
(1, 2, '2024-10-01', 20, 60),
(2, 3, '2024-10-02', 35, 25),
(3, 4, '2024-10-03', 50, 40),
(4, 5, '2024-10-04', 65, 20),
(5, 1, '2024-10-05', 30, 50),
(2, 1, '2024-10-06', 55, 35),
(3, 3, '2024-10-06', 40, 45);

INSERT INTO Daily_Log (participant_id, log_date, sleep_hours, physical_activity_min, mood_rating) VALUES
(1, '2024-10-01', 7.5, 30, 4),
(1, '2024-10-02', 8.0, 25, 5),
(2, '2024-10-01', 6.8, 20, 3),
(3, '2024-10-03', 7.2, 45, 4),
(4, '2024-10-04', 8.5, 60, 5),
(5, '2024-10-05', 6.9, 15, 2);

INSERT INTO Incident (participant_id, platform_id, reported_on, incident_type, severity) VALUES
(1, 2, '2024-10-02', 'Cyberbullying', 2),
(2, 3, '2024-10-03', 'Excessive screen time', 1),
(3, 4, '2024-10-05', 'Privacy concern', 3),
(4, 5, '2024-10-06', 'Inappropriate contact', 2),
(5, 1, '2024-10-07', 'Online harassment', 3);