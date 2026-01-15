import Header from './components/Header'
import Hero from './components/Hero'
import ProjectsGrid from './components/ProjectsGrid'
import Footer from './components/Footer'
import './styles/index.css'

function App() {
  return (
    <>
      <Header />
      <main>
        <Hero />
        <ProjectsGrid />
      </main>
      <Footer />
    </>
  )
}

export default App
