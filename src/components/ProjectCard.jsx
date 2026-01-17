import { getProjectUrl } from '../data/projects'

function ProjectCard({ project, onReqlutClick, onDrappClick }) {
  const projectUrl = getProjectUrl(project.subdomain)
  const isReqlut = project.subdomain === 'reqlut'
  const isDrapp = project.subdomain === 'drapp'
  const hasPortals = isReqlut || isDrapp

  const handleClick = (e) => {
    if (isReqlut && onReqlutClick) {
      e.preventDefault()
      onReqlutClick()
    } else if (isDrapp && onDrappClick) {
      e.preventDefault()
      onDrappClick()
    }
  }

  return (
    <a
      href={hasPortals ? '#' : projectUrl}
      target={hasPortals ? undefined : "_blank"}
      rel={hasPortals ? undefined : "noopener noreferrer"}
      className="project-card"
      onClick={handleClick}
    >
      <div className="project-image">
        {project.image ? (
          <img src={project.image} alt={project.title} />
        ) : (
          <div className="project-placeholder">
            <span>{project.title.charAt(0)}</span>
          </div>
        )}
      </div>
      <div className="project-info">
        <h3 className="project-title">{project.title}</h3>
        <p className="project-description">{project.description}</p>
        <div className="project-technologies">
          {project.technologies.map((tech, index) => (
            <span key={index} className="tech-badge">{tech}</span>
          ))}
        </div>
        <div className="project-link">
          <span>{hasPortals ? 'Ver portales' : 'Visitar'}</span>
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
            {hasPortals ? (
              <path d="M9 18l6-6-6-6"/>
            ) : (
              <path d="M7 17L17 7M17 7H7M17 7V17"/>
            )}
          </svg>
        </div>
      </div>
    </a>
  )
}

export default ProjectCard
