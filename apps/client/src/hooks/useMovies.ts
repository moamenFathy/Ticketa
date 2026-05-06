import { getNowPlayingMovies } from "@/api/movies.api";
import { queryKeys } from "@/api/queryKeys";
import { useQuery } from "@tanstack/react-query";

export function useNowPlayingMovies() {
    return useQuery({
        queryKey: queryKeys.movies.nowPlaying,
        queryFn: getNowPlayingMovies
    })
}