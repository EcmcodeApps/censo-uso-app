import React from 'react';
import { CensusResponse } from '../types';

interface ResultCardProps {
  result: CensusResponse | null;
  onReset: () => void;
}

export const ResultCard: React.FC<ResultCardProps> = ({ result, onReset }) => {
  if (!result) return null;

  const isSuccess = result.success;

  return (
    <div className={`mt-6 p-6 rounded-lg shadow-lg border-l-8 ${isSuccess ? 'bg-green-50 border-green-600' : 'bg-red-50 border-red-600'}`}>
      <div className="flex flex-col items-center text-center">
        {isSuccess ? (
          <>
            <div className="mb-4 bg-green-100 p-3 rounded-full">
              <svg className="w-8 h-8 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
              </svg>
            </div>
            <h3 className="text-xl font-bold text-green-800 mb-2">
              ¡Habilitado para Votar!
            </h3>
            <p className="text-lg text-gray-800 font-medium mb-1">
              {result.data?.nombres} {result.data?.apellidos}
            </p>
            <p className="text-gray-600 mb-4">
              C.C. {result.data?.cedula}
            </p>
            <p className="text-sm text-green-700 bg-green-100 p-3 rounded border border-green-200">
              {result.message}
            </p>
          </>
        ) : (
          <>
            <div className="mb-4 bg-red-100 p-3 rounded-full">
              <svg className="w-8 h-8 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
              </svg>
            </div>
            <h3 className="text-xl font-bold text-red-800 mb-2">
              No encontrado en el Censo
            </h3>
            <p className="text-red-700">
              {result.message}
            </p>
          </>
        )}
        
        <button
          onClick={onReset}
          className="mt-6 px-6 py-2 bg-gray-800 text-white rounded-md hover:bg-gray-700 transition-colors duration-200"
        >
          Realizar otra consulta
        </button>
      </div>
    </div>
  );
};