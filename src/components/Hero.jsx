function Hero() {
  return (
    <section className="hero">
      <div className="hero-content">
        <div className="hero-badge">Desarrollador Full Stack</div>
        <h1 className="hero-title">
          Hola, soy <span className="hero-name">Nico</span>
        </h1>
        <p className="hero-description">
          Construyo aplicaciones web modernas y funcionales.
          Aquí encontrarás mis proyectos más recientes.
        </p>
        <div className="hero-cta">
          <a href="#projects" className="btn btn-primary">
            Ver proyectos
          </a>
        </div>
      </div>
      <div className="hero-decoration">
        <div className="hero-blob"></div>
      </div>
    </section>
  )
}

export default Hero
