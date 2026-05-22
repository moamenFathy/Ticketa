import { authApi } from "@/api/auth.api";
import { AuthContext } from "@/providers/AuthProvider"
import type { loginDto } from "@/types/auth";
import { useMutation } from "@tanstack/react-query";
import { useContext } from "react"
import { useNavigate, useSearchParams } from "react-router-dom";

export const useAuth = () => {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error("useAuth must be used within an AuthProvider");
  return ctx;
}

export const useLogin = () => {
  const { login } = useAuth();
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();

  return useMutation({
    mutationFn: async (dto: loginDto) => authApi.login(dto),
    onSuccess: (data) => {
      login(data.accessToken, data.user);
      const returnUrl = searchParams.get("returnUrl") || "/";
      navigate(returnUrl, { replace: true });
    },
  });
}

export const useLogout = () => {
  const { logout } = useAuth();
  const navigate = useNavigate();

  return useMutation({
    mutationFn: async () => logout(),
    onSuccess: () => navigate("/")
  })
}