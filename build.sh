#!/usr/bin/env bash
# Render build script: runs on every deploy.
set -o errexit

pip install -r requirements.txt

python manage.py collectstatic --no-input

# Creates migration files if the repo doesn't include them yet.
# (Once you've run `python manage.py makemigrations` locally and committed
#  bookings/migrations/0001_initial.py, this line becomes a harmless no-op.)
python manage.py makemigrations bookings --no-input
python manage.py migrate --no-input

# Adds Tamil Nadu cities, theatres, movies and the next 7 days of shows.
python manage.py seed_data

# Optional admin user: set DJANGO_SUPERUSER_USERNAME / _EMAIL / _PASSWORD in Render.
if [[ -n "${DJANGO_SUPERUSER_USERNAME:-}" && -n "${DJANGO_SUPERUSER_PASSWORD:-}" ]]; then
  python manage.py createsuperuser --no-input || true
fi
