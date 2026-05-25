export type loginDto = {
  email: string;
  password: string;
}

export type RegisterDto = {
  email: string;
  password: string;
  dateOfBirth: string;
}

export type ConfirmEmailDto = {
  email: string;
  code: string;
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