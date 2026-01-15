# Nico Portfolio

Portfolio personal que muestra los proyectos de Nico. Accesible desde nicodev.work y nicoapps.com.

## Proyectos actuales

- **Asientos** - https://asientos.nicodev.work
- **Reqlut** - https://reqlut.nicodev.work

## Tech Stack

- React 18
- Vite 6
- CSS puro (sin frameworks)

## Desarrollo

```bash
# Instalar dependencias
npm install

# Iniciar servidor de desarrollo
npm run dev

# Crear build de producción
npm run build

# Preview del build
npm run preview
```

## Agregar un nuevo proyecto

Edita el archivo `src/data/projects.js`:

```javascript
export const projects = [
  // ... proyectos existentes
  {
    id: 3, // incrementar el ID
    title: "Nombre del proyecto",
    description: "Descripción breve del proyecto",
    url: "https://proyecto.nicodev.work",
    technologies: ["React", "Node.js"],
    image: "/projects/proyecto.png" // opcional, puede ser null
  }
]
```

Si agregas una imagen, colócala en `public/projects/`.

## Deploy con Nginx

1. Generar el build:
```bash
npm run build
```

2. Copiar la configuración de nginx:
```bash
sudo cp nginx/portfolio.conf /etc/nginx/sites-available/portfolio
sudo ln -s /etc/nginx/sites-available/portfolio /etc/nginx/sites-enabled/
```

3. Verificar y recargar nginx:
```bash
sudo nginx -t
sudo systemctl reload nginx
```

## Estructura del proyecto

```
portfolio/
├── src/
│   ├── components/     # Componentes React
│   ├── data/           # Datos de proyectos
│   └── styles/         # Estilos CSS
├── public/             # Assets estáticos
├── nginx/              # Configuración nginx
└── dist/               # Build de producción (generado)
```
