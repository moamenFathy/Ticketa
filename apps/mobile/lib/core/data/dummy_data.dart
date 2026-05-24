import 'package:ticketa/features/home/data/models/movie.dart';
import 'package:ticketa/features/home/data/models/seat.dart';

class DummyData {
  static final List<Movie> movies = [
    Movie(
      id: '1',
      title: 'Dune: Part Two',
      posterUrl: 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?q=80&w=2525&auto=format&fit=crop',
      genre: 'Sci-Fi | Action',
      rating: 9.1,
      duration: 166,
      showTimes: [
        DateTime(2026, 4, 29, 14, 30),
        DateTime(2026, 4, 29, 17, 45),
        DateTime(2026, 4, 29, 20, 00),
      ],
    ),
    Movie(
      id: '2',
      title: 'Oppenheimer',
      posterUrl: 'https://images.unsplash.com/photo-1485846234645-a62644f84728?q=80&w=2659&auto=format&fit=crop',
      genre: 'Drama | History',
      rating: 8.4,
      duration: 180,
      showTimes: [
        DateTime(2026, 4, 29, 15, 00),
        DateTime(2026, 4, 29, 18, 30),
        DateTime(2026, 4, 29, 21, 00),
      ],
    ),
    Movie(
      id: '3',
      title: 'The Dark Knight',
      posterUrl: 'https://images.unsplash.com/photo-1478720568477-152d9b164e26?q=80&w=2670&auto=format&fit=crop',
      genre: 'Action | Crime',
      rating: 9.0,
      duration: 152,
      showTimes: [
        DateTime(2026, 4, 29, 13, 00),
        DateTime(2026, 4, 29, 16, 00),
        DateTime(2026, 4, 29, 19, 00),
      ],
    ),
  ];

  static List<List<Seat>> generateSeats() {
    const rows = ['A', 'B', 'C', 'D', 'E', 'F', 'G'];
    const seatsPerRow = 12;
    final result = <List<Seat>>[];
    for (final row in rows) {
      final rowSeats = <Seat>[];
      for (int i = 1; i <= seatsPerRow; i++) {
        final status = (row == 'D' && i == 7) || (row == 'B' && i == 3)
            ? SeatStatus.occupied
            : SeatStatus.available;
        rowSeats.add(Seat(row: row, number: i, status: status));
      }
      result.add(rowSeats);
    }
    return result;
  }
}