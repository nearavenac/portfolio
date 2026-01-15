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
    technologies: ["React", "Node.js", "MongoDB", "IA"],
    image: "/projects/reqlut.png?v=2"
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
