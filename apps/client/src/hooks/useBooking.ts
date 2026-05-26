import { createBooking, getBooking } from "@/api/booking.api"
import { queryKeys } from "@/api/queryKeys";
import type { BookingCreateDto } from "@/types/bookings"
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query"

export const useCreateBooking = () => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationKey: queryKeys.bookings.create,
    mutationFn: (dto: BookingCreateDto) => createBooking(dto),
    onSuccess: (_data, variables) => {
      queryClient.invalidateQueries({ queryKey: queryKeys.showtimes.getSeatsForShowtime(String(variables.showtimeId)) });
    }
  })
}

export const useGetBooking = (reference: string) => {
  return useQuery({
    queryKey: queryKeys.bookings.getBooking(reference),
    queryFn: ({ signal }) => getBooking(reference, { signal }),
    enabled: !!reference,
  });
}