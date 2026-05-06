import type { AxiosError } from "axios";
import type { ApiError } from "../types/api";

export function normalizeApiError(error: AxiosError): ApiError {
  const status = error.response?.status;
  const data = error.response?.data as
    | { code?: string; message?: string; details?: unknown }
    | undefined;

  return {
    code: data?.code ?? "UNKNOWN_ERROR",
    message: data?.message ?? error.message ?? "Something went wrong",
    status,
    details: data?.details,
  };
}