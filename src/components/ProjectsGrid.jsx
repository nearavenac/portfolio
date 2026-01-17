import ProjectCard from './ProjectCard'
import { getFilteredProjects } from '../data/projects'

function ProjectsGrid({ onReqlutClick, onDrappClick }) {
  const projects = getFilteredProjects()

  return (
    <section id="projects" className="projects-section">
      <div className="projects-header">
        <h2 className="section-title">Proyectos</h2>
        <p className="section-subtitle">
          Aplicaciones y herramientas que he construido
        </p>
      </div>
      <div className="projects-grid">
        {projects.map((project) => (
          <ProjectCard
            key={project.id}
            project={project}
            onReqlutClick={onReqlutClick}
            onDrappClick={onDrappClick}
          />
        ))}
      </div>
    </section>
  )
}

export default ProjectsGrid
