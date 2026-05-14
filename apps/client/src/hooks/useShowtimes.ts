import { queryKeys } from "@/api/queryKeys";
import { getShowtimes } from "@/api/showtimes.api";
import { useQuery } from "@tanstack/react-query";

export function useGetShowtimes() {
    return useQuery({
        queryKey: queryKeys.showtimes.getAll,
        queryFn: ({ signal }) => getShowtimes({ signal })
    })
}