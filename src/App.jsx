import { useState, useEffect } from 'react'
import Header from './components/Header'
import Hero from './components/Hero'
import ProjectsGrid from './components/ProjectsGrid'
import Footer from './components/Footer'
import PortalsModal from './components/PortalsModal'
import { fetchPortals } from './data/portals'
import './styles/index.css'

function App() {
  const [isModalOpen, setIsModalOpen] = useState(false)
  const [portals, setPortals] = useState([])
  const [isLoading, setIsLoading] = useState(false)

  const handleOpenModal = async () => {
    setIsModalOpen(true)
    if (portals.length === 0) {
      setIsLoading(true)
      const data = await fetchPortals()
      setPortals(data)
      setIsLoading(false)
    }
  }

  return (
    <>
      <Header />
      <main>
        <Hero />
        <ProjectsGrid onReqlutClick={handleOpenModal} />
      </main>
      <Footer />
      <PortalsModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        portals={portals}
        isLoading={isLoading}
      />
    </>
  )
}

export default App
