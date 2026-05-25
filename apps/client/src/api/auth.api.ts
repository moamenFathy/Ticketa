import type { ConfirmEmailDto, loginDto, LoginResponseDto, RegisterDto } from "@/types/auth";
import api from "./client";

export const authApi = {
  login: (dto: loginDto) =>
    api.post<LoginResponseDto>("auth/login", dto).then((res) => res.data),

  refresh: () =>
    api.post<LoginResponseDto>("auth/refresh").then((res) => res.data),
  
  logout: () =>
    api.post("auth/logout"),

  register: (dto: RegisterDto) => 
    api.post<{ message: string }>("auth/register", dto).then((res) => res.data),

  confirmEmail: (dto: ConfirmEmailDto) =>
    api.post<LoginResponseDto>("auth/confirm-email", dto).then((res) => res.data),

  resendConfirmationEmail: (email: string) =>
    api.post<{ message: string }>("auth/resend-confirmation", { email }).then((res) => res.data),

  googleAuth: (idToken: string)=> {
    return api.post<LoginResponseDto>("auth/google", { idToken }).then((res) => res.data)
  }
}