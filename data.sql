INSERT INTO School (name, city, country) VALUES
('Lycée International', 'Paris', 'France'),
('Green Valley Academy', 'London', 'United Kingdom'),
('Northwind College', 'Toronto', 'Canada'),
('Riverside School', 'Berlin', 'Germany'),
('Harborview Academy', 'Sydney', 'Australia'),
('Summit Prep', 'Madrid', 'Spain'),
('Oakbridge High', 'Chicago', 'United States'),
('Maple Grove College', 'Tokyo', 'Japan'),
('Coastal Learning Center', 'Nairobi', 'Kenya'),
('Alpine Institute', 'Seoul', 'South Korea');

INSERT INTO Participant (school_id, first_name, last_name, date_of_birth, gender, grade_level, consent_date) VALUES
(1, 'Alice', 'Martin', '2009-05-12', 'F', 10, '2024-09-01'),
(1, 'Lucas', 'Bernard', '2010-02-18', 'M', 11, '2024-09-01'),
(2, 'Emma', 'Wilson', '2008-11-07', 'F', 12, '2024-08-25'),
(2, 'Noah', 'Smith', '2011-04-22', 'M', 9, '2024-08-30'),
(3, 'Sofia', 'Garcia', '2009-08-15', 'F', 10, '2024-09-05'),
(4, 'Liam', 'Johnson', '2008-09-14', 'M', 12, '2024-09-03'),
(5, 'Chloe', 'Davis', '2010-01-16', 'F', 9, '2024-09-04'),
(6, 'Ethan', 'Brown', '2009-06-21', 'M', 10, '2024-09-02'),
(7, 'Ava', 'Nguyen', '2011-03-09', 'F', 8, '2024-09-06'),
(8, 'Mason', 'Patel', '2008-12-05', 'M', 12, '2024-09-01');

INSERT INTO Contact_Info (contact_id, participant_id, contact_type, contact_value) VALUES
(1, 1, 'phone', '+33612345678'),
(2, 1, 'email', 'alice.martin@email.com'),
(3, 2, 'phone', '+33687654321'),
(4, 3, 'email', 'emma.wilson@email.com'),
(5, 4, 'phone', '+447700112233'),
(6, 5, 'email', 'sofia.garcia@email.com'),
(7, 6, 'phone', '+491512345678'),
(8, 6, 'email', 'liam.johnson@email.com'),
(9, 7, 'phone', '+61412345678'),
(10, 7, 'email', 'chloe.davis@email.com'),
(11, 8, 'phone', '+34611223344'),
(12, 8, 'email', 'ethan.brown@email.com'),
(13, 9, 'phone', '+12125550123'),
(14, 9, 'email', 'ava.nguyen@email.com'),
(15, 10, 'phone', '+81398765432'),
(16, 10, 'email', 'mason.patel@email.com');

INSERT INTO Assessor (first_name, last_name, role, organisation) VALUES
('Claire', 'Dubois', 'Psychologist', 'School Wellness Center'),
('Daniel', 'Khan', 'Counselor', 'Youth Support Unit'),
('Marta', 'Lopez', 'Teacher', 'Academic Guidance Office'),
('Henry', 'Lee', 'Psychologist', 'Youth Mental Health Network'),
('Priya', 'Nair', 'Counselor', 'Student Resilience Program'),
('Elena', 'Rossi', 'School Nurse', 'Campus Care Center'),
('Omar', 'Haddad', 'Social Worker', 'Family Support Services'),
('Grace', 'Miller', 'Wellbeing Coach', 'Wellness at School'),
('Samuel', 'Okafor', 'Psychologist', 'Community Health Clinic'),
('Talia', 'Cohen', 'Counselor', 'City Education Office');

INSERT INTO Assessment (participant_id, assessor_id, assessed_on, anxiety_score, depression_score, self_esteem_score, intervention_type) VALUES
(1, 1, '2024-10-02', 62, 40, 68, 'Counselling'),
(2, 2, '2024-10-03', 55, 52, 60, 'CBT'),
(3, 1, '2024-10-04', 71, 63, 57, 'Group Therapy'),
(4, 3, '2024-10-05', 48, 46, 72, 'Mindfulness'),
(5, 2, '2024-10-06', 59, 50, 65, 'Support Plan'),
(6, 4, '2024-10-07', 67, 61, 58, 'Group Therapy'),
(7, 5, '2024-10-08', 49, 44, 76, 'Mindfulness'),
(8, 6, '2024-10-09', 58, 55, 62, 'CBT'),
(9, 7, '2024-10-10', 64, 59, 60, 'Support Plan'),
(10, 3, '2024-10-11', 52, 48, 70, 'Counselling');

INSERT INTO Platform (name, company_name, minimum_age) VALUES
('YouTube', 'Google', 13),
('TikTok', 'ByteDance', 13),
('Discord', 'Discord', 13),
('Instagram', 'Meta', 13),
('Minecraft', 'Microsoft', 10),
('Snapchat', 'Snap Inc.', 13),
('WhatsApp', 'Meta', 16),
('Roblox', 'Roblox Corporation', 10),
('Twitch', 'Amazon', 13),
('Spotify', 'Spotify', 13);

INSERT INTO Usage_Log (participant_id, platform_id, log_date, active_minutes, passive_minutes) VALUES
(1, 1, '2024-10-01', 45, 30),
(1, 2, '2024-10-01', 20, 60),
(2, 3, '2024-10-02', 35, 25),
(3, 4, '2024-10-03', 50, 40),
(4, 5, '2024-10-04', 65, 20),
(5, 1, '2024-10-05', 30, 50),
(2, 1, '2024-10-06', 55, 35),
(3, 3, '2024-10-06', 40, 45),
(1, 3, '2024-10-02', 60, 25),
(1, 4, '2024-10-02', 40, 20),
(2, 1, '2024-10-03', 25, 70),
(2, 2, '2024-10-03', 15, 50),
(3, 5, '2024-10-04', 70, 35),
(3, 1, '2024-10-04', 30, 45),
(4, 2, '2024-10-05', 20, 65),
(4, 3, '2024-10-05', 45, 30),
(5, 4, '2024-10-06', 55, 40),
(5, 5, '2024-10-06', 25, 55),
(6, 1, '2024-10-07', 50, 30),
(6, 2, '2024-10-07', 35, 40),
(7, 3, '2024-10-08', 60, 20),
(7, 4, '2024-10-08', 25, 50),
(8, 5, '2024-10-09', 65, 25),
(9, 1, '2024-10-10', 45, 35),
(9, 2, '2024-10-10', 30, 55),
(10, 3, '2024-10-11', 55, 15),
(10, 5, '2024-10-11', 40, 45);

INSERT INTO Daily_Log (participant_id, log_date, sleep_hours, physical_activity_min, mood_rating) VALUES
(1, '2024-10-01', 7.5, 30, 4),
(1, '2024-10-02', 8.0, 25, 5),
(2, '2024-10-01', 6.8, 20, 3),
(3, '2024-10-03', 7.2, 45, 4),
(4, '2024-10-04', 8.5, 60, 5),
(5, '2024-10-05', 6.9, 15, 2),
(2, '2024-10-02', 7.1, 35, 4),
(3, '2024-10-04', 7.8, 40, 5),
(4, '2024-10-05', 8.2, 55, 4),
(6, '2024-10-07', 6.7, 18, 2),
(7, '2024-10-08', 7.9, 42, 5),
(8, '2024-10-09', 6.5, 20, 3),
(9, '2024-10-10', 8.1, 48, 4),
(10, '2024-10-11', 7.4, 36, 5);

INSERT INTO Incident (participant_id, platform_id, reported_on, incident_type, severity) VALUES
(1, 2, '2024-10-02', 'Cyberbullying', 2),
(2, 3, '2024-10-03', 'Excessive screen time', 1),
(3, 4, '2024-10-05', 'Privacy concern', 3),
(4, 5, '2024-10-06', 'Inappropriate contact', 2),
(5, 1, '2024-10-07', 'Online harassment', 3),
(6, 1, '2024-10-08', 'Exposure to harmful content', 2),
(7, 3, '2024-10-09', 'Online harassment', 3),
(8, 4, '2024-10-10', 'Privacy concern', 2),
(9, 5, '2024-10-11', 'Inappropriate contact', 1),
(10, 2, '2024-10-12', 'Excessive screen time', 2);