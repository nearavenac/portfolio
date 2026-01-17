import { getProjectUrl } from '../data/projects'

const drappPortals = [
  {
    name: "Profesionales",
    subdomain: "ion",
    description: "Portal para profesionales de la salud",
    icon: "M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"
  },
  {
    name: "Centros",
    subdomain: "center",
    description: "Administracion de centros medicos",
    icon: "M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"
  },
  {
    name: "Pacientes",
    subdomain: "pacientes",
    description: "Portal de atencion al paciente",
    icon: "M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"
  },
  {
    name: "Principal",
    subdomain: "drapp",
    description: "Landing page de DrApp",
    icon: "M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"
  }
]

function DrappModal({ isOpen, onClose }) {
  if (!isOpen) return null

  const handleBackdropClick = (e) => {
    if (e.target === e.currentTarget) {
      onClose()
    }
  }

  return (
    <div className="modal-backdrop" onClick={handleBackdropClick}>
      <div className="modal-container drapp-modal">
        <div className="modal-header">
          <div className="modal-title-section">
            <h2 className="modal-title">Portales DrApp</h2>
            <span className="modal-count">{drappPortals.length} portales</span>
          </div>
          <button className="modal-close" onClick={onClose}>
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <path d="M18 6L6 18M6 6l12 12"/>
            </svg>
          </button>
        </div>

        <div className="modal-content">
          <div className="drapp-portals-grid">
            {drappPortals.map((portal) => (
              <a
                key={portal.subdomain}
                href={getProjectUrl(portal.subdomain)}
                target="_blank"
                rel="noopener noreferrer"
                className="drapp-portal-card"
              >
                <div className="drapp-portal-icon">
                  <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
                    <path d={portal.icon} strokeLinecap="round" strokeLinejoin="round"/>
                  </svg>
                </div>
                <div className="drapp-portal-info">
                  <h3 className="drapp-portal-name">{portal.name}</h3>
                  <p className="drapp-portal-desc">{portal.description}</p>
                </div>
                <div className="portal-arrow">
                  <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                    <path d="M7 17L17 7M17 7H7M17 7V17"/>
                  </svg>
                </div>
              </a>
            ))}
          </div>
        </div>
      </div>
    </div>
  )
}

export default DrappModal
