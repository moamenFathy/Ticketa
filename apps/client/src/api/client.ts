import axios, { AxiosError } from "axios";
import { normalizeApiError } from "./errors";

const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL,
  timeout: 5000,
  headers: {
    "Content-Type": "application/json",
  },
  withCredentials: true,
})

let _accessToken: string | null = null;

export const setClientToken = (token: string | null) => {
  _accessToken = token;
};

api.interceptors.request.use(config => {
  if (_accessToken) {
    config.headers.Authorization = `Bearer ${_accessToken}`;
  }
  return config;
});

api.interceptors.response.use(
    response => response,
    (error: AxiosError) => Promise.reject(normalizeApiError(error))
)

export default api;
