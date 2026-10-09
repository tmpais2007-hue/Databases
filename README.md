# Student Wellbeing and Digital Habits Database

Repository: https://github.com/tmpais2007-hue/Databases

## Team
- Peter Leshkov
- Tom Piedboeuf
- Tiago Cornieles Pais

## Societal problem statement

Teenagers spend many hours a day on their smartphones and on social media.
Parents, schools and health organisations worry that this harms their sleep and
mental wellbeing, for example through social media addiction, anxiety and low
self-esteem. Advice such as screen-time limits or "no phone in bed" is common,
but it is hard to check against real data, because screen time, sleep and
wellbeing are usually measured in separate studies.

This database brings these measurements together in one structure: participants,
their daily phone and platform use, their sleep, and their wellbeing scores, with
every real record linked to its original open dataset. The queries use it to
ask, for example:

- Do young people who spend more time on social media score higher on addiction
  and anxiety? (queries 7 and 9)
- Do they sleep worse after heavy phone use, or after phone use around bedtime?
  (queries 4, 5, 6 and 8)
- Is phone use and sleep different on school nights? (query 10)

The answers can help schools and families decide where prevention and advice
are most needed. The data shows patterns, not causes.

## Database
This project uses MySQL (tested on 8.4).

## Normalization
This database follows standard normalization principles to reduce redundancy and improve data integrity.

### First Normal Form (1NF)
• The Problem: The unnormalized table violates 1NF because the Contact Details column contains non-atomic, composite values. Multiple pieces of information, such as a phone number and an email address, are packed into a single cell separated by a semicolon (e.g., 512-555-0192; alice@northwood.edu).
• The Fix: To achieve 1NF, every table cell must contain a single, indivisible scalar value. This was resolved by extracting the contact details into a separate CONTACT_INFO table where each row holds a single, atomic contact value (either a distinct phone or email) linked via a foreign key (Participant ID (FK)).

### Second Normal Form (2NF)
• The Problem: 2NF states that a table must be in 1NF and all non-key attributes must be fully dependent on the entire primary key, eliminating partial dependencies. In a flat master table, school attributes like School Name, City, and Country depend only on the school identity, not on the individual participant. This caused massive data redundancy, where school details were needlessly repeated for every single student enrolled.
• The Fix: The school data was extracted into an independent SCHOOL table with School ID as its primary key. The participant table now only references the school using a foreign key (School ID (FK)), ensuring that school attributes depend only on their own primary key.

### Third Normal Form (3NF)
• The Problem: 3NF requires a relation to be in 2NF and free of transitive dependencies, meaning that non-key attributes must not depend on other non-key attributes. In unnormalized data, location fields (City, Country) are transitively dependent on attributes other than the primary identifier, which creates severe update anomalies, such as having to update multiple rows if a school's city or country designation changes.
• The Fix: By cleanly separating the relational entities (SCHOOL, PARTICIPANT, and CONTACT_INFO), transitive dependencies are eliminated. Non-key attributes now depend exclusively on their respective table's primary key, ensuring database integrity and preventing update anomalies.

The normalization diagram is included here: [Normalization.jpg](Normalization.jpg)

### Why the real-data schema is normalized through 3NF

- **1NF:** Each field stores a single value; platform use and dated usage are
  recorded as separate rows rather than packed into participant records.
- **2NF:** In tables with composite keys, such as `Usage_Log` and `Daily_Log`,
  each measurement depends on the complete key (participant, platform and date,
  or participant and date), not just part of it.
- **3NF:** Descriptive details are kept with their entities, such as school
  details in `School`, platform details in `Platform`, and source details in
  `Data_Source`. Other tables refer to them by keys instead of repeating those
  details, avoiding transitive dependencies.

## Repository structure

- schema.sql - Creates the database tables and constraints
- data.sql - Inserts mock data (fictional people, for testing only)
- bad_data.sql - Invalid rows that the constraints must reject (every statement should fail)
- data/raw/ - Real-world datasets (original files, CC BY 4.0)
- data/import_real_data.py - Cleans the raw data and generates data/real_data.sql
- data/real_data.sql - Inserts the real-world data
- crud.sql - Basic INSERT, SELECT, UPDATE and DELETE operations
- queries.sql - Advanced SQL queries (authors below)
- query_documentation.md - Question answered, societal relevance and interpretation of queries 5-10
- LICENSE - Licence of the data (CC BY 4.0)

## How to run

1. Install MySQL 8.4
2. Create a database
3. Run schema.sql
4. Run data.sql (optional, mock data)
5. Run data/real_data.sql (to rebuild it from the raw files: `python data/import_real_data.py`)
6. Run crud.sql
7. Run queries.sql
8. Run bad_data.sql (optional: shows that the constraints reject invalid data, so each statement gives an error)

Instead of steps 3-5, you can load the MySQL dump from Zenodo (see Published dataset).

## Queries

| Query | Topic | Author |
|---|---|---|
| 1-4 | Week 3 group queries, adapted to the real data | Peter Leshkov, Tom Piedboeuf |
| 5, 6 | Heavy smartphone use / bedtime use and sleep | Tom Piedboeuf |
| 7, 8 | Social media time and addiction risk / bedtime use compared to own habit | Peter Leshkov |
| 9, 10 | Number of platforms and addiction / school nights vs weekend nights | Tiago Cornieles Pais |

Queries 5-10 are explained in [query_documentation.md](query_documentation.md).

## Real-world data sources

This project includes two real datasets used to populate the database.

### Dataset A: Siebers et al. (2024)
- Source: University of Amsterdam / Amsterdam University of Applied Sciences (Figshare)
- Title: "Dataset belonging to Siebers et al. (2024) Adolescents' digital nightlife: The comparative effects of day- and nighttime smartphone use on sleep quality"
- Publication date: 2024-07-29
- License: CC BY 4.0
- DOI: 10.21942/uva.26395903.v2
- Country: Netherlands

### Dataset B: Scafuto & Ciacchini (2023)
- Source: Mendeley Data (Universita degli Studi di Pisa)
- Title: "Social Media Addiction dataset (version 2)"
- Publication date: 2023-01-30
- License: CC BY 4.0
- DOI: 10.17632/vftw9cz723.2
- Country: Italy

Both datasets are openly licensed under the Creative Commons Attribution 4.0 International License.

## Data cleaning for real data

**1. How is missing data reported?**
- Dataset A: `-999` fills whole rows. Nights without a survey are just absent. These rows are skipped.
- Dataset B: no missing-value code, 0 empty cells. Survey date, participant id and school were not collected, so they are stored as `NULL`.

**2. How are dates formatted?**
- Dataset A: ISO dates (`2020-06-02`) and UTC timestamps (`2020-06-01T23:30:00Z`). Usage files only have `study_day` 1-21, converted to real dates (day 1 = 2020-06-01). Dutch weekday names dropped. Durations in decimal hours converted to minutes.
- Dataset B: no dates. Age in whole years goes into the `age` column. Daily social media time is a code 0-5, stored as an hour range.

**3. Are there duplicate records?**
- Dataset A: none.
- Dataset B: 37 exact duplicate rows removed.

**4. Are there inconsistent naming conventions?**
- Dataset A: `game.csv` has its columns in a different order. Category files renamed to descriptive platform names.
- Dataset B: header typos and trailing spaces. Version 1 and version 2 use different column names. `Whatsapp` → `WhatsApp`, `Twitter` → `X (Twitter)`, sex `1`/`2` → `M`/`F`.

## Real data: changes and reflection

### What we imported

`python data/import_real_data.py` turns the raw files in `data/raw/` into `data/real_data.sql`.

- **Dataset A** (Siebers et al., 2024): 156 participants, 1,859 sleep rows, 6,185 usage rows. About half of the usage rows were `-999` (missing) and were skipped.
- **Dataset B** (Scafuto & Ciacchini, 2023): 221 participants after removing 37 duplicate rows.

### Schema changes

All changes are marked `-- W5:` in `schema.sql`.

- `Data_Source` table: every real row links to its source and licence.
- Names, birth date and consent date are now optional, because open data is anonymised.
- `Usage_Log` stores total `screen_minutes` and `bedtime_minutes` instead of active/passive minutes.
- `Platform_Use` table: dataset B only says *which* platforms someone uses.
- New columns for addiction score, daily social media hours and sleep quality.
- `CHECK` constraints catch impossible values such as `-999`.

### What broke in the week 3 queries

- Grouping by school returned nothing for real participants: they have no school.
- Ranking platforms by incidents ignored the real data: it has no incidents.
- Screen-time thresholds (75/90 min) were too low: the real average is 379 min/day. Adding up the app categories counted minutes twice (719 min/day).

### Reflection

- **Mock data hid problems.** It was made to fit our schema. Real data has no names, schools or exact dates.
- **Same column, different scales.** Mock anxiety scores are 0-100, real ones 20-80. Mixing them gives averages that mean nothing, so queries 2, 7 and 9 use dataset B only.
- **`sleep_hours` is really time in bed**, so phone use in bed looks like more sleep (query 8).
- **The datasets can't be linked.** They cover different people, so we can't study screen time, sleep and wellbeing for the same person. Our queries show patterns, not causes.

### Future work

- Keep mock and real data apart.
- Store the scale (min/max) with each score.
- Rename `sleep_hours` to `time_in_bed_hours`.
- Find a dataset with schools that follows the same students over time.

## Published dataset

A MySQL dump of the database (schema + real data only) is published on Zenodo: **DOI: [10.5281/zenodo.23262562](https://doi.org/10.5281/zenodo.23262562)**

- **No personal data:** the dump contains only the two anonymised open datasets. Participants have no names,
  birth dates, contact details or schools, only a study id, age, gender and their answers. The mock data
  (fictional people in `data.sql`) is not included.
- **Licence:** CC BY 4.0, the same licence as both source datasets. Anyone reusing it must credit
  Siebers et al. (2024) and Scafuto & Ciacchini (2023), as listed above.
