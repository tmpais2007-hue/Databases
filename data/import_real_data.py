"""Clean the two raw datasets in data/raw/ and write data/real_data.sql.

Run from the repository root:  python data/import_real_data.py
Only the Python standard library is used. The cleaning steps are explained
in docs/week5_real_data.md; the counts printed at the end are quoted there.
"""
import collections
import csv
import datetime as dt
import re
import xml.etree.ElementTree as ET
import zipfile
from pathlib import Path

RAW = Path(__file__).parent / "raw"
OUT = Path(__file__).parent / "real_data.sql"
MISSING = "-999"  # dataset A marks missing values with -999

stats = collections.Counter()


def sql(value):
    if value is None:
        return "NULL"
    if isinstance(value, (int, float)):
        return str(value)
    return "'" + str(value).replace("'", "''") + "'"


def row(*values):
    return "(" + ", ".join(sql(v) for v in values) + ")"


def insert(table, columns, rows):
    if not rows:
        return []
    return [f"INSERT INTO {table} ({', '.join(columns)}) VALUES",
            ",\n".join(rows) + ";"]


def parse_utc(text):
    # e.g. 2020-06-01T22:30:00Z
    return dt.datetime.fromisoformat(text.replace("Z", "+00:00"))


# Dataset A: Siebers et al. (2024), smartphone use and sleep (Netherlands)
def load_siebers():
    folder = RAW / "siebers2024"
    # The categories overlap (one app can be in two of them), so the daily
    # total must come from phone.csv and never from summing the categories.
    categories = {"phone": "All smartphone apps",
                  "social": "Social media apps",
                  "video": "Video player apps",
                  "game": "Game apps"}

    sleep = {}  # (user, log_date) -> (sleep_hours, sleep_quality)
    with open(folder / "timeframes.csv", newline="") as f:
        for r in csv.DictReader(f):
            stats["A timeframes rows"] += 1
            # The survey on date_res asks about the night before, so the
            # night (and the day of phone use before it) belongs to date_res - 1.
            log_date = dt.date.fromisoformat(r["date_res"]) - dt.timedelta(days=1)
            hours = (parse_utc(r["wt_today"]) - parse_utc(r["bt_yes"])).total_seconds() / 3600
            key = (r["user_id"], log_date)
            if key in sleep:
                stats["A duplicate sleep rows removed"] += 1
                continue
            sleep[key] = (round(hours, 1), int(r["sleep_qual"]))

    # study_day 1 = survey on 2020-06-02 = log_date 2020-06-01 for every user
    # (checked: all 1,806 non-missing phone.csv days match timeframes.csv on
    # sleep quality with this offset).
    day_one = dt.date(2020, 6, 1)
    usage = collections.defaultdict(list)  # user -> rows
    for key, name in categories.items():
        with open(folder / f"{key}.csv", newline="") as f:
            seen = set()
            for r in csv.DictReader(f):  # game.csv has its columns in another order
                stats[f"A {key}.csv rows"] += 1
                if r["daytime_use"] == MISSING:
                    stats[f"A {key}.csv rows with -999 (skipped)"] += 1
                    continue
                if (r["user_id"], r["study_day"]) in seen:
                    stats[f"A {key}.csv duplicate rows removed"] += 1
                    continue
                seen.add((r["user_id"], r["study_day"]))
                log_date = day_one + dt.timedelta(days=int(r["study_day"]) - 1)
                q = sleep.get((r["user_id"], log_date))
                if q is None or q[1] != int(r["sleep_qual"]):
                    raise ValueError(f"{key}.csv day not aligned: {r}")
                day, pre, post = (float(r[c]) for c in ("daytime_use", "prebed_use", "postbed_use"))
                screen = round((day + pre + post) * 60)  # hours -> minutes
                bedtime = min(round((pre + post) * 60), screen)
                usage[r["user_id"]].append((name, log_date, screen, bedtime))

    users = sorted({u for u, _ in sleep} | set(usage), key=int)
    stats["A participants"] = len(users)

    out = ["-- Dataset A: Siebers et al. (2024), CC BY 4.0",
           "INSERT INTO Data_Source (short_name, title, authors, publisher, url, doi, license, published_on, collection_country) VALUES",
           row("Siebers2024",
               "Dataset belonging to Siebers et al. (2024) Adolescents' digital nightlife: "
               "The comparative effects of day- and nighttime smartphone use on sleep quality",
               "T. Siebers; I. Beyens; S. E. Baumgartner; P. M. Valkenburg",
               "University of Amsterdam / Amsterdam University of Applied Sciences (Figshare)",
               "https://uvaauas.figshare.com/articles/dataset/Dataset_belonging_to_Siebers_et_al_2024_Adolescents_digital_nightlife_The_comparative_effects_of_day-_and_nighttime_smartphone_use_on_sleep_quality/26395903",
               "10.21942/uva.26395903.v2", "CC BY 4.0", "2024-07-29", "Netherlands") + ";",
           "SET @src = LAST_INSERT_ID();",
           "INSERT INTO Platform (name, platform_type) VALUES",
           ",\n".join(row(n, "app_category") for n in categories.values()),
           "ON DUPLICATE KEY UPDATE name = name;"]
    for i, name in enumerate(categories.values()):
        out.append(f"SET @cat{i} = (SELECT platform_id FROM Platform WHERE name = {sql(name)});")
    cat_var = {name: f"@cat{i}" for i, name in enumerate(categories.values())}

    for u in users:
        out.append("")
        out.append("INSERT INTO Participant (source_id, source_record_id) VALUES (@src, " + sql(u) + ");")
        out.append("SET @p = LAST_INSERT_ID();")
        out += insert("Daily_Log", ["participant_id", "log_date", "sleep_hours", "sleep_quality"],
                      [f"(@p, {sql(d.isoformat())}, {h}, {q})"
                       for (uu, d), (h, q) in sorted(sleep.items()) if uu == u])
        out += insert("Usage_Log", ["participant_id", "platform_id", "log_date", "screen_minutes", "bedtime_minutes"],
                      [f"(@p, {cat_var[n]}, {sql(d.isoformat())}, {s}, {b})"
                       for n, d, s, b in usage[u]])
        stats["A Daily_Log rows"] += sum(1 for uu, _ in sleep if uu == u)
        stats["A Usage_Log rows"] += len(usage[u])
    return out


# Dataset B: Scafuto & Ciacchini (2023), social media addiction (Italy)
NS = "{http://schemas.openxmlformats.org/spreadsheetml/2006/main}"


def read_xlsx(path):
    """Minimal .xlsx reader (first sheet) so no extra packages are needed."""
    z = zipfile.ZipFile(path)
    strings = [''.join(t.text or '' for t in si.iter(NS + 't'))
               for si in ET.fromstring(z.read('xl/sharedStrings.xml'))]
    rows = []
    for r in ET.fromstring(z.read('xl/worksheets/sheet1.xml')).iter(NS + 'row'):
        cells = {}
        for c in r.findall(NS + 'c'):
            letters = re.match(r'[A-Z]+', c.get('r')).group()
            col = 0
            for ch in letters:
                col = col * 26 + ord(ch) - 64
            v = c.find(NS + 'v')
            if v is not None:
                cells[col - 1] = strings[int(v.text)] if c.get('t') == 's' else v.text
        rows.append([cells.get(i) for i in range(max(cells) + 1)] if cells else [])
    return rows


def load_scafuto():
    rows = read_xlsx(RAW / "scafuto2023" / "Database COMPLETO corretto 23_01_23.xlsx")
    header = [h.strip() for h in rows[0]]  # some headers end with a space
    col = {h: i for i, h in enumerate(header)}

    # Version 2 only has numeric codes. The labels come from version 1
    # ("social media addiction 14_10_22.xlsx"), which has code + label columns.
    gender = {"1": "M", "2": "F"}
    sm_hours = {"0": (0, 2), "1": (2, 4), "2": (4, 6), "3": (6, 8), "4": (8, 10), "5": (10, None)}
    platforms = {"Whatsapp": ("WhatsApp", "Meta", 13),
                 "Facebook": ("Facebook", "Meta", 13),
                 "Instagram": ("Instagram", "Meta", 13),
                 "Twitter": ("X (Twitter)", "X Corp.", 13),
                 "Snapchat": ("Snapchat", "Snap Inc.", 13),
                 "TikTok": ("TikTok", "ByteDance", 13)}
    # "Other social media" is not a platform, so it is not imported.

    seen = set()
    people = []
    for excel_row, r in enumerate(rows[1:], start=2):
        stats["B rows"] += 1
        if any(v in (None, "", " ") for v in r):
            stats["B rows with empty cells (skipped)"] += 1
            continue
        if tuple(r) in seen:
            stats["B exact duplicate rows removed"] += 1
            continue
        seen.add(tuple(r))
        if r[col["Sex"]] not in gender or r[col["Time spent on social media"]] not in sm_hours:
            raise ValueError(f"unexpected code in row {excel_row}")
        people.append((excel_row, r))
    stats["B participants"] = len(people)

    out = ["", "-- Dataset B: Scafuto & Ciacchini (2023), CC BY 4.0",
           "INSERT INTO Data_Source (short_name, title, authors, publisher, url, doi, license, published_on, collection_country) VALUES",
           row("Scafuto2023", "Social Media Addiction dataset (version 2)",
               "F. Scafuto; R. Ciacchini", "Mendeley Data (Universita degli Studi di Pisa)",
               "https://data.mendeley.com/datasets/vftw9cz723/2",
               "10.17632/vftw9cz723.2", "CC BY 4.0", "2023-01-30", "Italy") + ";",
           "SET @src = LAST_INSERT_ID();",
           "INSERT INTO Platform (name, platform_type, company_name, minimum_age) VALUES",
           ",\n".join(row(n, "app", c, a) for n, c, a in platforms.values()),
           "ON DUPLICATE KEY UPDATE name = name;"]
    for i, (name, _, _) in enumerate(platforms.values()):
        out.append(f"SET @pl{i} = (SELECT platform_id FROM Platform WHERE name = {sql(name)});")

    participants, assessments, uses = [], [], []
    for excel_row, r in people:
        rid = str(excel_row)
        participants.append(f"(@src, {sql(rid)}, {int(r[col['Age']])}, {sql(gender[r[col['Sex']]])})")
        lo, hi = sm_hours[r[col["Time spent on social media"]]]
        pid = f"(SELECT participant_id FROM Participant WHERE source_id = @src AND source_record_id = {sql(rid)})"
        # anxiety = trait anxiety (STAI-Y2, 20-80); self-esteem = RSES (0-30);
        # addiction = BSMAS (6-30). Scale totals from the corrected version 2.
        assessments.append(f"({pid}, {int(r[col['TOT_STAI-Y2']])}, {int(r[col['TOT_RSES']])}, "
                           f"{int(r[col['TOT_BSMAS']])}, {lo}, {sql(hi)})")
        for i, key in enumerate(platforms):
            if r[col[key]] == "1":
                uses.append(f"({pid}, @pl{i})")
    stats["B Assessment rows"] = len(assessments)
    stats["B Platform_Use rows"] = len(uses)

    out += insert("Participant", ["source_id", "source_record_id", "age", "gender"], participants)
    out += insert("Assessment", ["participant_id", "anxiety_score", "self_esteem_score", "addiction_score",
                                 "daily_sm_hours_min", "daily_sm_hours_max"], assessments)
    out += insert("Platform_Use", ["participant_id", "platform_id"], uses)
    return out


def main():
    lines = ["-- Generated by data/import_real_data.py - do not edit by hand.",
             "-- Run after schema.sql (data.sql with the mock data is optional).",
             "SET NAMES utf8mb4;", "START TRANSACTION;", ""]
    lines += load_siebers()
    lines += load_scafuto()
    lines += ["", "COMMIT;", ""]
    OUT.write_text("\n".join(lines), encoding="utf-8")
    for k, v in stats.items():
        print(f"{k}: {v}")
    print(f"written: {OUT}")


if __name__ == "__main__":
    main()
