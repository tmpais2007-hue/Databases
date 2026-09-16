CREATE TABLE School (
    school_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    city VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE Participant (
    participant_id INT PRIMARY KEY AUTO_INCREMENT,
    school_id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    date_of_birth DATE,
    gender CHAR(1),
    grade_level INT,
    consent_date DATE,
    FOREIGN KEY (school_id) REFERENCES School(school_id) ON DELETE SET NULL
);

CREATE TABLE Contact_Info (
    contact_id INT,
    participant_id INT NOT NULL,
    contact_type VARCHAR(30),
    contact_value VARCHAR(100),
    PRIMARY KEY (contact_id, participant_id),
    FOREIGN KEY (participant_id)
    REFERENCES Participant(participant_id)
    ON DELETE CASCADE
);

CREATE TABLE Assessor (
    assessor_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    role VARCHAR(50),
    organisation VARCHAR(50)
);

CREATE TABLE Assessment (
    assessment_id INT PRIMARY KEY AUTO_INCREMENT,
    participant_id INT,
    assessor_id INT,
    assessed_on DATE,
    anxiety_score INT,
    depression_score INT,
    self_esteem_score INT,
    intervention_type INT,
    FOREIGN KEY (participant_id) REFERENCES Participant(participant_id) ON DELETE CASCADE,
    FOREIGN KEY (assessor_id) REFERENCES Assessor(assessor_id) ON DELETE SET NULL
);