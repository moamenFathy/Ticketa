import api from "./client";
import type { MoviesShowtimes, ShowtimeSeats } from "@/types/showtimes";

export async function getShowtimes({ signal }: { signal?: AbortSignal }) {
    const { data } = await api.get<MoviesShowtimes[]>("movies/nowShowing", { signal });
    return data;
}

export async function getSeatsForShowtime({ showtimeId, signal }: { showtimeId: string; signal?: AbortSignal }) {
    const { data } = await api.get<ShowtimeSeats>(`showtime/${showtimeId}/seats`, { signal });
    return data;
}