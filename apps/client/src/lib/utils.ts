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