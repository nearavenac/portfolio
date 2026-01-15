# Portfolio - Contexto para Claude

## Descripción

Portfolio personal de Nico que muestra sus proyectos web. El sitio es accesible desde dos dominios:
- nicodev.work
- nicoapps.com

## Stack técnico

- **Frontend**: React 18 con Vite 6
- **Estilos**: CSS puro con variables CSS (sin Tailwind ni otros frameworks)
- **Build**: Vite genera archivos estáticos en `/dist`
- **Server**: Nginx sirve los archivos estáticos

## Estructura de archivos importantes

```
src/
├── components/
│   ├── Header.jsx       # Navegación fija con logo
│   ├── Hero.jsx         # Sección principal con intro
│   ├── ProjectCard.jsx  # Tarjeta individual de proyecto
│   ├── ProjectsGrid.jsx # Grid que renderiza todas las tarjetas
│   └── Footer.jsx       # Footer con links sociales
├── data/
│   └── projects.js      # ARRAY DE PROYECTOS - editar aquí para agregar más
└── styles/
    └── index.css        # Todos los estilos + variables CSS
```

## Cómo agregar un nuevo proyecto

1. Editar `src/data/projects.js`
2. Agregar un objeto al array con: id, title, description, url, technologies, image
3. Si hay imagen, colocarla en `public/projects/`

## Convenciones

- Componentes: PascalCase (Header.jsx)
- Variables CSS: --color-*, --border-radius, etc.
- Tema: Oscuro con acentos en morado/índigo
- Responsive: Mobile-first con breakpoints en 768px y 480px

## Comandos útiles

```bash
npm run dev      # Desarrollo en localhost:5173
npm run build    # Build para producción
npm run preview  # Preview del build
```

## Nginx

La configuración está en `nginx/portfolio.conf`. Sirve el contenido de `/dist` para ambos dominios.
