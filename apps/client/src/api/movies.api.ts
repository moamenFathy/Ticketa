import type { Movie } from "@/types/movie";
import api from "./client";

export async function getNowPlayingMovies() {
    const { data } = await api.get<Movie[]>("/movies");
    return data;
}
