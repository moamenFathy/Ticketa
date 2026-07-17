export type ProfileDto = {
  firstName: string;
  lastName: string;
  email: string;
  dateOfBirth: string;
  theme: string;
};

export type ProfileUpdateDto = {
  firstName: string;
  lastName: string;
  dateOfBirth: string;
  theme: string;
};

export type ChangePasswordDto = {
  currentPassword: string;
  newPassword: string;
  confirmNewPassword: string;
};

export type BookingHistoryItemDto = {
  bookingReference: string;
  movieTitle: string;
  moviePosterPath?: string;
  showtimeStartsAt: string;
  seatCount: number;
  totalAmount: number;
  status: string;
};