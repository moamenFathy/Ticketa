import type { AxiosError } from "axios";
import type { ApiError } from "../types/api";

export function normalizeApiError(error: AxiosError): ApiError {
  const status = error.response?.status;
  const data = error.response?.data as
    | {
        code?: string;
        message?: string;
        details?: unknown;
        conflictingSeats?: { row: number; seatNumber: number }[];
        conflictSeats?: { row: number; seatNumber: number }[];
      }
    | undefined;

  const seats = data?.conflictingSeats ?? data?.conflictSeats;

  return {
    code: data?.code ?? "UNKNOWN_ERROR",
    message: data?.message ?? error.message ?? "Something went wrong",
    status,
    details: data?.details,
    conflictingSeats: seats,
  };
}

export function isConflictError(error: ApiError): boolean {
  return error.status === 409;
}