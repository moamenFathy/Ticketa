import type { BookedSeat } from "./showtimes";

export type BookingCreateDto = {
  showtimeId: number;
  seats: BookedSeat[];
}

export type BookingResultDto = {
  succeeded: boolean;
  bookingReference?: string;
  totalAmount?: number;
  conflictingSeats: BookedSeat[];
}

export type BookingConfirmationState = {
  bookingReference: string;
  totalAmount: string;
  movieTitle: string;
  moviePosterPath?: string;
  hallName: string;
  hallType: string;
  startsAt: string;
  seats: BookedSeat[];
}