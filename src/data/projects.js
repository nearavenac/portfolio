export const projects = [
  {
    id: 1,
    title: "Asientos",
    description: "Contabilidad automatizada con IA para empresas chilenas. Sincroniza bancos, integra SII y genera asientos contables automáticamente.",
    subdomain: "asientos",
    technologies: ["React", "FastAPI", "PostgreSQL", "Fintoc"],
    image: "/projects/asientos.png?v=2"
  },
  {
    id: 2,
    title: "Reqlut",
    description: "Plataforma de empleo chilena que conecta candidatos y empresas usando RIAH™, su sistema de IA para matching laboral.",
    subdomain: "reqlut",
    technologies: ["PHP", "Symfony", "MySQL", "Bootstrap"],
    image: "/projects/reqlut.png?v=2"
  },
  {
    id: 3,
    title: "SoyMomo",
    description: "Sistema de gestión de licencias para dispositivos SoyMomo. Sincronización con API Kidmode, dashboard de métricas y exportación de datos.",
    subdomain: "soymomo",
    technologies: ["FastAPI", "PostgreSQL", "Bootstrap", "Chart.js"],
    image: "/projects/soymomo.png",
    nicoappsOnly: true
  },
  {
    id: 4,
    title: "DrApp",
    description: "Plataforma médica integral con portales para profesionales, centros de salud y pacientes. Gestión de citas, fichas clínicas, pagos y telemedicina.",
    subdomain: "drapp",
    technologies: ["PHP", "Symfony", "MySQL", "Twig"],
    image: "/projects/drapp.png?v=2",
    nicoappsOnly: true,
    portals: [
      { name: "Profesionales", subdomain: "ion" },
      { name: "Centros", subdomain: "center" },
      { name: "Pacientes", subdomain: "pacientes" },
      { name: "Principal", subdomain: "drapp" }
    ]
  },
  {
    id: 5,
    title: "Gasmaule",
    description: "Sistema de gestión para distribución de gas. Ventas, inventario, despachos, clientes, facturación electrónica y app móvil para repartidores.",
    subdomain: "gasmaule",
    technologies: ["Laravel", "Vue.js", "MySQL", "Redis"],
    image: "/projects/gasmaule.png",
    nicoappsOnly: true
  },
  {
    id: 6,
    title: "Video Generator",
    description: "Generador de videos cortos estilo TikTok usando IA. Crea guiones con Gemini, genera audio y compone videos automáticamente.",
    subdomain: "video",
    technologies: ["React", "FastAPI", "Celery", "Gemini AI"],
    image: "/projects/video.png?v=2",
    nicoappsOnly: true
  }
]

// Get the base domain from current hostname
export function getBaseDomain() {
  if (typeof window === 'undefined') return 'nicodev.work'

  const hostname = window.location.hostname

  // Map of supported domains
  if (hostname.includes('nicoapps.com')) return 'nicoapps.com'
  if (hostname.includes('nicodev.work')) return 'nicodev.work'

  // Default for localhost/development
  return 'nicodev.work'
}

// Build project URL based on current domain
export function getProjectUrl(subdomain) {
  const baseDomain = getBaseDomain()
  return `https://${subdomain}.${baseDomain}`
}

// Check if current domain is nicoapps.com
export function isNicoapps() {
  if (typeof window === 'undefined') return false
  return window.location.hostname.includes('nicoapps.com')
}

// Get filtered projects based on current domain
export function getFilteredProjects() {
  const showNicoappsOnly = isNicoapps()
  return projects.filter(p => !p.nicoappsOnly || showNicoappsOnly)
}
