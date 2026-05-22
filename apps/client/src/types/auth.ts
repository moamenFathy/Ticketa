export type loginDto = {
  email: string;
  password: string;
}

export type AuthUserDto = {
  id: string;
  email: string;
  name: string;
}

export type LoginResponseDto = {
  accessToken: string;
  user: AuthUserDto;
}