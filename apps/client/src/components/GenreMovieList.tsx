import type { Movie } from "@/types/movie";
import MovieList from "./MovieList";
import { useMemo } from "react";
import { Film } from "lucide-react";
import { movieByGenre } from "@/lib/utils";

interface GenreMovieListProps {
  movies: Movie[];
}

export function GenreMovieList({ movies }: GenreMovieListProps) {
  const { sections, smallMovies } = useMemo(
    () => movieByGenre(movies),
    [movies],
  );

  if (movies.length === 0) return null;

  return (
    <div>
      {sections.map(({ genre, movies: genreMovies }) => (
        <div key={genre} className="mb-10">
          <div className="flex items-center gap-3 px-6 mb-4">
            <Film className="w-5 h-5 text-primary shrink-0" />
            <h2 className="text-xl font-bold">{genre}</h2>
            <span className="text-sm text-muted-foreground">
              {genreMovies.length}{" "}
              {genreMovies.length === 1 ? "movie" : "movies"}
            </span>
          </div>
          <MovieList movies={genreMovies} />
        </div>
      ))}

      {smallMovies.length > 0 && (
        <div className="mb-10">
          <div className="flex items-center gap-3 px-6 mb-4">
            <Film className="w-5 h-5 text-primary shrink-0" />
            <h2 className="text-xl font-bold">More Movies</h2>
            <span className="text-sm text-muted-foreground">
              {smallMovies.length} movies
            </span>
          </div>
          <MovieList movies={smallMovies} />
        </div>
      )}
    </div>
  );
}

export default GenreMovieList;
