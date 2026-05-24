export type MoviesShowtimes = {
  id: string;
	movieId: string;
	title: string;
	posterPath?: string;
	trailerKey?: string;
	showtimes: Showtime[];
}

export type Showtime = {
	id: string;
	hallName: string;
	startTime: string;
	price: string;
}

type BookedSeat = {
	row: number;
	seatNumber: number;
}

export type ShowtimeSeats = {
  movieId: number;
	showtimeId: string;
	movieTitle: string;
	moviePosterPath?: string;
	hallName: string;
	hallType: string;
	startsAt: string;
	rows: number;
	seatsPerRow: number;
	rowCategoryMap: Record<number, string>;
	bookedSeats: BookedSeat[];
}