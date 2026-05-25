import type { AuthUserDto } from "@/types/auth";

export interface TokenPayload {
  uid: string;
  name: string;
  email: string;
  role?: string | string[];
  exp: number;
}

export const parseJwt = (token: string): TokenPayload | null => {
 const base64 = token.split('.')[1];
 if (!base64) return null;
 try {
   const json = atob(base64);
   return JSON.parse(json);
 } catch {
   return null;
 }
}

export const getUserFromToken = (token: string): AuthUserDto | null => {
  const payload = parseJwt(token);
  if (!payload) return null;
  return {
    id:    payload.uid,
    email: payload.email,
    name:  payload.name,
    roles: Array.isArray(payload.role)
             ? payload.role
             : payload.role ? [payload.role] : [],
  };
};