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

export function movieByGenre(movies: Movie[]) {
      const genreMap = new Map<string, Movie[]>();

    movies.forEach((movie) => {
      if (movie.genres.length === 0) {
        const list = genreMap.get("All Now Showing") || [];
        list.push(movie);
        genreMap.set("All Now Showing", list);
        return;
      }
      const primaryGenre = movie.genres[0];
      const list = genreMap.get(primaryGenre) || [];
      list.push(movie);
      genreMap.set(primaryGenre, list);
    });

    console.log(genreMap);

    const sorted = [...genreMap.entries()]
      .map(([genre, list]) => ({ genre, movies: list }))
      .sort((a, b) => b.movies.length - a.movies.length);

      console.log(sorted)

    const main = sorted.filter(
      (s) => s.movies.length >= 2 || s.genre === "All Now Showing",
    );
    const small = sorted.filter(
      (s) => s.movies.length < 2 && s.genre !== "All Now Showing",
    );

    const seen = new Set<string>();
    const mergedSmall: Movie[] = [];
    small.forEach((s) =>
      s.movies.forEach((m) => {
        if (!seen.has(m.id)) {
          seen.add(m.id);
          mergedSmall.push(m);
        }
      }),
    );

    return { sections: main, smallMovies: mergedSmall };
}