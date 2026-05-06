import type { MovieListResponse } from "@/types/movie";
import api from "./client";

export async function getNowPlayingMovies() {
    const { data } = await api.get<MovieListResponse>("/movies");
    console.log(data);
    return data.data;
}
