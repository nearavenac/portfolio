.PHONY: help dev build deploy clean nginx-install-asientos nginx-install-reqlut nginx-install-soymomo nginx-install-drapp nginx-install-gasmaule nginx-install-video nginx-install-awscert nginx-status reqlut-dev-setup reqlut-export-portals drapp-db-download drapp-db-load drapp-db-sync awscert-start awscert-stop awscert-logs awscert-rebuild awscert-status

# Default target - show help
.DEFAULT_GOAL := help

help:
	@echo ""
	@echo "========================================================"
	@echo "   Portfolio - Comandos Make Disponibles                "
	@echo "========================================================"
	@echo ""
	@echo "Desarrollo:"
	@echo "  make dev                  - Iniciar servidor de desarrollo (Vite)"
	@echo "  make build                - Generar build de produccion"
	@echo "  make clean                - Limpiar carpeta dist y node_modules"
	@echo ""
	@echo "Despliegue:"
	@echo "  make deploy               - Build + instalar nginx + reload"
	@echo ""
	@echo "Nginx (centralized):"
	@echo "  make nginx-install-asientos - Instalar nginx para asientos.nicodev.work"
	@echo "  make nginx-install-reqlut   - Instalar nginx para reqlut.nicodev.work"
	@echo "  make nginx-install-soymomo  - Instalar nginx para soymomo.nicoapps.com"
	@echo "  make nginx-install-drapp    - Instalar nginx para drapp (ion/center/pacientes).nicoapps.com"
	@echo "  make nginx-install-gasmaule - Instalar nginx para gasmaule.nicoapps.com"
	@echo "  make nginx-install-video    - Instalar nginx para video.nicoapps.com"
	@echo "  make nginx-status           - Ver estado de nginx"
	@echo ""
	@echo "Reqlut Database (via Docker):"
	@echo "  make reqlut-dev-setup       - Configurar BD de reqlut para desarrollo"
	@echo "  make reqlut-export-portals  - Exportar portales a JSON para portfolio"
	@echo ""
	@echo "DrApp Database (via SSM):"
	@echo "  make drapp-db-download      - Descargar BD de produccion (RDS via SSM)"
	@echo "  make drapp-db-load          - Cargar dump en contenedor local"
	@echo "  make drapp-db-sync          - Download + Load en un solo comando"
	@echo ""
	@echo "AWS Cert Platform:"
	@echo "  make nginx-install-awscert  - Instalar nginx para awscert.nicodev.work/nicoapps.com"
	@echo "  make awscert-start          - Iniciar servicios Docker"
	@echo "  make awscert-stop           - Detener servicios Docker"
	@echo "  make awscert-logs           - Ver logs de servicios"
	@echo "  make awscert-rebuild        - Reconstruir y reiniciar servicios"
	@echo "  make awscert-status         - Ver estado de servicios"
	@echo ""

dev:
	@echo ""
	@echo "========================================================"
	@echo "   Iniciando servidor de desarrollo                     "
	@echo "========================================================"
	@echo ""
	npm run dev

build:
	@echo ""
	@echo "========================================================"
	@echo "   Generando build de produccion                        "
	@echo "========================================================"
	@echo ""
	npm run build
	@echo ""
	@echo "Build completado en ./dist"
	@echo ""

deploy:
	@echo ""
	@echo "========================================================"
	@echo "   Desplegando Portfolio                                 "
	@echo "========================================================"
	@echo ""
	@echo "Dominios: nicodev.work, nicoapps.com"
	@echo ""
	@echo "-> Generando build de produccion..."
	@npm run build
	@echo ""
	@echo "-> Ajustando permisos..."
	@sudo chmod 755 /home/ubuntu
	@sudo chown -R ubuntu:ubuntu /home/ubuntu/portfolio
	@sudo chmod -R 755 /home/ubuntu/portfolio
	@echo "-> Copiando configuracion nginx..."
	@sudo cp nginx/portfolio.conf /etc/nginx/sites-available/portfolio
	@echo "-> Creando symlink..."
	@sudo ln -sf /etc/nginx/sites-available/portfolio /etc/nginx/sites-enabled/
	@echo "-> Verificando configuracion nginx..."
	@sudo nginx -t
	@echo "-> Recargando nginx..."
	@sudo systemctl reload nginx || sudo systemctl start nginx
	@echo ""
	@echo "========================================================"
	@echo "   Despliegue completado!                                "
	@echo "========================================================"
	@echo ""
	@echo "Sitio disponible en:"
	@echo "  - https://nicodev.work"
	@echo "  - https://nicoapps.com"
	@echo ""

clean:
	@echo ""
	@echo "-> Limpiando dist..."
	@rm -rf dist
	@echo "-> Limpiando node_modules..."
	@rm -rf node_modules
	@echo ""
	@echo "Limpieza completada"
	@echo ""

# =============================================================================
# Nginx Installation Commands (Centralized)
# =============================================================================

nginx-status:
	@echo ""
	@echo "========================================================"
	@echo "   Estado de Nginx                                       "
	@echo "========================================================"
	@echo ""
	@sudo systemctl status nginx --no-pager || true
	@echo ""
	@echo "Sites habilitados:"
	@ls -la /etc/nginx/sites-enabled/
	@echo ""

nginx-install-asientos:
	@echo ""
	@echo "========================================================"
	@echo "   Nginx Installer - Asientos                            "
	@echo "========================================================"
	@echo ""
	@echo "Dominios: asientos.nicodev.work, asientos.nicoapps.com"
	@echo ""
	@if [ ! -f nginx/asientos.conf ]; then \
		echo "Error: nginx/asientos.conf not found"; \
		exit 1; \
	fi
	@# SSL certificate for asientos.nicodev.work
	@if [ ! -f /etc/letsencrypt/live/asientos.nicodev.work/fullchain.pem ]; then \
		echo "-> SSL certificate not found for asientos.nicodev.work..."; \
		echo "-> Stopping nginx..."; \
		sudo systemctl stop nginx 2>/dev/null || true; \
		echo "-> Generating SSL certificate..."; \
		sudo certbot certonly --standalone -d asientos.nicodev.work --non-interactive --agree-tos --email admin@nicodev.work || { \
			echo "Error: Failed to generate SSL certificate"; \
			echo "   Make sure DNS points to this server"; \
			exit 1; \
		}; \
		echo "-> SSL certificate generated!"; \
		echo ""; \
	fi
	@# SSL certificate for asientos.nicoapps.com
	@if [ ! -f /etc/letsencrypt/live/asientos.nicoapps.com/fullchain.pem ]; then \
		echo "-> SSL certificate not found for asientos.nicoapps.com..."; \
		echo "-> Stopping nginx..."; \
		sudo systemctl stop nginx 2>/dev/null || true; \
		echo "-> Generating SSL certificate..."; \
		sudo certbot certonly --standalone -d asientos.nicoapps.com --non-interactive --agree-tos --email admin@nicoapps.com || { \
			echo "Error: Failed to generate SSL certificate"; \
			echo "   Make sure DNS points to this server"; \
			exit 1; \
		}; \
		echo "-> SSL certificate generated!"; \
		echo ""; \
	fi
	@echo "-> Copying nginx configuration..."
	@sudo cp nginx/asientos.conf /etc/nginx/sites-available/nicodev
	@echo "-> Creating symlink..."
	@sudo ln -sf /etc/nginx/sites-available/nicodev /etc/nginx/sites-enabled/
	@echo "-> Testing nginx configuration..."
	@sudo nginx -t
	@echo "-> Reloading nginx..."
	@sudo systemctl reload nginx || sudo systemctl start nginx
	@echo ""
	@echo "Nginx installed for asientos!"
	@echo "  - https://asientos.nicodev.work"
	@echo "  - https://asientos.nicoapps.com"
	@echo ""

nginx-install-reqlut:
	@echo ""
	@echo "========================================================"
	@echo "   Nginx Installer - Reqlut (Wildcard)                   "
	@echo "========================================================"
	@echo ""
	@echo "Dominios: reqlut*.nicodev.work, reqlut*.nicoapps.com"
	@echo ""
	@if [ ! -f nginx/reqlut.conf ]; then \
		echo "Error: nginx/reqlut.conf not found"; \
		exit 1; \
	fi
	@# Check wildcard certificate for *.nicodev.work
	@if [ ! -f /etc/letsencrypt/live/nicodev.work-0001/fullchain.pem ]; then \
		echo "Error: Wildcard certificate for *.nicodev.work not found"; \
		echo "Run: sudo certbot certonly --manual --preferred-challenges dns -d '*.nicodev.work' -d 'nicodev.work'"; \
		exit 1; \
	fi
	@# Check wildcard certificate for *.nicoapps.com
	@if [ ! -f /etc/letsencrypt/live/nicoapps.com/fullchain.pem ]; then \
		echo "Error: Wildcard certificate for *.nicoapps.com not found"; \
		echo "Run: sudo certbot certonly --manual --preferred-challenges dns -d '*.nicoapps.com' -d 'nicoapps.com'"; \
		exit 1; \
	fi
	@echo "-> Wildcard certificates found"
	@echo "-> Copying nginx configuration..."
	@sudo cp nginx/reqlut.conf /etc/nginx/sites-available/reqlut
	@echo "-> Creating symlink..."
	@sudo ln -sf /etc/nginx/sites-available/reqlut /etc/nginx/sites-enabled/
	@echo "-> Testing nginx configuration..."
	@sudo nginx -t
	@echo "-> Reloading nginx..."
	@sudo systemctl reload nginx || sudo systemctl start nginx
	@echo ""
	@echo "Nginx installed for reqlut!"
	@echo "  - https://reqlut*.nicodev.work"
	@echo "  - https://reqlut*.nicoapps.com"
	@echo ""

nginx-install-soymomo:
	@echo ""
	@echo "========================================================"
	@echo "   Nginx Installer - SoyMomo License Manager            "
	@echo "========================================================"
	@echo ""
	@echo "Dominio: soymomo.nicoapps.com"
	@echo ""
	@if [ ! -f nginx/soymomo.conf ]; then \
		echo "Error: nginx/soymomo.conf not found"; \
		exit 1; \
	fi
	@# Check wildcard certificate for *.nicoapps.com
	@if [ ! -f /etc/letsencrypt/live/nicoapps.com/fullchain.pem ]; then \
		echo "Error: Wildcard certificate for *.nicoapps.com not found"; \
		echo "Run: sudo certbot certonly --manual --preferred-challenges dns -d '*.nicoapps.com' -d 'nicoapps.com'"; \
		exit 1; \
	fi
	@echo "-> Wildcard certificate found"
	@echo "-> Copying nginx configuration..."
	@sudo cp nginx/soymomo.conf /etc/nginx/sites-available/soymomo
	@echo "-> Creating symlink..."
	@sudo ln -sf /etc/nginx/sites-available/soymomo /etc/nginx/sites-enabled/
	@echo "-> Testing nginx configuration..."
	@sudo nginx -t
	@echo "-> Reloading nginx..."
	@sudo systemctl reload nginx || sudo systemctl start nginx
	@echo ""
	@echo "Nginx installed for SoyMomo!"
	@echo "  - https://soymomo.nicoapps.com"
	@echo ""

nginx-install-drapp:
	@echo ""
	@echo "========================================================"
	@echo "   Nginx Installer - DrApp Medical Platform             "
	@echo "========================================================"
	@echo ""
	@echo "Dominios:"
	@echo "  - ion.nicoapps.com (Professional)"
	@echo "  - center.nicoapps.com (Center)"
	@echo "  - pacientes.nicoapps.com (Patient)"
	@echo "  - drapp.nicoapps.com (Main)"
	@echo ""
	@if [ ! -f nginx/drapp.conf ]; then \
		echo "Error: nginx/drapp.conf not found"; \
		exit 1; \
	fi
	@# Check wildcard certificate for *.nicoapps.com
	@if [ ! -f /etc/letsencrypt/live/nicoapps.com/fullchain.pem ]; then \
		echo "Error: Wildcard certificate for *.nicoapps.com not found"; \
		echo "Run: sudo certbot certonly --manual --preferred-challenges dns -d '*.nicoapps.com' -d 'nicoapps.com'"; \
		exit 1; \
	fi
	@echo "-> Wildcard certificate found"
	@echo "-> Copying nginx configuration..."
	@sudo cp nginx/drapp.conf /etc/nginx/sites-available/drapp
	@echo "-> Creating symlink..."
	@sudo ln -sf /etc/nginx/sites-available/drapp /etc/nginx/sites-enabled/
	@echo "-> Testing nginx configuration..."
	@sudo nginx -t
	@echo "-> Reloading nginx..."
	@sudo systemctl reload nginx || sudo systemctl start nginx
	@echo ""
	@echo "========================================================"
	@echo "   Nginx installed for DrApp!                           "
	@echo "========================================================"
	@echo ""
	@echo "Portales disponibles:"
	@echo "  - https://ion.nicoapps.com (Profesionales)"
	@echo "  - https://center.nicoapps.com (Centros)"
	@echo "  - https://pacientes.nicoapps.com (Pacientes)"
	@echo "  - https://drapp.nicoapps.com (Principal)"
	@echo ""

nginx-install-gasmaule:
	@echo ""
	@echo "========================================================"
	@echo "   Nginx Installer - Gasmaule                           "
	@echo "========================================================"
	@echo ""
	@echo "Dominio: gasmaule.nicoapps.com"
	@echo ""
	@if [ ! -f nginx/gasmaule.conf ]; then \
		echo "Error: nginx/gasmaule.conf not found"; \
		exit 1; \
	fi
	@# Check wildcard certificate for *.nicoapps.com
	@if [ ! -f /etc/letsencrypt/live/nicoapps.com/fullchain.pem ]; then \
		echo "Error: Wildcard certificate for *.nicoapps.com not found"; \
		echo "Run: sudo certbot certonly --manual --preferred-challenges dns -d '*.nicoapps.com' -d 'nicoapps.com'"; \
		exit 1; \
	fi
	@echo "-> Wildcard certificate found"
	@echo "-> Copying nginx configuration..."
	@sudo cp nginx/gasmaule.conf /etc/nginx/sites-available/gasmaule
	@echo "-> Creating symlink..."
	@sudo ln -sf /etc/nginx/sites-available/gasmaule /etc/nginx/sites-enabled/
	@echo "-> Testing nginx configuration..."
	@sudo nginx -t
	@echo "-> Reloading nginx..."
	@sudo systemctl reload nginx || sudo systemctl start nginx
	@echo ""
	@echo "========================================================"
	@echo "   Nginx installed for Gasmaule!                        "
	@echo "========================================================"
	@echo ""
	@echo "Sistema disponible en:"
	@echo "  - https://gasmaule.nicoapps.com"
	@echo ""
	@echo "Prerequisitos:"
	@echo "  - Docker containers corriendo (cd ~/sistema-gasmaule && make up)"
	@echo "  - Puerto 8282 (web) y 6060 (websocket) disponibles"
	@echo ""

nginx-install-video:
	@echo ""
	@echo "========================================================"
	@echo "   Nginx Installer - Video Generator                    "
	@echo "========================================================"
	@echo ""
	@echo "Dominio: video.nicoapps.com"
	@echo ""
	@if [ ! -f nginx/video.conf ]; then \
		echo "Error: nginx/video.conf not found"; \
		exit 1; \
	fi
	@# Check wildcard certificate for *.nicoapps.com
	@if [ ! -f /etc/letsencrypt/live/nicoapps.com/fullchain.pem ]; then \
		echo "Error: Wildcard certificate for *.nicoapps.com not found"; \
		echo "Run: sudo certbot certonly --manual --preferred-challenges dns -d '*.nicoapps.com' -d 'nicoapps.com'"; \
		exit 1; \
	fi
	@echo "-> Wildcard certificate found"
	@echo "-> Copying nginx configuration..."
	@sudo cp nginx/video.conf /etc/nginx/sites-available/video
	@echo "-> Creating symlink..."
	@sudo ln -sf /etc/nginx/sites-available/video /etc/nginx/sites-enabled/
	@echo "-> Testing nginx configuration..."
	@sudo nginx -t
	@echo "-> Reloading nginx..."
	@sudo systemctl reload nginx || sudo systemctl start nginx
	@echo ""
	@echo "========================================================"
	@echo "   Nginx installed for Video Generator!                 "
	@echo "========================================================"
	@echo ""
	@echo "Sistema disponible en:"
	@echo "  - https://video.nicoapps.com"
	@echo ""
	@echo "Prerequisitos:"
	@echo "  - Docker containers corriendo (cd ~/videos-generator && make dev)"
	@echo "  - Puerto 5173 (frontend) y 8002 (backend) disponibles"
	@echo ""

# =============================================================================
# Reqlut Database Commands
# =============================================================================

REQLUT_CONTAINER ?= reqlut-db
REQLUT_DB_USER ?= root
REQLUT_DB_PASS ?= reqlut

reqlut-dev-setup:
	@echo ""
	@echo "========================================================"
	@echo "   Reqlut - Configuracion de Desarrollo                  "
	@echo "========================================================"
	@echo ""
	@if [ ! -f sql/reqlut-dev-setup.sql ]; then \
		echo "Error: sql/reqlut-dev-setup.sql not found"; \
		exit 1; \
	fi
	@echo "Bases de datos disponibles:"
	@docker exec $(REQLUT_CONTAINER) mysql -u$(REQLUT_DB_USER) -p$(REQLUT_DB_PASS) -e "SHOW DATABASES LIKE 'reqlut%';" 2>/dev/null | tail -n +2 || true
	@echo ""
	@read -p "Nombre de la base de datos: " db_name && \
	read -p "Auth ID del usuario [555530]: " auth_id && \
	auth_id=$${auth_id:-555530} && \
	echo "" && \
	echo "-> Ejecutando script en $$db_name para auth_id=$$auth_id..." && \
	docker cp sql/reqlut-dev-setup.sql $(REQLUT_CONTAINER):/tmp/reqlut-dev-setup.sql && \
	(echo "SET @authId = $$auth_id;" && cat sql/reqlut-dev-setup.sql) | docker exec -i $(REQLUT_CONTAINER) mysql -u$(REQLUT_DB_USER) -p$(REQLUT_DB_PASS) $$db_name && \
	docker exec $(REQLUT_CONTAINER) rm -f /tmp/reqlut-dev-setup.sql && \
	echo "" && \
	echo "========================================================" && \
	echo "   Configuracion completada!                             " && \
	echo "========================================================" && \
	echo "" && \
	echo "Acciones realizadas:" && \
	echo "  - Asignados todos los roles al usuario $$auth_id" && \
	echo "  - Asignado acceso a portales genericos" && \
	echo "  - Asignado admin de portales de empleo" && \
	echo "  - Asignado admin de expos" && \
	echo "  - Eliminados triggers de cache" && \
	echo "  - Configurados dominios reqlut-{id}.nicodev.work" && \
	echo "  - Limpiados datos de usuarios de prueba" && \
	echo ""

reqlut-export-portals:
	@echo ""
	@echo "========================================================"
	@echo "   Reqlut - Exportar Portales                           "
	@echo "========================================================"
	@echo ""
	@echo "Bases de datos disponibles:"
	@docker exec $(REQLUT_CONTAINER) mysql -u$(REQLUT_DB_USER) -p$(REQLUT_DB_PASS) -e "SHOW DATABASES LIKE 'reqlut%';" 2>/dev/null | tail -n +2 || true
	@echo ""
	@read -p "Nombre de la base de datos: " db_name && \
	echo "" && \
	echo "-> Exportando portales desde $$db_name..." && \
	docker exec $(REQLUT_CONTAINER) mysql --default-character-set=utf8mb4 -u$(REQLUT_DB_USER) -p$(REQLUT_DB_PASS) $$db_name -N -e "SELECT JSON_ARRAYAGG(JSON_OBJECT('id', id, 'name', name, 'company', company, 'lower', lower, 'domain', domain)) FROM Portal WHERE lower NOT LIKE 'base%' ORDER BY name;" | sed 's/\\\\"/\\"/g' > src/data/portals.json && \
	echo "-> Exportados $$(cat src/data/portals.json | jq 'length') portales a src/data/portals.json" && \
	echo "" && \
	echo "-> Generando build de produccion..." && \
	npm run build && \
	echo "" && \
	echo "========================================================"  && \
	echo "   Export completado!                                    " && \
	echo "========================================================"  && \
	echo ""

# =============================================================================
# DrApp Database Commands (via SSM)
# =============================================================================

# AWS Credentials for DrApp (set via environment variables)
DRAPP_AWS_ACCESS_KEY_ID ?= $(AWS_ACCESS_KEY_ID)
DRAPP_AWS_SECRET_ACCESS_KEY ?= $(AWS_SECRET_ACCESS_KEY)
DRAPP_AWS_REGION ?= us-east-1

# Production RDS (set via environment variables)
DRAPP_PROD_DB_HOST ?= $(DRAPP_RDS_HOST)
DRAPP_PROD_DB_PORT ?= 3306
DRAPP_PROD_DB_NAME ?= drapp
DRAPP_PROD_DB_USER ?= $(DRAPP_RDS_USER)
DRAPP_PROD_DB_PASS ?= $(DRAPP_RDS_PASS)

# Local Docker container
DRAPP_LOCAL_CONTAINER ?= drapp-db
DRAPP_LOCAL_DB_USER ?= root
DRAPP_LOCAL_DB_PASS ?= drapp
DRAPP_LOCAL_DB_NAME ?= drapp

# SSM Instance ID (EC2 with access to RDS)
DRAPP_SSM_INSTANCE_ID ?= i-002b479bea6582ce1

# Dump file location
DRAPP_DUMP_FILE ?= /tmp/drapp-prod-dump.sql

drapp-db-download:
	@echo ""
	@echo "========================================================"
	@echo "   DrApp - Descargar BD de Produccion                   "
	@echo "========================================================"
	@echo ""
	@echo "RDS: $(DRAPP_PROD_DB_HOST)"
	@echo "Database: $(DRAPP_PROD_DB_NAME)"
	@echo ""
	@if [ -n "$(DRAPP_SSM_INSTANCE_ID)" ]; then \
		echo "-> Usando SSM port forwarding via $(DRAPP_SSM_INSTANCE_ID)..."; \
		echo "-> Iniciando sesion SSM en background..."; \
		AWS_ACCESS_KEY_ID=$(DRAPP_AWS_ACCESS_KEY_ID) \
		AWS_SECRET_ACCESS_KEY=$(DRAPP_AWS_SECRET_ACCESS_KEY) \
		AWS_REGION=$(DRAPP_AWS_REGION) \
		aws ssm start-session \
			--target $(DRAPP_SSM_INSTANCE_ID) \
			--document-name AWS-StartPortForwardingSessionToRemoteHost \
			--parameters '{"host":["$(DRAPP_PROD_DB_HOST)"],"portNumber":["$(DRAPP_PROD_DB_PORT)"],"localPortNumber":["13306"]}' > /tmp/ssm-drapp.log 2>&1 & \
		SSM_PID=$$!; \
		echo "-> SSM PID: $$SSM_PID"; \
		echo "-> Esperando conexion SSM..."; \
		for i in 1 2 3 4 5 6 7 8 9 10; do \
			if grep -q "Waiting for connections" /tmp/ssm-drapp.log 2>/dev/null; then \
				break; \
			fi; \
			sleep 1; \
		done; \
		sleep 2; \
		echo "-> Descargando BD via puerto local 13306 (esto puede tardar)..."; \
		mysqldump -h 127.0.0.1 -P 13306 -u$(DRAPP_PROD_DB_USER) -p'$(DRAPP_PROD_DB_PASS)' \
			--single-transaction --routines --triggers --events --set-gtid-purged=OFF \
			$(DRAPP_PROD_DB_NAME) > $(DRAPP_DUMP_FILE) 2>/dev/null; \
		DUMP_STATUS=$$?; \
		echo "-> Cerrando sesion SSM..."; \
		kill $$SSM_PID 2>/dev/null || true; \
		wait $$SSM_PID 2>/dev/null || true; \
		rm -f /tmp/ssm-drapp.log; \
		if [ $$DUMP_STATUS -ne 0 ]; then \
			echo "Error: mysqldump fallo"; \
			exit 1; \
		fi; \
	else \
		echo "-> Conexion directa a RDS..."; \
		mysqldump -h $(DRAPP_PROD_DB_HOST) -P $(DRAPP_PROD_DB_PORT) -u$(DRAPP_PROD_DB_USER) -p'$(DRAPP_PROD_DB_PASS)' \
			--single-transaction --routines --triggers --events --set-gtid-purged=OFF \
			$(DRAPP_PROD_DB_NAME) > $(DRAPP_DUMP_FILE) 2>/dev/null; \
	fi
	@if [ -f $(DRAPP_DUMP_FILE) ] && [ $$(wc -l < $(DRAPP_DUMP_FILE)) -gt 50 ]; then \
		echo ""; \
		echo "========================================================"; \
		echo "   Descarga completada!                                  "; \
		echo "========================================================"; \
		echo ""; \
		echo "Archivo: $(DRAPP_DUMP_FILE)"; \
		echo "Tamano: $$(du -h $(DRAPP_DUMP_FILE) | cut -f1)"; \
		echo "Lineas: $$(wc -l < $(DRAPP_DUMP_FILE))"; \
		echo ""; \
	else \
		echo ""; \
		echo "Error: Dump incompleto o vacio"; \
		echo "Verifica la conexion a RDS"; \
		exit 1; \
	fi

drapp-db-load:
	@echo ""
	@echo "========================================================"
	@echo "   DrApp - Cargar BD en Contenedor Local                "
	@echo "========================================================"
	@echo ""
	@if [ ! -f $(DRAPP_DUMP_FILE) ]; then \
		echo "Error: $(DRAPP_DUMP_FILE) no encontrado"; \
		echo "Ejecuta primero: make drapp-db-download"; \
		exit 1; \
	fi
	@echo "Dump: $(DRAPP_DUMP_FILE) ($$(du -h $(DRAPP_DUMP_FILE) | cut -f1))"
	@echo "Container: $(DRAPP_LOCAL_CONTAINER)"
	@echo "Database: $(DRAPP_LOCAL_DB_NAME)"
	@echo ""
	@echo "-> Verificando contenedor..."
	@docker ps --format '{{.Names}}' | grep -q $(DRAPP_LOCAL_CONTAINER) || { \
		echo "Error: Contenedor $(DRAPP_LOCAL_CONTAINER) no esta corriendo"; \
		echo "Ejecuta: cd /home/ubuntu/drapp-docker && docker compose up -d"; \
		exit 1; \
	}
	@echo "-> Eliminando BD existente..."
	@docker exec $(DRAPP_LOCAL_CONTAINER) mysql -u$(DRAPP_LOCAL_DB_USER) -p$(DRAPP_LOCAL_DB_PASS) \
		-e "DROP DATABASE IF EXISTS $(DRAPP_LOCAL_DB_NAME); CREATE DATABASE $(DRAPP_LOCAL_DB_NAME);" 2>/dev/null
	@echo "-> Importando dump (esto puede tardar)..."
	@docker exec -i $(DRAPP_LOCAL_CONTAINER) mysql -u$(DRAPP_LOCAL_DB_USER) -p$(DRAPP_LOCAL_DB_PASS) \
		$(DRAPP_LOCAL_DB_NAME) < $(DRAPP_DUMP_FILE) 2>/dev/null
	@echo ""
	@echo "========================================================"
	@echo "   Carga completada!                                     "
	@echo "========================================================"
	@echo ""
	@echo "Tablas importadas:"
	@docker exec $(DRAPP_LOCAL_CONTAINER) mysql -u$(DRAPP_LOCAL_DB_USER) -p$(DRAPP_LOCAL_DB_PASS) \
		-e "SELECT COUNT(*) as tablas FROM information_schema.tables WHERE table_schema='$(DRAPP_LOCAL_DB_NAME)';" 2>/dev/null | tail -1
	@echo ""

drapp-db-sync: drapp-db-download drapp-db-load
	@echo ""
	@echo "========================================================"
	@echo "   DrApp - Sincronizacion Completa!                     "
	@echo "========================================================"
	@echo ""
	@echo "La BD local esta sincronizada con produccion."
	@echo ""

# =============================================================================
# AWS Certification Platform
# =============================================================================
# Project: /home/ubuntu/aws-cert-platform
# Ports: Backend 8003, Frontend 5174
# Domains: awscert.nicodev.work, awscert.nicoapps.com

nginx-install-awscert:
	@echo ""
	@echo "========================================================"
	@echo "   Nginx Installer - AWS Cert Platform                   "
	@echo "========================================================"
	@echo ""
	@echo "Dominios: awscert.nicodev.work, awscert.nicoapps.com"
	@echo ""
	@if [ ! -f nginx/awscert.conf ]; then \
		echo "Error: nginx/awscert.conf not found"; \
		exit 1; \
	fi
	@# SSL certificate for awscert.nicodev.work
	@if [ ! -f /etc/letsencrypt/live/awscert.nicodev.work/fullchain.pem ]; then \
		echo "-> SSL certificate not found for awscert.nicodev.work..."; \
		echo "-> Stopping nginx..."; \
		sudo systemctl stop nginx 2>/dev/null || true; \
		echo "-> Generating SSL certificate..."; \
		sudo certbot certonly --standalone -d awscert.nicodev.work --non-interactive --agree-tos --email admin@nicodev.work || { \
			echo "Error: Failed to generate SSL certificate"; \
			echo "   Make sure DNS points to this server"; \
			exit 1; \
		}; \
		echo "-> SSL certificate generated!"; \
		echo ""; \
	fi
	@# SSL certificate for awscert.nicoapps.com
	@if [ ! -f /etc/letsencrypt/live/awscert.nicoapps.com/fullchain.pem ]; then \
		echo "-> SSL certificate not found for awscert.nicoapps.com..."; \
		echo "-> Stopping nginx..."; \
		sudo systemctl stop nginx 2>/dev/null || true; \
		echo "-> Generating SSL certificate..."; \
		sudo certbot certonly --standalone -d awscert.nicoapps.com --non-interactive --agree-tos --email admin@nicoapps.com || { \
			echo "Error: Failed to generate SSL certificate"; \
			echo "   Make sure DNS points to this server"; \
			exit 1; \
		}; \
		echo "-> SSL certificate generated!"; \
		echo ""; \
	fi
	@echo "-> Copying nginx configuration..."
	@sudo cp nginx/awscert.conf /etc/nginx/sites-available/awscert
	@echo "-> Creating symlink..."
	@sudo ln -sf /etc/nginx/sites-available/awscert /etc/nginx/sites-enabled/
	@echo "-> Testing nginx configuration..."
	@sudo nginx -t
	@echo "-> Reloading nginx..."
	@sudo systemctl reload nginx || sudo systemctl start nginx
	@echo ""
	@echo "Nginx installed for AWS Cert Platform!"
	@echo "  - https://awscert.nicodev.work"
	@echo "  - https://awscert.nicoapps.com"
	@echo ""

awscert-start:
	@echo ""
	@echo "========================================================"
	@echo "   AWS Cert Platform - Start Services                    "
	@echo "========================================================"
	@echo ""
	@cd /home/ubuntu/aws-cert-platform && docker compose up -d
	@echo ""
	@echo "Services started!"
	@echo "  - Backend: http://localhost:8003"
	@echo "  - Frontend: http://localhost:5174"
	@echo ""

awscert-stop:
	@echo ""
	@echo "========================================================"
	@echo "   AWS Cert Platform - Stop Services                     "
	@echo "========================================================"
	@echo ""
	@cd /home/ubuntu/aws-cert-platform && docker compose down
	@echo ""
	@echo "Services stopped!"
	@echo ""

awscert-logs:
	@cd /home/ubuntu/aws-cert-platform && docker compose logs -f

awscert-rebuild:
	@echo ""
	@echo "========================================================"
	@echo "   AWS Cert Platform - Rebuild Services                  "
	@echo "========================================================"
	@echo ""
	@cd /home/ubuntu/aws-cert-platform && docker compose up -d --build
	@echo ""
	@echo "Services rebuilt and started!"
	@echo ""

awscert-status:
	@echo ""
	@echo "========================================================"
	@echo "   AWS Cert Platform - Status                            "
	@echo "========================================================"
	@echo ""
	@cd /home/ubuntu/aws-cert-platform && docker compose ps
	@echo ""
