# Real data: changes and reflection

## What we imported

`python data/import_real_data.py` turns the raw files in `data/raw/` into `data/real_data.sql`.

- **Dataset A** (Siebers et al., 2024): 156 participants, 1,859 sleep rows, 6,185 usage rows. About half of the usage rows were `-999` (missing) and were skipped.
- **Dataset B** (Scafuto & Ciacchini, 2023): 221 participants after removing 37 duplicate rows.

## Schema changes

All changes are marked `-- W5:` in `schema.sql`.

- `Data_Source` table: every real row links to its source and licence.
- Names, birth date and consent date are now optional, because open data is anonymised.
- `Usage_Log` stores total `screen_minutes` and `bedtime_minutes` instead of active/passive minutes.
- `Platform_Use` table: dataset B only says *which* platforms someone uses.
- New columns for addiction score, daily social media hours and sleep quality.
- `CHECK` constraints catch impossible values such as `-999`.

## What broke in the week 3 queries

- Grouping by school returned nothing for real participants: they have no school.
- Ranking platforms by incidents ignored the real data: it has no incidents.
- Screen-time thresholds (75/90 min) were too low: the real average is 379 min/day. Adding up the app categories counted minutes twice (719 min/day).

## Reflection

- **Mock data hid problems.** It was made to fit our schema. Real data has no names, schools or exact dates.
- **Same column, different scales.** Mock anxiety scores are 0-100, real ones 20-80. Query 2 still mixes them, so its average means little. Queries 7 and 8 use one source only.
- **`sleep_hours` is really time in bed**, so phone use in bed looks like more sleep (query 8).
- **The datasets can't be linked.** They cover different people, so we can't study screen time, sleep and wellbeing for the same person. Our queries show patterns, not causes.

## Future work

- Keep mock and real data apart.
- Store the scale (min/max) with each score.
- Rename `sleep_hours` to `time_in_bed_hours`.
- Find a dataset with schools that follows the same students over time.
