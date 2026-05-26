import { type BookingResultDto, type BookingCreateDto } from "@/types/bookings";
import api from "./client";

export async function createBooking(dto: BookingCreateDto) {
  return api.post<BookingResultDto>("Bookings", dto).then((res) => res.data);
}
