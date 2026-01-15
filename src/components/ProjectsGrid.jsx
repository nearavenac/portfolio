import ProjectCard from './ProjectCard'
import { projects } from '../data/projects'

function ProjectsGrid() {
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
          <ProjectCard key={project.id} project={project} />
        ))}
      </div>
    </section>
  )
}

export default ProjectsGrid
