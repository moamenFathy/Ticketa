import axios, { AxiosError } from "axios";
import { normalizeApiError } from "./errors";

const api = axios.create({
    baseURL: import.meta.env.VITE_API_URL,
    timeout: 5000,
    headers: {
        "Content-Type": "application/json",
    },
})

api.interceptors.response.use(
    response => response,
    (error: AxiosError) => Promise.reject(normalizeApiError(error))
)

export default api;
