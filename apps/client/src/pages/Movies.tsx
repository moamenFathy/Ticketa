import { useEffect, useRef } from "react";
import { useNowPlayingMovies } from "@/hooks/useMovies";
import MovieCard from "@/components/MovieCard";
import { MovieListSkeleton } from "@/components/skeletons/MovieListSkeleton";
import ErrorState from "@/components/ErrorState";
import { Link } from "react-router-dom";
import { Film, Loader2 } from "lucide-react";

const Movies = () => {
  const {
    data,
    isLoading,
    isError,
    refetch,
    fetchNextPage,
    hasNextPage,
    isFetchingNextPage,
  } = useNowPlayingMovies(30);

  const movies = data?.pages.flatMap((p) => p.items) ?? [];
  const totalCount = data?.pages[0]?.totalCount ?? 0;

  const sentinelRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const el = sentinelRef.current;
    if (!el) return;

    const observer = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting && hasNextPage && !isFetchingNextPage) {
          fetchNextPage();
        }
      },
      { rootMargin: "400px" },
    );

    observer.observe(el);
    return () => observer.disconnect();
  }, [hasNextPage, isFetchingNextPage, fetchNextPage]);

  if (isLoading) return <MovieListSkeleton />;

  if (isError || !data?.pages[0]) {
    return <ErrorState refetch={refetch} />;
  }

  return (
    <div className="min-h-screen py-12 px-6 max-w-7xl mx-auto">
      <div className="flex items-center gap-3 mb-10">
        <Film className="w-7 h-7 text-primary" />
        <h1 className="text-3xl font-black tracking-tight">Now Showing</h1>
        <span className="text-muted-foreground text-sm mt-1.5">
          {totalCount} {totalCount === 1 ? "movie" : "movies"}
        </span>
      </div>

      {movies.length === 0 ? (
        <p className="text-muted-foreground text-center py-24 text-lg">
          No movies showing right now. Check back later!
        </p>
      ) : (
        <>
          <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-6 mb-12">
            {movies.map((movie) => (
              <Link key={movie.id} to={`/movies/${movie.id}`} className="block">
                <MovieCard movie={movie} compact />
              </Link>
            ))}
          </div>

          <div ref={sentinelRef} className="flex justify-center py-8">
            {isFetchingNextPage && (
              <Loader2 className="size-6 animate-spin text-muted-foreground" />
            )}
            {!hasNextPage && movies.length >= totalCount && (
              <p className="text-muted-foreground text-sm">
                You've reached the end
              </p>
            )}
          </div>
        </>
      )}
    </div>
  );
};

export default Movies;
