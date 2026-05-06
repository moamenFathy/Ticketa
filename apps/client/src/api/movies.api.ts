import type { Movie } from "@/types/movie";
import api from "./client";

export async function getNowPlayingMovies({ signal }: { signal?: AbortSignal }) {
    const { data } = await api.get<Movie[]>("/movies", { signal });
    return data;
}
