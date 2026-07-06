
export const queryKeys = {
    movies: {
        nowPlaying: ["movies", "nowPlaying"] as const,
        movieDetails: (id: string) => ["movies", "details", id] as const,
        comingSoon: ["movies", "comingSoon"] as const
    },

    showtimes: {
        getAll: ["showtimes"] as const,
        getSeatsForShowtime: (showtimeId: string) => ["showtimes", "seats", showtimeId] as const
    },

    bookings: {
      getBooking: (reference: string) => ["bookings", "get", reference] as const,
      create: ["bookings", "create"] as const,
    },

    profile: {
      get: ["profile"] as const,
      bookings: (page: number) => ["profile", "bookings", page] as const,
    },
}