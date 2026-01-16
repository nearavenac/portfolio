import { useState, useMemo } from 'react'

const AWS_BUCKET = 'https://reqlut2.s3.sa-east-1.amazonaws.com/reqlut-images'

function PortalsModal({ isOpen, onClose, portals, isLoading }) {
  const [search, setSearch] = useState('')

  const filteredPortals = useMemo(() => {
    if (!search.trim()) return portals
    const searchLower = search.toLowerCase()
    return portals.filter(portal =>
      portal.name.toLowerCase().includes(searchLower) ||
      portal.company.toLowerCase().includes(searchLower) ||
      String(portal.id).includes(searchLower)
    )
  }, [portals, search])

  if (!isOpen) return null

  const getPortalUrl = (portal) => {
    return `https://${portal.domain}`
  }

  const handleBackdropClick = (e) => {
    if (e.target === e.currentTarget) {
      onClose()
    }
  }

  return (
    <div className="modal-backdrop" onClick={handleBackdropClick}>
      <div className="modal-container">
        <div className="modal-header">
          <div className="modal-title-section">
            <h2 className="modal-title">Portales Reqlut</h2>
            {!isLoading && (
              <span className="modal-count">{filteredPortals.length} portales</span>
            )}
          </div>
          <button className="modal-close" onClick={onClose}>
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <path d="M18 6L6 18M6 6l12 12"/>
            </svg>
          </button>
        </div>

        <div className="modal-search">
          <svg className="search-icon" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
            <circle cx="11" cy="11" r="8"/>
            <path d="M21 21l-4.35-4.35"/>
          </svg>
          <input
            type="text"
            placeholder="Buscar por nombre, universidad o ID..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            className="search-input"
            autoFocus
            disabled={isLoading}
          />
          {search && (
            <button className="search-clear" onClick={() => setSearch('')}>
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                <path d="M18 6L6 18M6 6l12 12"/>
              </svg>
            </button>
          )}
        </div>

        <div className="modal-content">
          {isLoading ? (
            <div className="loading-state">
              <div className="loading-spinner"></div>
              <p>Cargando portales...</p>
            </div>
          ) : filteredPortals.length === 0 ? (
            <div className="no-results">
              <p>No se encontraron portales</p>
            </div>
          ) : (
            <div className="portals-grid">
              {filteredPortals.map((portal) => (
                <a
                  key={portal.id}
                  href={getPortalUrl(portal)}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="portal-card"
                >
                  <div className="portal-logo">
                    <img
                      src={`${AWS_BUCKET}/${portal.lower}/logo.png`}
                      alt={portal.name}
                      onError={(e) => {
                        e.target.style.display = 'none'
                        e.target.nextSibling.style.display = 'flex'
                      }}
                    />
                    <div className="portal-logo-fallback" style={{display: 'none'}}>
                      {portal.name.charAt(0)}
                    </div>
                  </div>
                  <div className="portal-info">
                    <h3 className="portal-name">{portal.name}</h3>
                    <p className="portal-company">{portal.company}</p>
                    <span className="portal-id">ID: {portal.id}</span>
                  </div>
                  <div className="portal-arrow">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                      <path d="M7 17L17 7M17 7H7M17 7V17"/>
                    </svg>
                  </div>
                </a>
              ))}
            </div>
          )}
        </div>
      </div>
    </div>
  )
}

export default PortalsModal
