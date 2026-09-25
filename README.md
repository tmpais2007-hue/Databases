# Practical Assignment 2

## Team
- Peter Leshkov
- Tom Piedboeuf
- Tiago Cornieles Pais

## Project description
This project tracks student wellbeing data and digital platform usage to monitor mental health, daily habits, and online activity patterns across schools and participants.

## Database
This project uses MySQL.

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
- crud.sql - Basic INSERT, SELECT, UPDATE and DELETE operations
- queries.sql - Advanced SQL queries

## How to run

1. Install MySQL
2. Create a database
3. Run schema.sql
4. Run data.sql
5. Run crud.sql
6. Run queries.sql