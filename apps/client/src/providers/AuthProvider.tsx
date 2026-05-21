import { authApi } from "@/api/auth.api";
import type { AuthUserDto } from "@/types/auth";
import { createContext, useCallback, useEffect, useState } from "react";

interface AuthProviderProps {
  user: AuthUserDto | null;
  accessToken: string | null;
  isLoggedIn: boolean;
  isInitializing: boolean;
  login: (token: string, user: AuthUserDto) => void;
  logout: () => Promise<void>;
}

const AuthContext = createContext<AuthProviderProps | null>(null);

export const AuthProvider = ({ children }: { children: React.ReactNode }) => {
  const [user, setUser] = useState<AuthUserDto | null>(null);
  const [accessToken, setAccessToken] = useState<string | null>(null);
  const [isInitializing, setIsInitializing] = useState(true);

  useEffect(() => {
    authApi
      .refresh()
      .then((data) => {
        setAccessToken(data.accessToken);
        setUser(data.user);
      })
      .catch(() => {})
      .finally(() => {
        setIsInitializing(false);
      });
  }, []);

  const login = useCallback((token: string, user: AuthUserDto) => {
    setAccessToken(token);
    setUser(user);
  }, []);

  const logout = useCallback(async () => {
    await authApi.logout();
    setAccessToken(null);
    setUser(null);
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
