import type { loginDto, LoginResponseDto } from "@/types/auth";
import client from "./client";

export const authApi = {
  login: (dto: loginDto) =>
     client.post<LoginResponseDto>("auth/login", dto).then((res) => res.data),

  refresh: () =>
    client.post<LoginResponseDto>("auth/refresh").then((res) => res.data),
  
  logout: () =>
    client.post("auth/logout")
}