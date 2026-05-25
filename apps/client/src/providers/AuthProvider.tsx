import { authApi } from "@/api/auth.api";
import { setClientToken } from "@/api/client";
import { getUserFromToken } from "@/lib/jwt";
import type { AuthUserDto } from "@/types/auth";
import { createContext, useCallback, useEffect, useRef, useState } from "react";

interface AuthProviderProps {
  user: AuthUserDto | null;
  accessToken: string | null;
  isLoggedIn: boolean;
  isInitializing: boolean;
  login: (token: string) => void;
  logout: () => Promise<void>;
}

const AuthContext = createContext<AuthProviderProps | null>(null);

export const AuthProvider = ({ children }: { children: React.ReactNode }) => {
  const [accessToken, setAccessToken] = useState<string | null>(null);
  const [isInitializing, setIsInitializing] = useState(true);
  const refreshed = useRef(false);

  const user = accessToken ? getUserFromToken(accessToken) : null;

  useEffect(() => {
    if (refreshed.current) return;
    refreshed.current = true;

    authApi
      .refresh()
      .then((data) => {
        setAccessToken(data.accessToken);
      })
      .catch(() => {})
      .finally(() => {
        setIsInitializing(false);
      });
  }, []);

  useEffect(() => {
    setClientToken(accessToken);
  }, [accessToken]);

  const login = useCallback((token: string) => {
    setAccessToken(token);
  }, []);

  const logout = useCallback(async () => {
    await authApi.logout();
    setAccessToken(null);
  }, []);

  return (
    <AuthContext.Provider
      value={{
        user,
        accessToken,
        isLoggedIn: !!user,
        isInitializing,
        login,
        logout,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
};

export { AuthContext };
