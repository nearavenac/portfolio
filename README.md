# Nico Portfolio

Portfolio personal que muestra los proyectos de Nico. Accesible desde dos dominios:
- **nicodev.work** - Proyectos públicos
- **nicoapps.com** - Todos los proyectos (incluyendo privados)

## Proyectos

### Públicos (ambos dominios)

| Proyecto | Descripción | Stack | URL |
|----------|-------------|-------|-----|
| **Asientos** | Contabilidad automatizada con IA para empresas chilenas | React, FastAPI, PostgreSQL, Fintoc | asientos.nicodev.work |
| **Reqlut** | Plataforma de empleo con IA para matching laboral (270+ portales) | PHP, Symfony, MySQL, Bootstrap | reqlut*.nicodev.work |

### Privados (solo nicoapps.com)

| Proyecto | Descripción | Stack | URL |
|----------|-------------|-------|-----|
| **SoyMomo** | Sistema de gestión de licencias para dispositivos SoyMomo | FastAPI, PostgreSQL, Bootstrap, Chart.js | soymomo.nicoapps.com |
| **DrApp** | Plataforma médica integral (profesionales, centros, pacientes) | PHP, Symfony, MySQL, Twig | ion/center/pacientes.nicoapps.com |
| **Gasmaule** | Sistema de gestión para distribución de gas | Laravel, Vue.js, MySQL, Redis | gasmaule.nicoapps.com |
| **Video Generator** | Generador de videos cortos estilo TikTok usando IA | React, FastAPI, Celery, Gemini AI | video.nicoapps.com |

## Tech Stack

- React 18
- Vite 6
- CSS puro (sin frameworks)
- Nginx

## Comandos Make

### Desarrollo y Deploy

```bash
make dev                    # Servidor de desarrollo (Vite)
make build                  # Build de producción
make deploy                 # Build + instalar nginx + reload
make clean                  # Limpiar dist y node_modules
```

### Nginx

```bash
make nginx-install-asientos   # Instalar nginx para asientos
make nginx-install-reqlut     # Instalar nginx para reqlut (wildcard)
make nginx-install-soymomo    # Instalar nginx para soymomo
make nginx-install-drapp      # Instalar nginx para drapp
make nginx-install-gasmaule   # Instalar nginx para gasmaule
make nginx-install-video      # Instalar nginx para video
make nginx-status             # Ver estado de nginx
```

### Base de datos

```bash
make reqlut-dev-setup         # Configurar BD Reqlut para desarrollo
make reqlut-export-portals    # Exportar portales Reqlut a JSON
make drapp-db-download        # Descargar BD DrApp de producción
make drapp-db-load            # Cargar dump en contenedor local
make drapp-db-sync            # Download + Load en un solo comando
```

## Desarrollo

```bash
# Instalar dependencias
npm install

# Iniciar servidor de desarrollo
npm run dev

# Crear build de producción
npm run build
```

## Agregar un nuevo proyecto

1. Editar `src/data/projects.js`:

```javascript
{
  id: 7,
  title: "Nuevo Proyecto",
  description: "Descripción del proyecto",
  subdomain: "nuevo",
  technologies: ["React", "Node.js"],
  image: "/projects/nuevo.png",
  nicoappsOnly: true  // opcional: solo visible en nicoapps.com
}
```

2. Agregar imagen en `public/projects/`
3. Ejecutar `make deploy`

## Estructura del proyecto

```
portfolio/
├── src/
│   ├── components/     # Componentes React
│   ├── data/           # Datos de proyectos y portales
│   └── styles/         # Estilos CSS
├── public/
│   └── projects/       # Screenshots de proyectos
├── nginx/              # Configuraciones nginx
├── sql/                # Scripts SQL para BD
└── dist/               # Build de producción (generado)
```

## Notas

- Los portales de Reqlut se exportan desde MySQL con `make reqlut-export-portals`
- Usar `--default-character-set=utf8mb4` para preservar tildes en la exportación
- Las credenciales de DrApp se configuran via variables de entorno
