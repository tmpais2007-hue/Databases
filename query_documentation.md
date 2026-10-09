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


## Tiago Cornieles Pais (queries 9 and 10)

These two examples were written by **Tiago Cornieles Pais**.
Query 9 uses dataset B and query 10 uses dataset A, so both need the real data
(`data/real_data.sql`).

### Query 9: Number of platforms and addiction risk

**Question answered:** Do young people who use more different social media
platforms score higher on social media addiction?

**Societal relevance:** Advice for parents and schools is usually about *how
long* young people are online. This checks whether *how many* platforms they
are on matters too, for example because more apps mean more notifications
pulling them back to the phone.

**Interpretation:** The addiction score goes up steadily with the number of
platforms, from 11.3 (0-1 platforms) to 13.6 (4+ platforms), and the share at
risk (score 19+) rises from 3.7% to about 11%. Self esteem shows no clear
pattern. People on more platforms also spend more hours on social media, so
part of this link may just be time. The 0-1 and 4+ groups are small, and this
shows a link, not a cause.

### Query 10: School nights and weekend nights

**Question answered:** Do participants use their phone more, and spend less time
in bed, on school nights than on weekend nights?

**Societal relevance:** Teenagers need 8-10 hours of sleep, and school nights
are when they can least afford to lose it. If school nights look worse, that is
where phone rules at home and sleep advice from schools should focus.

**Interpretation:** On school nights participants use their phone a bit more in
total and spend about 20 minutes less in bed. Phone use around bedtime and sleep
quality are almost the same. So the difference is mostly how long they stay in
bed, not what they do just before sleeping. As in query 8, `sleep_hours` is time
in bed, not real sleep. The data is from June 2020, during the COVID-19 period,
so school routines may not have been normal.

