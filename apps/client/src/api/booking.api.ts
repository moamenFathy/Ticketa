import { type BookingResultDto, type BookingCreateDto } from "@/types/bookings";
import api from "./client";

export const bookingApis = {
  create: (dto: BookingCreateDto) => 
    api.post<BookingResultDto>("bookings", dto).then((res) => res.data),
}