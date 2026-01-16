export interface CensusResponse {
  success: boolean;
  data?: {
    cedula: string;
    nombres: string;
    apellidos: string;
    subdirectiva: string;
  };
  message: string;
}

export interface SearchParams {
  subdirectiva: string;
  cedula: string;
}
