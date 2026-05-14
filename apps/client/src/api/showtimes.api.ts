import api from "./client";
import type { MoviesShowtimes } from "@/types/showtimes";

export async function getShowtimes({ signal }: { signal?: AbortSignal }) {
    const { data } = await api.get<MoviesShowtimes[]>("showtime", { signal });
    return data;
}