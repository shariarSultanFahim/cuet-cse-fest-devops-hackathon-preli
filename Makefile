# Variables
# Defaults to development mode. Override with `make up MODE=prod`
MODE ?= dev
ifeq ($(MODE), prod)
	COMPOSE_FILE := docker/compose.production.yaml
else
	COMPOSE_FILE := docker/compose.development.yaml
endif

# Docker Services
up:
	@echo "Starting services in $(MODE) mode..."
	docker compose --env-file .env -f $(COMPOSE_FILE) up -d --build

down:
	@echo "Stopping services..."
	docker compose --env-file .env -f $(COMPOSE_FILE) down
build:
	@echo "Building images for $(MODE)..."
	docker compose --env-file .env -f $(COMPOSE_FILE) build

logs:
	@echo "Following logs..."
	docker compose --env-file .env -f $(COMPOSE_FILE) logs -f $(SERVICE)
restart:
	docker compose --env-file .env -f $(COMPOSE_FILE) restart $(SERVICE)

shell:
	# Default to backend if SERVICE not specified
	docker compose --env-file .env -f $(COMPOSE_FILE) exec $(or $(SERVICE), backend) sh

ps:
	docker compose --env-file .env -f $(COMPOSE_FILE) ps

# Convenience Aliases (Development)
dev-up:
	make up MODE=dev

dev-down:
	make down MODE=dev

dev-build:
	make build MODE=dev

dev-logs:
	make logs MODE=dev

dev-restart:
	make restart MODE=dev

dev-shell:
	make shell MODE=dev SERVICE=backend

dev-ps:
	make ps MODE=dev

backend-shell:
	make shell SERVICE=backend

gateway-shell:
	make shell SERVICE=gateway

mongo-shell:
	make shell SERVICE=mongo

# Convenience Aliases (Production)
prod-up:
	make up MODE=prod

prod-down:
	make down MODE=prod

prod-build:
	make build MODE=prod

prod-logs:
	make logs MODE=prod

prod-restart:
	make restart MODE=prod

# Utilities
clean:
	docker compose --env-file .env -f docker/compose.development.yaml down --rmi local -v --remove-orphans
	docker compose --env-file .env -f docker/compose.production.yaml down --rmi local -v --remove-orphans

clean-volumes:
	docker volume prune -f

help:
	@echo "Available commands:"
	@echo "  make up [MODE=dev|prod]     - Start services"
	@echo "  make down [MODE=dev|prod]   - Stop services"
	@echo "  make logs [SERVICE=name]    - View logs"
	@echo "  make shell [SERVICE=name]   - Open shell in container"