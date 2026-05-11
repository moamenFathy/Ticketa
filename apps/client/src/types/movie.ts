export type Movie = {
  id: string;
  title: string;
  posterPath: string | null;
  backdropPath?: string | null;
  voteAverage: number;
  runtime: number;
  language: string;
  genres: Genre[];
  overview: string;
  releaseDate: string;
};

export type MovieDetails = Movie & {
  cast: cast[];
};

type cast = {
  name: string;
  character: string;
  profile_path: string | null;
  order: number;
};

export type Genre = {
  id: number;
  name: string;
};
