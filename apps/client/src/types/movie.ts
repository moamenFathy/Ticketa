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

export type MovieDetails = Movie & {
  overview: string;
  backdropPath?: string | null;
  trailerKey: string | null;
  cast: Cast[];
};

export type Cast = {
  name: string;
  character: string;
  profile_path: string | null;
  order: number;
};