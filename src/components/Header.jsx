function Header() {
  return (
    <header className="header">
      <div className="header-content">
        <a href="/" className="logo">
          <span className="logo-icon">N</span>
          <span className="logo-text">nico</span>
        </a>
        <nav className="nav">
          <a href="#projects" className="nav-link">Proyectos</a>
          <a href="https://github.com/nico" target="_blank" rel="noopener noreferrer" className="nav-link">
            GitHub
          </a>
        </nav>
      </div>
    </header>
  )
}

export default Header
