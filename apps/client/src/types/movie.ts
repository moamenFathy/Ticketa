export type Movie = {
  id: string;
  title: string;
  posterPath: string | null;
  voteAverage: number;
  runtime: number;
  backdropPath?: string | null;
  overview: string;
  language: string;
  genres: string[];
  releaseDate: string;
};

export type MostPopularMovies = {
  id: string;
  title: string;
  posterPath?: string;
  backdropPath?: string;
  overview: string;
  voteAverage: number;
  runtime: number;
  genres: string[];
}

export type MovieDetails = Movie & {
  overview: string;
  backdropPath?: string | null;
  trailerKey: string | null;
  cast: Cast[];
  imdbId?: string;
  tmdbId?: number;
};

export type Cast = {
  name: string;
  character: string;
  profile_path: string | null;
  order: number;
};