CREATE TABLE School (
    school_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
);
CREATE TABLE Participant (
    participant_id INT PRIMARY KEY AUTO_INCREMENT,
    school_id INT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender CHAR(1),
    grade_level INT,
    consent_date DATE NOT NULL,
    FOREIGN KEY (school_id) REFERENCES School(school_id) ON DELETE
    SET NULL
);
CREATE TABLE Contact_Info (
    contact_id INT,
    participant_id INT NOT NULL,
    contact_type VARCHAR(30) NOT NULL,
    contact_value VARCHAR(100) NOT NULL,
    PRIMARY KEY (contact_id, participant_id),
    FOREIGN KEY (participant_id) REFERENCES Participant(participant_id) ON DELETE CASCADE
);
CREATE TABLE Assessor (
    assessor_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    role VARCHAR(50) NOT NULL,
    organisation VARCHAR(50)
);
CREATE TABLE Assessment (
    assessment_id INT PRIMARY KEY AUTO_INCREMENT,
    participant_id INT NOT NULL,
    assessor_id INT,
    assessed_on DATE NOT NULL,
    anxiety_score INT,
    depression_score INT,
    self_esteem_score INT,
    intervention_type VARCHAR(50),
    FOREIGN KEY (participant_id) REFERENCES Participant(participant_id) ON DELETE CASCADE,
    FOREIGN KEY (assessor_id) REFERENCES Assessor(assessor_id) ON DELETE
    SET NULL
);
CREATE TABLE Platform (
    platform_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    company_name VARCHAR(50) NOT NULL,
    minimum_age INT NOT NULL,
);
CREATE TABLE Usage_Log (
    participant_id INT,
    platform_id INT,
    log_date DATE,
    active_minutes INT NOT NULL DEFAULT 0,
    passive_minutes INT NOT NULL DEFAULT 0,
    PRIMARY KEY (participant_id, platform_id, log_date),
    FOREIGN KEY (participant_id) REFERENCES Participant(participant_id) ON DELETE CASCADE,
    FOREIGN KEY (platform_id) REFERENCES Platform(platform_id) ON DELETE CASCADE
);
CREATE TABLE Daily_Log (
    participant_id INT,
    log_date DATE,
    sleep_hours DECIMAL(3, 1),
    physical_activity_min INT,
    mood_rating INT,
    PRIMARY KEY (participant_id, log_date),
    FOREIGN KEY (participant_id) REFERENCES Participant(participant_id) ON DELETE CASCADE
);
CREATE TABLE Incident (
    incident_id INT PRIMARY KEY AUTO_INCREMENT,
    participant_id INT NOT NULL,
    platform_id INT NOT NULL,
    reported_on DATE NOT NULL,
    incident_type VARCHAR(50) NOT NULL,
    severity INT NOT NULL,
    FOREIGN KEY (participant_id) REFERENCES Participant(participant_id) ON DELETE CASCADE,
    FOREIGN KEY (platform_id) REFERENCES Platform(platform_id) ON DELETE CASCADE
);