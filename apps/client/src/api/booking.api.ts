import { type BookingResultDto, type BookingCreateDto, type BookingDetails } from "@/types/bookings";
import api from "./client";

export async function createBooking(dto: BookingCreateDto) {
  return api.post<BookingResultDto>("Bookings", dto).then((res) => res.data);
}

export async function getBooking(reference: string, {signal}: { signal?: AbortSignal }) {
  return api.get<BookingDetails>(`Bookings/${reference}`, { signal }).then((res) => {console.log(res.data); return res.data});
}