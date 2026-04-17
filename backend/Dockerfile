FROM python:3.11

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# 🔥 install netcat (for waiting)
RUN apt-get update && apt-get install -y netcat-openbsd

COPY . .

# 🔥 wait for db → then migrate → then run
CMD ["sh", "-c", "until nc -z db 5432; do echo 'Waiting for DB...'; sleep 2; done; python manage.py migrate && python manage.py runserver 0.0.0.0:8000"]