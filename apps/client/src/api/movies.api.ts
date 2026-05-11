import type { Movie, MovieDetails } from "@/types/movie";
import api from "./client";

export async function getNowPlayingMovies({ signal }: { signal?: AbortSignal }) {
    const { data } = await api.get<Movie[]>("movies", { signal });
    return data;
}

export async function getMovieDetails(id: string, { signal }: { signal?: AbortSignal }) {
    const { data } = await api.get<MovieDetails>(`movies/${id}`, { signal });
    return data;
}
