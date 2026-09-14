import { queryKeys } from "@/api/queryKeys";
import { getSeatsForShowtime, getShowtimes } from "@/api/showtimes.api";
import { useQuery } from "@tanstack/react-query";

export function useGetShowtimes() {
    return useQuery({
        queryKey: queryKeys.showtimes.getAll,
        queryFn: ({ signal }) => getShowtimes({ signal })
    });
}

export function useGetSeatsForShowtime(showtimeId: string) {
    return useQuery({
        queryKey: queryKeys.showtimes.getSeatsForShowtime(showtimeId),
        queryFn: ({ signal }) => getSeatsForShowtime({ showtimeId, signal })
    });
}