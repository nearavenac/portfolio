.PHONY: help dev build deploy clean nginx-install-asientos nginx-install-reqlut nginx-status reqlut-dev-setup reqlut-export-portals

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
	@echo "  make nginx-status           - Ver estado de nginx"
	@echo ""
	@echo "Reqlut Database (via Docker):"
	@echo "  make reqlut-dev-setup       - Configurar BD de reqlut para desarrollo"
	@echo "  make reqlut-export-portals  - Exportar portales a JSON para portfolio"
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
	docker exec $(REQLUT_CONTAINER) mysql -u$(REQLUT_DB_USER) -p$(REQLUT_DB_PASS) $$db_name -N -e "SELECT JSON_ARRAYAGG(JSON_OBJECT('id', id, 'name', name, 'company', company, 'lower', lower, 'domain', domain)) FROM Portal WHERE lower NOT LIKE 'base%' ORDER BY name;" | sed 's/\\\\"/\\"/g' > src/data/portals.json && \
	echo "-> Exportados $$(cat src/data/portals.json | jq 'length') portales a src/data/portals.json" && \
	echo "" && \
	echo "-> Generando build de produccion..." && \
	npm run build && \
	echo "" && \
	echo "========================================================"  && \
	echo "   Export completado!                                    " && \
	echo "========================================================"  && \
	echo ""
