# Practical Assignment 2

Repository: https://github.com/tmpais2007-hue/Databases

## Team
- Peter Leshkov
- Tom Piedboeuf
- Tiago Cornieles Pais

## Project description
This project tracks student wellbeing data and digital platform usage to monitor mental health, daily habits, and online activity patterns across schools and participants.

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

## Repository structure

- schema.sql - Creates the database tables and constraints
- data.sql - Inserts mock data
- data/raw/ - Real-world datasets (original files, CC BY 4.0)
- data/import_real_data.py - Cleans the raw data and generates data/real_data.sql
- data/real_data.sql - Inserts the real-world data
- crud.sql - Basic INSERT, SELECT, UPDATE and DELETE operations
- queries.sql - Advanced SQL queries
- docs/week5_real_data.md - Week 5: data sources, cleaning steps, schema changes, query results and normalization check

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

## How to run

1. Install MySQL
2. Create a database
3. Run schema.sql
4. Run data.sql (optional, mock data)
5. Run data/real_data.sql (to rebuild it from the raw files: `python data/import_real_data.py`)
6. Run crud.sql
7. Run queries.sql
