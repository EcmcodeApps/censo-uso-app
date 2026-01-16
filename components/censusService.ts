import { CensusResponse, SearchParams } from '../types';
import { GOOGLE_SCRIPT_URL } from '../constants';

export const checkCensusEligibility = async (params: SearchParams): Promise<CensusResponse> => {
  if (GOOGLE_SCRIPT_URL === 'YOUR_GOOGLE_APPS_SCRIPT_WEB_APP_URL_HERE') {
    return {
      success: false,
      message: 'Error de Configuración: La URL del Google Script no ha sido configurada en la aplicación web.'
    };
  }

  try {
    // We use a GET request to avoid CORS complexity with simple Apps Script Web Apps
    const url = new URL(GOOGLE_SCRIPT_URL);
    url.searchParams.append('subdirectiva', params.subdirectiva);
    url.searchParams.append('cedula', params.cedula);

    const response = await fetch(url.toString(), {
      method: 'GET',
    });

    if (!response.ok) {
      throw new Error('Error de conexión con el servidor.');
    }

    const result: CensusResponse = await response.json();
    return result;

  } catch (error) {
    console.error("Census Check Error", error);
    return {
      success: false,
      message: 'Hubo un error al consultar el censo. Por favor intente más tarde.'
    };
  }
};