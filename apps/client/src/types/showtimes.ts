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