
export const queryKeys = {
    movies: {
        nowPlaying: ["movies", "nowPlaying"] as const,
        movieDetails: (id: string) => ["movies", "details", id] as const
    },

    showtimes: {
        getAll: ["showtimes"] as const,
        getSeatsForShowtime: (showtimeId: string) => ["showtimes", "seats", showtimeId] as const
    },

    bookings: {
      create: ["bookings", "create"] as const,
    }
}