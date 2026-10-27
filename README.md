# CineBook TN 🎬

A BookMyShow-style movie ticket booking web app built with **Django**.
Tamil Nadu cities, theatres in each city, seat selection, prices in **₹ (INR)**.

## Features
- 11 Tamil Nadu cities (Chennai, Coimbatore, Madurai, Tiruchirappalli, Salem, Tirunelveli, Erode, Tiruppur, Vellore, Thoothukudi, Thanjavur) with a city switcher
- Movie listing with search and language filter
- Date tabs (next 7 days) and showtimes grouped by theatre
- Interactive seat map (Silver / Gold / Premium rows) – max 8 seats per booking
- Price breakup in ₹ with Indian number grouping (₹1,23,456), convenience fee and 18% GST on the fee
- Sign up / login / logout, "My bookings", printable ticket with booking ID
- Cancel up to 2 hours before the show (seats are released)
- Double booking is impossible: a database unique constraint on (show, seat)
- Django admin to manage cities, theatres, movies, shows, bookings
- **Payments are simulated** (demo only). Plug in Razorpay/Cashfree etc. in `bookings/services.py -> create_booking`.

## Project layout
```
config/            Django settings, urls, wsgi
bookings/          models, views, services, admin, seed command
templates/         HTML (base, home, movie, seats, checkout, tickets, auth)
static/            css/style.css, js/seats.js
build.sh           Render build script
render.yaml        Render Blueprint (web service + Postgres)
```

## Run locally
```bash
python -m venv .venv
source .venv/bin/activate          # Windows: .venv\Scripts\activate
pip install -r requirements.txt

python manage.py makemigrations bookings
python manage.py migrate
python manage.py seed_data         # cities, theatres, movies, 7 days of shows
python manage.py createsuperuser   # optional, for /admin/
python manage.py runserver
```
Open http://127.0.0.1:8000/

Run `python manage.py seed_data` again any day to add the next days' shows.

## Push to GitHub
```bash
# create an empty repo on github.com first (no README), then:
git remote add origin https://github.com/<your-username>/<repo-name>.git
git branch -M main
git push -u origin main
```
Tip: after your first local `makemigrations`, commit the generated
`bookings/migrations/0001_initial.py` so deployments use the same migration.

## Deploy on Render
**Option A – Blueprint (easiest):**
1. Push the repo to GitHub.
2. Render dashboard → **New → Blueprint** → select the repo.
3. Enter the admin username/email/password when asked, then **Apply**.

**Option B – manual:**
1. New → **PostgreSQL** (free) and copy its *Internal Database URL*.
2. New → **Web Service** → your repo. Runtime *Python*.
   - Build command: `./build.sh`
   - Start command: `gunicorn config.wsgi:application`
3. Environment variables: `PYTHON_VERSION=3.12.8`, `DEBUG=False`, `SECRET_KEY=<long random string>`, `DATABASE_URL=<internal db url>`, and optionally `DJANGO_SUPERUSER_USERNAME`, `DJANGO_SUPERUSER_EMAIL`, `DJANGO_SUPERUSER_PASSWORD`.

Notes: Render's free web service sleeps after inactivity (first load can take ~1 minute) and the free Postgres database expires after 30 days – upgrade or recreate it for long-term use.

## Environment variables
| Name | Purpose | Default |
|------|---------|---------|
| `DEBUG` | `True`/`False` | `True` |
| `SECRET_KEY` | Django secret | insecure dev key |
| `DATABASE_URL` | Postgres URL | local SQLite |
| `EXTRA_ALLOWED_HOSTS` | Comma separated custom domains | – |

All movies, theatres and posters are fictional demo data.
