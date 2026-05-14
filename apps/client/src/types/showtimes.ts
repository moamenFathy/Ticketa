export type MoviesShowtimes = {
  id: string;
	movieId: string;
	title: string;
	posterPath?: string;
	showtimes: Showtime[];
}

export type Showtime = {
	id: string;
	startTime: string;
	price: string;
	trailerKey?: string;
}