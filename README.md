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

## Repository structure

- schema.sql - Creates the database tables and constraints
- data.sql - Inserts mock data
- data/raw/ - Real-world datasets (original files, CC BY 4.0)
- data/import_real_data.py - Cleans the raw data and generates data/real_data.sql
- data/real_data.sql - Inserts the real-world data
- crud.sql - Basic INSERT, SELECT, UPDATE and DELETE operations
- queries.sql - Advanced SQL queries
- docs/week5_real_data.md - Week 5: data sources, cleaning steps, schema changes, query results and normalization check

## How to run

1. Install MySQL
2. Create a database
3. Run schema.sql
4. Run data.sql (optional, mock data)
5. Run data/real_data.sql (to rebuild it from the raw files: `python data/import_real_data.py`)
6. Run crud.sql
7. Run queries.sql
