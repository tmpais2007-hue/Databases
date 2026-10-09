-- Week 5: schema updated after loading real-world data.
-- Every change compared to the week 3 schema is marked with "-- W5:"
-- and explained in README.md (section "Real data: changes and reflection").

-- W5: new table. Records where imported rows come from (source, date, license).
CREATE TABLE Data_Source (
    source_id INT PRIMARY KEY AUTO_INCREMENT,
    short_name VARCHAR(30) NOT NULL UNIQUE,
    title VARCHAR(255) NOT NULL,
    authors VARCHAR(255) NOT NULL,
    publisher VARCHAR(100) NOT NULL,
    url VARCHAR(255) NOT NULL UNIQUE,
    doi VARCHAR(100) UNIQUE,
    license VARCHAR(50) NOT NULL,
    published_on DATE NOT NULL,
    collection_country VARCHAR(50)
);

CREATE TABLE School (
    school_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL
);

CREATE TABLE Participant (
    participant_id INT PRIMARY KEY AUTO_INCREMENT,
    school_id INT,
    source_id INT,                  -- W5: NULL = entered directly by the project
    source_record_id VARCHAR(20),   -- W5: id of the row in the original dataset
    first_name VARCHAR(50),         -- W5: nullable, open datasets are anonymised
    last_name VARCHAR(50),          -- W5: nullable
    date_of_birth DATE,             -- W5: nullable
    age INT,                        -- W5: only stored when date_of_birth is unknown
    gender CHAR(1),
    grade_level INT,
    consent_date DATE,              -- W5: nullable, consent was handled by the original study
    FOREIGN KEY (school_id) REFERENCES School(school_id) ON DELETE SET NULL,
    FOREIGN KEY (source_id) REFERENCES Data_Source(source_id),
    UNIQUE (source_id, source_record_id),
    CHECK (grade_level BETWEEN 1 AND 12),
    CHECK (gender IN ('M', 'F', 'X')),                        -- W5
    CHECK (age BETWEEN 10 AND 25),                            -- W5
    CHECK (date_of_birth IS NULL OR age IS NULL),             -- W5: no derived duplicate
    CHECK (source_id IS NOT NULL OR (first_name IS NOT NULL   -- W5: own participants
        AND last_name IS NOT NULL AND consent_date IS NOT NULL))  -- still need these
);
CREATE TABLE Contact_Info (
    contact_id INT PRIMARY KEY AUTO_INCREMENT,  -- contact_id alone is unique
    participant_id INT NOT NULL,
    contact_type VARCHAR(30) NOT NULL,
    contact_value VARCHAR(100) NOT NULL,
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
    assessed_on DATE,               -- W5: nullable, survey date not published
    anxiety_score INT,
    depression_score INT,
    self_esteem_score INT,
    addiction_score INT,            -- W5: social media addiction scale (BSMAS)
    daily_sm_hours_min INT,         -- W5: self-reported daily social media use,
    daily_sm_hours_max INT,         --     stored as a range (max NULL = open-ended)
    intervention_type VARCHAR(50),
    FOREIGN KEY (participant_id) REFERENCES Participant(participant_id) ON DELETE CASCADE,
    FOREIGN KEY (assessor_id) REFERENCES Assessor(assessor_id) ON DELETE
    SET NULL,
    CHECK (anxiety_score BETWEEN 0 AND 100),                  -- W5
    CHECK (depression_score BETWEEN 0 AND 100),               -- W5
    CHECK (self_esteem_score BETWEEN 0 AND 100),              -- W5
    CHECK (addiction_score BETWEEN 0 AND 100),                -- W5
    CHECK (daily_sm_hours_min BETWEEN 0 AND 24),              -- W5
    CHECK (daily_sm_hours_max IS NULL
        OR daily_sm_hours_max BETWEEN daily_sm_hours_min AND 24)  -- W5
);
CREATE TABLE Platform (
    platform_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE,  -- W5: UNIQUE, both datasets name the same apps
    platform_type VARCHAR(20) NOT NULL DEFAULT 'app',  -- W5: 'app' or 'app_category'
    company_name VARCHAR(50),       -- W5: nullable, a category has no company
    minimum_age INT,                -- W5: nullable, a category has no age limit
    CHECK (platform_type IN ('app', 'app_category')),
    CHECK (platform_type = 'app_category'
        OR (company_name IS NOT NULL AND minimum_age IS NOT NULL))
);
-- W5: new table. Which platforms a participant uses (dataset B only
-- says yes/no per platform, without dates or minutes).
CREATE TABLE Platform_Use (
    participant_id INT,
    platform_id INT,
    PRIMARY KEY (participant_id, platform_id),
    FOREIGN KEY (participant_id) REFERENCES Participant(participant_id) ON DELETE CASCADE,
    FOREIGN KEY (platform_id) REFERENCES Platform(platform_id) ON DELETE CASCADE
);
CREATE TABLE Usage_Log (
    participant_id INT,
    platform_id INT,
    log_date DATE,
    screen_minutes INT NOT NULL,    -- W5: total minutes (was active + passive)
    passive_minutes INT,            -- W5: nullable, not every source splits this
    bedtime_minutes INT,            -- W5: minutes used in the hour before or after bedtime
    PRIMARY KEY (participant_id, platform_id, log_date),
    FOREIGN KEY (participant_id) REFERENCES Participant(participant_id) ON DELETE CASCADE,
    FOREIGN KEY (platform_id) REFERENCES Platform(platform_id) ON DELETE CASCADE,
    CHECK (screen_minutes BETWEEN 0 AND 1440),                -- W5
    CHECK (passive_minutes BETWEEN 0 AND screen_minutes),     -- W5
    CHECK (bedtime_minutes BETWEEN 0 AND screen_minutes)      -- W5
);
CREATE TABLE Daily_Log (
    participant_id INT,
    log_date DATE,
    sleep_hours DECIMAL(3, 1),
    sleep_quality INT,              -- W5: 1 (very bad) to 7 (very good)
    physical_activity_min INT,
    mood_rating INT,
    PRIMARY KEY (participant_id, log_date),
    FOREIGN KEY (participant_id) REFERENCES Participant(participant_id) ON DELETE CASCADE,
    CHECK (sleep_hours BETWEEN 0 AND 24),                     -- W5
    CHECK (sleep_quality BETWEEN 1 AND 7),                    -- W5
    CHECK (physical_activity_min BETWEEN 0 AND 1440),         -- W5
    CHECK (mood_rating BETWEEN 1 AND 5)                       -- W5
);
CREATE TABLE Incident (
    incident_id INT PRIMARY KEY AUTO_INCREMENT,
    participant_id INT NOT NULL,
    platform_id INT NOT NULL,
    reported_on DATE NOT NULL,
    incident_type VARCHAR(50) NOT NULL,
    severity INT NOT NULL,
    FOREIGN KEY (participant_id) REFERENCES Participant(participant_id) ON DELETE CASCADE,
    FOREIGN KEY (platform_id) REFERENCES Platform(platform_id) ON DELETE CASCADE,
    CHECK (severity BETWEEN 1 AND 5)                          -- W5
);
