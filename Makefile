.PHONY: help dev build deploy clean

# Default target - show help
.DEFAULT_GOAL := help

help:
	@echo ""
	@echo "========================================================"
	@echo "   Portfolio - Comandos Make Disponibles                "
	@echo "========================================================"
	@echo ""
	@echo "Desarrollo:"
	@echo "  make dev              - Iniciar servidor de desarrollo (Vite)"
	@echo "  make build            - Generar build de produccion"
	@echo "  make clean            - Limpiar carpeta dist y node_modules"
	@echo ""
	@echo "Despliegue:"
	@echo "  make deploy           - Build + instalar nginx + reload"
	@echo ""
	@echo "Ejemplo de uso:"
	@echo "  make dev              # Desarrollo local en :5173"
	@echo "  make deploy           # Desplegar en produccion"
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
	@echo "  - http://nicodev.work"
	@echo "  - http://nicoapps.com"
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
