.PHONY: help setup dev prod build up down logs migrate shell

help:
	@echo "AI Prompt Library - Available Commands"
	@echo ""
	@echo "Setup & Installation:"
	@echo "  make setup      - Initial setup (create .env from example)"
	@echo ""
	@echo "Development:"
	@echo "  make dev        - Start development environment"
	@echo "  make build      - Build Docker images"
	@echo "  make up         - Start containers"
	@echo "  make down       - Stop containers"
	@echo "  make logs       - View container logs"
	@echo ""
	@echo "Database:"
	@echo "  make migrate    - Run Django migrations"
	@echo "  make shell      - Access Django shell"
	@echo ""
	@echo "Production:"
	@echo "  make prod-up    - Start production environment"
	@echo "  make prod-down  - Stop production environment"
	@echo "  make backup     - Backup database"

setup:
	@if [ ! -f .env ]; then \
		cp .env.example .env; \
		echo ".env file created. Please edit it with your settings."; \
	else \
		echo ".env file already exists."; \
	fi

dev: setup
	docker-compose -f docker-compose.yml up -d --build
	@echo "Development environment started!"
	@echo "Frontend: http://localhost:4200"
	@echo "Backend:  http://localhost:8000"
	@echo "Admin:    http://localhost:8000/admin"

prod-up: setup
	docker-compose -f docker-compose.prod.yml up -d --build
	docker-compose -f docker-compose.prod.yml exec -T backend python manage.py migrate
	@echo "Production environment started!"

prod-down:
	docker-compose -f docker-compose.prod.yml down

build:
	docker-compose build --no-cache

up:
	docker-compose up -d

down:
	docker-compose down

logs:
	docker-compose logs -f

logs-backend:
	docker-compose logs -f backend

logs-frontend:
	docker-compose logs -f frontend

logs-db:
	docker-compose logs -f db

migrate:
	docker-compose exec backend python manage.py migrate

shell:
	docker-compose exec backend python manage.py shell

createsuperuser:
	docker-compose exec backend python manage.py createsuperuser

collectstatic:
	docker-compose exec backend python manage.py collectstatic --noinput

backup:
	@mkdir -p backups
	docker-compose exec -T db pg_dump -U postgres prompts > backups/backup_$(shell date +%Y%m%d_%H%M%S).sql
	@echo "Database backed up successfully!"

restore-backup:
	@if [ -z "$(FILE)" ]; then \
		echo "Usage: make restore-backup FILE=backups/backup_YYYYMMDD_HHMMSS.sql"; \
	else \
		docker-compose exec -T db psql -U postgres prompts < $(FILE); \
		echo "Database restored from $(FILE)"; \
	fi

clean:
	docker-compose down -v
	find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name "*.pyc" -delete
	@echo "Cleaned up!"

test:
	docker-compose exec backend python manage.py test

requirements:
	docker-compose exec backend pip freeze > backend/requirements.txt

health:
	@echo "Checking service health..."
	@docker-compose ps
	@echo ""
	@echo "Testing API..."
	@curl -s http://localhost:8000/api/prompts/ | head -c 100 && echo ""
	@echo "✓ Services are healthy"
