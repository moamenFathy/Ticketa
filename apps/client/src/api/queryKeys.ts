export const queryKeys = {
    movies: {
        nowPlaying: ["movies", "nowPlaying"] as const,
        movieDetails: (id: string) => ["movies", "details", id] as const
    },

    showtimes: {
        getAll: ["showtimes"] as const
    }
}