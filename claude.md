# Portfolio - Contexto para Claude

## Descripción

Portfolio personal de Nico que muestra sus proyectos web. El sitio es accesible desde dos dominios:
- nicodev.work (proyectos públicos)
- nicoapps.com (todos los proyectos, incluyendo privados)

## Stack técnico

- **Frontend**: React 18 con Vite 6
- **Estilos**: CSS puro con variables CSS (sin Tailwind ni otros frameworks)
- **Build**: Vite genera archivos estáticos en `/dist`
- **Server**: Nginx sirve los archivos estáticos

## Proyectos en el Portfolio

### 1. Asientos
- **Descripción**: Contabilidad automatizada con IA para empresas chilenas
- **Stack**: React, FastAPI, PostgreSQL, Fintoc
- **Dominio**: asientos.nicodev.work / asientos.nicoapps.com
- **Características**: Sincroniza bancos, integra SII, genera asientos contables automáticamente

### 2. Reqlut
- **Descripción**: Plataforma de empleo chilena con IA para matching laboral (RIAH™)
- **Stack**: PHP, Symfony, MySQL, Bootstrap
- **Dominio**: reqlut*.nicodev.work (wildcard para +270 portales)
- **Características**: Portal de empleo white-label, ferias laborales virtuales

### 3. SoyMomo (nicoapps.com only)
- **Descripción**: Sistema de gestión de licencias para dispositivos SoyMomo
- **Stack**: FastAPI, PostgreSQL, Bootstrap, Chart.js
- **Dominio**: soymomo.nicoapps.com
- **Características**: Sincronización con API Kidmode, dashboard de métricas

### 4. DrApp (nicoapps.com only)
- **Descripción**: Plataforma médica integral
- **Stack**: PHP, Symfony, MySQL, Twig
- **Portales**:
  - ion.nicoapps.com (Profesionales)
  - center.nicoapps.com (Centros)
  - pacientes.nicoapps.com (Pacientes)
  - drapp.nicoapps.com (Principal)
- **Características**: Gestión de citas, fichas clínicas, pagos, telemedicina

### 5. Gasmaule (nicoapps.com only)
- **Descripción**: Sistema de gestión para distribución de gas
- **Stack**: Laravel, Vue.js, MySQL, Redis
- **Dominio**: gasmaule.nicoapps.com
- **Características**: Ventas, inventario, despachos, facturación electrónica, app móvil

### 6. Video Generator (nicoapps.com only)
- **Descripción**: Generador de videos cortos estilo TikTok usando IA
- **Stack**: React, FastAPI, Celery, Gemini AI
- **Dominio**: video.nicoapps.com
- **Características**: Crea guiones con Gemini, genera audio, compone videos

## Estructura de archivos importantes

```
src/
├── components/
│   ├── Header.jsx        # Navegación fija con logo
│   ├── Hero.jsx          # Sección principal con intro
│   ├── ProjectCard.jsx   # Tarjeta individual de proyecto
│   ├── ProjectsGrid.jsx  # Grid que renderiza todas las tarjetas
│   ├── ReqlutModal.jsx   # Modal con listado de portales Reqlut
│   ├── DrappModal.jsx    # Modal con portales de DrApp
│   └── Footer.jsx        # Footer con links sociales
├── data/
│   ├── projects.js       # Array de proyectos - editar aquí para agregar más
│   ├── portals.js        # Wrapper para cargar portales Reqlut
│   └── portals.json      # JSON con portales Reqlut (exportado desde BD)
└── styles/
    └── index.css         # Todos los estilos + variables CSS

sql/
├── export-portals.sql    # Query para exportar portales
└── reqlut-dev-setup.sql  # Script para configurar BD de desarrollo

nginx/
├── portfolio.conf        # Config nginx para el portfolio
├── asientos.conf         # Config nginx para asientos
├── reqlut.conf           # Config nginx para reqlut (wildcard)
├── soymomo.conf          # Config nginx para soymomo
├── drapp.conf            # Config nginx para drapp
├── gasmaule.conf         # Config nginx para gasmaule
└── video.conf            # Config nginx para video generator
```

## Comandos Make

### Desarrollo y Deploy

```bash
make dev                    # Servidor de desarrollo (Vite)
make build                  # Build de producción
make deploy                 # Build + instalar nginx + reload
make clean                  # Limpiar dist y node_modules
```

### Nginx (instalación centralizada)

```bash
make nginx-install-asientos   # Instalar nginx para asientos
make nginx-install-reqlut     # Instalar nginx para reqlut (wildcard)
make nginx-install-soymomo    # Instalar nginx para soymomo
make nginx-install-drapp      # Instalar nginx para drapp
make nginx-install-gasmaule   # Instalar nginx para gasmaule
make nginx-install-video      # Instalar nginx para video
make nginx-status             # Ver estado de nginx
```

### Reqlut Database

```bash
make reqlut-dev-setup         # Configurar BD para desarrollo
make reqlut-export-portals    # Exportar portales a JSON
```

### DrApp Database

```bash
make drapp-db-download        # Descargar BD de producción (via SSM)
make drapp-db-load            # Cargar dump en contenedor local
make drapp-db-sync            # Download + Load en un solo comando
```

## Exportar Portales de Reqlut

El comando `make reqlut-export-portals` exporta los portales desde MySQL a `src/data/portals.json`.

**Base de datos a usar**: `reqlut20260112` (no `reqlut` que está vacía)

**Importante - Codificación UTF-8**: El comando usa `--default-character-set=utf8mb4` para que las tildes se exporten correctamente. Sin esto, caracteres como "Concepción" aparecen como "Concepci�n".

```bash
# Exportar portales y hacer build
echo "reqlut20260112" | make reqlut-export-portals

# Luego deploy
make deploy
```

## Cómo agregar un nuevo proyecto

1. Editar `src/data/projects.js`
2. Agregar un objeto al array con: id, title, description, subdomain, technologies, image
3. Si es privado (solo nicoapps.com), agregar `nicoappsOnly: true`
4. Si tiene múltiples portales, agregar array `portals`
5. Colocar imagen en `public/projects/`
6. Ejecutar `make deploy`

## Convenciones

- Componentes: PascalCase (Header.jsx)
- Variables CSS: --color-*, --border-radius, etc.
- Tema: Oscuro con acentos en morado/índigo
- Responsive: Mobile-first con breakpoints en 768px y 480px

## Variables de entorno para Docker

```bash
REQLUT_CONTAINER=reqlut-db
REQLUT_DB_USER=root
REQLUT_DB_PASS=reqlut

DRAPP_LOCAL_CONTAINER=drapp-db
DRAPP_LOCAL_DB_USER=root
DRAPP_LOCAL_DB_PASS=drapp
```
