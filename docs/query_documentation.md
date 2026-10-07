# Query documentation

These two examples were written by **Tom Piedboeuf**.

Both queries match a participant's usage and sleep records on the same date.
They use the `All smartphone apps` category because the source's app categories
overlap. They require the real-data import (`data/real_data.sql`); the mock data
does not contain this category.

## Query 5: At least six hours of smartphone use

**Question answered:** On which days did participants use their smartphones for
at least six hours, and how long and how well did they sleep?

**Societal relevance:** The project concerns young people's digital habits and
wellbeing. These records can inform discussion of high smartphone use and
youth sleep.

**Interpretation:** The query lists matched participant-days. It does not show
that smartphone use causes a change in sleep.

## Query 6: Smartphone use around bedtime

**Question answered:** On which days did participants use their smartphones for
at least 30 minutes around bedtime, and how long and how well did they sleep?

**Societal relevance:** Use close to bedtime is a practical aspect of digital
wellbeing that students, families, and schools can discuss when considering
sleep routines. These records provide context for that discussion.

**Interpretation:** The query only lists days with at least 30 minutes recorded
around bedtime. It does not show that bedtime use causes a change in sleep.
