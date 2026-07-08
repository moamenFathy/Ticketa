import { CATEGORY_COLORS } from "@/static/StaticData";
import type { Movie } from "@/types/movie";
import { clsx, type ClassValue } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}

export function getCategoryStyle(category: string) {
  return CATEGORY_COLORS[category] ?? CATEGORY_COLORS["Default"];
}

export function seatKey(row: number, seat: number) {
  return `${row}-${seat}`;
}

export function rowLabel(rowIndex: number) {
  return String.fromCharCode(65 + rowIndex);
}

// Stadium bowl shape: how many seats to skip on each side of a row
export function getSkip(rowIndex: number, totalRows: number): number {
  if (rowIndex === 0) return 3;
  if (rowIndex === totalRows - 1) return 2;
  return 0;
}

// Total invisible spacer seats (skipped left + right per row)
export function getInvisibleCount(rows: number): number {
  let count = 0;
  for (let r = 0; r < rows; r++) {
    count += getSkip(r, rows) * 2;
  }
  return count;
}

const MIN_MOVIES_PER_CAROUSEL = 2;
const FALLBACK_GENRE = "All Now Showing";
 
// Fixed priority order for primary-genre selection.
// A movie tagged with multiple genres always lands in the same
// carousel regardless of the order TMDB/the API returns them in.
const GENRE_PRIORITY = [
  "Action",
  "Drama",
  "Comedy",
  "Thriller",
  "Adventure",
  "Family",
  "Fantasy",
  "Science Fiction",
  "Horror",
  "Romance",
  "Animation",
];
 
function getPrimaryGenre(movie: Movie): string {
  const found = GENRE_PRIORITY.find((g) => movie.genres.includes(g));
  return found ?? movie.genres[0] ?? FALLBACK_GENRE;
}
 
export function groupMoviesByGenre(movies: Movie[]) {
  const genreMap = new Map<string, Movie[]>();
 
  movies.forEach((movie) => {
    const primaryGenre = getPrimaryGenre(movie);
    const list = genreMap.get(primaryGenre) || [];
    list.push(movie);
    genreMap.set(primaryGenre, list);
  });
 
  const sorted = [...genreMap.entries()]
    .map(([genre, list]) => ({ genre, movies: list }))
    .sort((a, b) => b.movies.length - a.movies.length);
 
  const main = sorted.filter(
    (s) => s.movies.length >= MIN_MOVIES_PER_CAROUSEL || s.genre === FALLBACK_GENRE,
  );
 
  const small = sorted.filter(
    (s) => s.movies.length < MIN_MOVIES_PER_CAROUSEL && s.genre !== FALLBACK_GENRE,
  );
 
  // Flatten leftover single-movie genres into one "misc" bucket.
  // Note: since each movie is bucketed by exactly one primary genre,
  // a movie can never appear in more than one `small` group — so no
  // dedup guard is needed here, unlike a multi-genre bucketing scheme.
  const smallMovies: Movie[] = small.flatMap((s) => s.movies);
 
  return { sections: main, smallMovies };
}