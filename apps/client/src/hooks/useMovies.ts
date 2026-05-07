import { getMovieDetails, getNowPlayingMovies } from "@/api/movies.api";
import { queryKeys } from "@/api/queryKeys";
import { useQuery } from "@tanstack/react-query";

export function useNowPlayingMovies() {
    return useQuery({
        queryKey: queryKeys.movies.nowPlaying,
        queryFn: ({ signal }) => getNowPlayingMovies({ signal })
    })
}

export function useMovieDetails(movieId: string) {
    return useQuery({
        queryKey: queryKeys.movies.movieDetails(movieId),
        queryFn: ({ signal }) => getMovieDetails(movieId, { signal })
    })
}