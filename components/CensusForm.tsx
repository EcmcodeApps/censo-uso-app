import React, { useState } from 'react';
import { SUBDIRECTIVAS } from '../constants';
import { SearchParams } from '../types';

interface CensusFormProps {
  onSubmit: (data: SearchParams) => void;
  isLoading: boolean;
}

export const CensusForm: React.FC<CensusFormProps> = ({ onSubmit, isLoading }) => {
  const [subdirectiva, setSubdirectiva] = useState<string>('');
  const [cedula, setCedula] = useState<string>('');
  const [error, setError] = useState<string>('');

  const handleCedulaChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const val = e.target.value;
    // Allow only numbers
    if (/^\d*$/.test(val)) {
        setCedula(val);
        setError('');
    }
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!subdirectiva) {
      setError('Por favor selecciona una subdirectiva.');
      return;
    }
    if (!cedula) {
      setError('Por favor ingresa tu número de cédula.');
      return;
    }
    
    // Safety check for dots, though input restriction helps prevent it
    if (cedula.includes('.') || cedula.includes(',')) {
        setError('Por favor ingresa la cédula sin puntos ni comas.');
        return;
    }

    onSubmit({ subdirectiva, cedula });
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-6">
      <div>
        <label htmlFor="subdirectiva" className="block text-sm font-bold text-gray-700 mb-2">
          Seleccione su Subdirectiva
        </label>
        <div className="relative">
            <select
            id="subdirectiva"
            value={subdirectiva}
            onChange={(e) => setSubdirectiva(e.target.value)}
            className="block w-full rounded-md border-gray-300 shadow-sm focus:border-yellow-500 focus:ring-yellow-500 bg-white p-3 border text-gray-700"
            disabled={isLoading}
            >
            <option value="">-- Seleccionar --</option>
            {SUBDIRECTIVAS.map((sub) => (
                <option key={sub} value={sub}>
                {sub}
                </option>
            ))}
            </select>
        </div>
      </div>

      <div>
        <label htmlFor="cedula" className="block text-sm font-bold text-gray-700 mb-2">
          Número de Cédula
        </label>
        <input
          type="text"
          id="cedula"
          value={cedula}
          onChange={handleCedulaChange}
          placeholder="Ej: 12345678 (Sin puntos)"
          className="block w-full rounded-md border-gray-300 shadow-sm focus:border-yellow-500 focus:ring-yellow-500 p-3 border"
          inputMode="numeric"
          disabled={isLoading}
        />
        <p className="mt-2 text-sm text-gray-500">
          * Ingrese solo números, sin puntos ni espacios.
        </p>
      </div>

      {error && (
        <div className="p-3 bg-red-100 border border-red-200 text-red-700 rounded text-sm">
          {error}
        </div>
      )}

      <button
        type="submit"
        disabled={isLoading}
        className={`w-full flex justify-center py-3 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-black bg-yellow-400 hover:bg-yellow-500 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-yellow-500 transition-colors ${isLoading ? 'opacity-70 cursor-not-allowed' : ''}`}
      >
        {isLoading ? (
            <span className="flex items-center">
                <svg className="animate-spin -ml-1 mr-3 h-5 w-5 text-black" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                    <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
                    <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                </svg>
                Consultando...
            </span>
        ) : 'Consultar Censo'}
      </button>
    </form>
  );
};