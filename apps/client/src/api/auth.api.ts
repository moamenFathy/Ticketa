import type { loginDto, LoginResponseDto } from "@/types/auth";
import api from "./client";

export const authApi = {
  login: (dto: loginDto) =>
    api.post<LoginResponseDto>("auth/login", dto).then((res) => res.data),

  refresh: () =>
    api.post<LoginResponseDto>("auth/refresh").then((res) => res.data),
  
  logout: () =>
    api.post("auth/logout")
}