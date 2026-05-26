import { bookingApis } from "@/api/booking.api"
import { queryKeys } from "@/api/queryKeys";
import type { BookingCreateDto } from "@/types/bookings"
import { QueryClient, useMutation } from "@tanstack/react-query"

export const useCreateBooking = () => {
  const queryClient = new QueryClient();
  useMutation({
    mutationFn: (dto: BookingCreateDto) => bookingApis.create(dto),

    onSuccess: (_data, variables) => {
      queryClient.invalidateQueries({ queryKey: queryKeys.showtimes.getSeatsForShowtime(variables.showtimeId) });
    }
  })
}