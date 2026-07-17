import { getComingSoonMovies, getMostPopularMovies, getMovieDetails, getNowPlayingMovies } from "@/api/movies.api";
import { queryKeys } from "@/api/queryKeys";
import { useInfiniteQuery, useQuery } from "@tanstack/react-query";

export function useNowPlayingMovies(pageSize = 30) {
    return useInfiniteQuery({
        queryKey: queryKeys.movies.nowPlaying,
        queryFn: ({ pageParam, signal }) => getNowPlayingMovies(pageParam, pageSize, { signal }),
        initialPageParam: 1,
        getNextPageParam: (lastPage) => lastPage.hasMore ? lastPage.page + 1 : undefined,
    })
}

export function useComingSoonMovies() {
    return useQuery({
        queryKey: queryKeys.movies.comingSoon,
        queryFn: ({ signal }) => getComingSoonMovies({ signal })
    })
}

export function useMovieDetails(movieId: string) {
    return useQuery({
        queryKey: queryKeys.movies.movieDetails(movieId),
        queryFn: ({ signal }) => getMovieDetails(movieId, { signal })
    })
}

export function useMostPopularMovies() {
  return useQuery({
    queryKey: queryKeys.movies.mostPopular,
    queryFn: ({ signal }) => getMostPopularMovies({ signal })
  })
}