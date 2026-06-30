import { CATEGORY_COLORS } from "@/static/StaticData";
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