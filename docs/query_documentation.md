# Query documentation

## Tom Piedboeuf (queries 5 and 6)

These two examples were written by **Tom Piedboeuf**.

Both queries match a participant's usage and sleep records on the same date.
They use the `All smartphone apps` category because the source's app categories
overlap. They require the real-data import (`data/real_data.sql`); the mock data
does not contain this category.

### Query 5: At least six hours of smartphone use

**Question answered:** On which days did participants use their smartphones for
at least six hours, and how long and how well did they sleep?

**Societal relevance:** The project concerns young people's digital habits and
wellbeing. These records can inform discussion of high smartphone use and
youth sleep.

**Interpretation:** The query lists matched participant-days. It does not show
that smartphone use causes a change in sleep.

### Query 6: Smartphone use around bedtime

**Question answered:** On which days did participants use their smartphones for
at least 30 minutes around bedtime, and how long and how well did they sleep?

**Societal relevance:** Use close to bedtime is a practical aspect of digital
wellbeing that students, families, and schools can discuss when considering
sleep routines. These records provide context for that discussion.

**Interpretation:** The query only lists days with at least 30 minutes recorded
around bedtime. It does not show that bedtime use causes a change in sleep.

## Peter Leshkov (queries 7 and 8)

These two examples were written by **Peter Leshkov**. They need the real data (`data/real_data.sql`).

### Query 7: Social media time and addiction risk

**Question answered:** Do people who spend more time on social media score
higher on addiction and anxiety, and lower on self-esteem?

**Societal relevance:** Schools and parents often set screen-time limits. This
shows which group of young people is most at risk and should be helped first.

**Interpretation:** More social media time goes with more addiction risk and
lower self-esteem. The last two groups are small. This shows a link, not a cause.

### Query 8: More bedtime phone use than usual

**Question answered:** Do participants sleep worse on nights when they use their
phone around bedtime more than they usually do?

**Societal relevance:** "No phone in bed" is common advice for teenagers. This
checks if it matters for the same person, night by night.

**Interpretation:** Sleep quality is a bit lower on those nights. Sleep hours
look higher, but `sleep_hours` is really time in bed, which includes phone use in bed.
