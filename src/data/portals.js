// Portal data from static JSON (exported via make reqlut-export-portals)
import portalsData from './portals.json'

/**
 * Get portals from static JSON
 * @returns {Promise<Array>} Array of portal objects
 */
export async function fetchPortals() {
  return portalsData || []
}

// For backwards compatibility
export const getPortals = () => portalsData || []
