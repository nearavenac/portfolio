import { useState } from 'react'
import Header from './components/Header'
import Hero from './components/Hero'
import ProjectsGrid from './components/ProjectsGrid'
import Footer from './components/Footer'
import PortalsModal from './components/PortalsModal'
import DrappModal from './components/DrappModal'
import { fetchPortals } from './data/portals'
import './styles/index.css'

function App() {
  const [isReqlutModalOpen, setIsReqlutModalOpen] = useState(false)
  const [isDrappModalOpen, setIsDrappModalOpen] = useState(false)
  const [portals, setPortals] = useState([])
  const [isLoading, setIsLoading] = useState(false)

  const handleOpenReqlutModal = async () => {
    setIsReqlutModalOpen(true)
    if (portals.length === 0) {
      setIsLoading(true)
      const data = await fetchPortals()
      setPortals(data)
      setIsLoading(false)
    }
  }

  const handleOpenDrappModal = () => {
    setIsDrappModalOpen(true)
  }

  return (
    <>
      <Header />
      <main>
        <Hero />
        <ProjectsGrid
          onReqlutClick={handleOpenReqlutModal}
          onDrappClick={handleOpenDrappModal}
        />
      </main>
      <Footer />
      <PortalsModal
        isOpen={isReqlutModalOpen}
        onClose={() => setIsReqlutModalOpen(false)}
        portals={portals}
        isLoading={isLoading}
      />
      <DrappModal
        isOpen={isDrappModalOpen}
        onClose={() => setIsDrappModalOpen(false)}
      />
    </>
  )
}

export default App
