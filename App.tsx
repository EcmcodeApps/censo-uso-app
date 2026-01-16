import React, { useState } from 'react';
import { CensusForm } from './components/CensusForm';
import { ResultCard } from './components/ResultCard';
import { checkCensusEligibility } from './components/censusService';
import { CensusResponse, SearchParams } from './types';

function App() {
  const [loading, setLoading] = useState(false);
  const [result, setResult] = useState<CensusResponse | null>(null);

  const handleSearch = async (params: SearchParams) => {
    setLoading(true);
    setResult(null);
    
    // Consultar API
    const data = await checkCensusEligibility(params);
    
    setResult(data);
    setLoading(false);
  };

  const handleReset = () => {
    setResult(null);
  };

  return (
    <div className="min-h-screen bg-gray-100 flex flex-col font-roboto">
      {/* Header Corporativo */}
      <header className="bg-yellow-400 shadow-md">
        <div className="max-w-7xl mx-auto py-4 px-4 sm:px-6 lg:px-8 flex items-center justify-center sm:justify-between">
            <div className="flex items-center space-x-3">
                {/* Logo Placeholder - Círculo negro simulando logo USO */}
                <div className="bg-black text-yellow-400 font-bold rounded-full h-12 w-12 flex items-center justify-center border-2 border-white shadow-sm">
                    USO
                </div>
                <div>
                    <h1 className="text-2xl font-black text-gray-900 tracking-tight leading-none">
                        USO
                    </h1>
                    <p className="text-xs font-bold text-gray-800 uppercase tracking-wider">
                        Unión Sindical Obrera
                    </p>
                </div>
            </div>
            <div className="hidden sm:block text-right">
                <p className="text-sm font-semibold text-gray-900">Elecciones de Delegados</p>
                <p className="text-xs text-gray-800">Negociación Colectiva Ecopetrol</p>
            </div>
        </div>
      </header>

      {/* Contenido Principal */}
      <main className="flex-grow flex flex-col justify-center py-10 sm:px-6 lg:px-8">
        <div className="sm:mx-auto sm:w-full sm:max-w-md">
          <div className="bg-white py-8 px-4 shadow-2xl rounded-xl sm:px-10 border-t-8 border-black">
            
            <div className="text-center mb-8">
                <h2 className="text-2xl font-bold text-gray-900 mb-2">
                Consulta Censo de Votación
                </h2>
                <div className="h-1 w-20 bg-yellow-400 mx-auto rounded"></div>
            </div>

            {!result ? (
               <>
                 <p className="mb-6 text-gray-600 text-sm text-center bg-gray-50 p-3 rounded border border-gray-200">
                   Ingrese sus datos para verificar si está habilitado para votar en su Subdirectiva.
                 </p>
                 <CensusForm onSubmit={handleSearch} isLoading={loading} />
               </>
            ) : (
              <ResultCard result={result} onReset={handleReset} />
            )}
          </div>
          
          <div className="mt-8 text-center">
             <p className="text-xs text-gray-500 max-w-xs mx-auto">
                Si presenta inconvenientes, por favor contacte a la junta directiva de su subdirectiva correspondiente.
             </p>
          </div>
        </div>
      </main>

      {/* Footer */}
      <footer className="bg-gray-800 text-white py-4 mt-auto">
          <div className="max-w-7xl mx-auto px-4 text-center">
              <p className="text-sm font-medium">© {new Date().getFullYear()} Unión Sindical Obrera de la Industria del Petróleo - USO</p>
          </div>
      </footer>
    </div>
  );
}

export default App;