import { useNowPlayingMovies } from "@/hooks/useMovies";
import MovieCard from "@/components/MovieCard";
import { MovieListSkeleton } from "@/components/skeletons/MovieListSkeleton";
import ErrorState from "@/components/ErrorState";
import { Link } from "react-router-dom";
import { Film } from "lucide-react";

const Movies = () => {
  const {
    data: movies,
    isLoading,
    isError,
    refetch,
  } = useNowPlayingMovies();

  if (isLoading) return <MovieListSkeleton />;

  if (isError || !movies) {
    return <ErrorState refetch={refetch} />;
  }

  return (
    <div className="min-h-screen py-12 px-6 max-w-7xl mx-auto">
      <div className="flex items-center gap-3 mb-10">
        <Film className="w-7 h-7 text-primary" />
        <h1 className="text-3xl font-black tracking-tight">Now Showing</h1>
        <span className="text-muted-foreground text-sm mt-1.5">
          {movies.length} {movies.length === 1 ? "movie" : "movies"}
        </span>
      </div>

      {movies.length === 0 ? (
        <p className="text-muted-foreground text-center py-24 text-lg">
          No movies showing right now. Check back later!
        </p>
      ) : (
        <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-6">
          {movies.map((movie) => (
            <Link
              key={movie.id}
              to={`/movies/${movie.id}`}
              className="block"
            >
              <MovieCard movie={movie} compact />
            </Link>
          ))}
        </div>
      )}
    </div>
  );
};

export default Movies;
