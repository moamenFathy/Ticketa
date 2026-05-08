export type Movie = {
  id: string;
  title: string;
  posterPath: string | null;
  backdropPath?: string | null;
  voteAverage: number;
  runtime?: number;
  language?: string;
  genres: string[];
  overview?: string;
  releaseDate?: string;
};