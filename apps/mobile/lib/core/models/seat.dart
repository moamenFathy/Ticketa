enum SeatStatus { available, selected, occupied }

class Seat {
  final String row;
  final int number;
  final String id; // "A-1"
  double price;
  SeatStatus status;

  Seat({
    required this.row,
    required this.number,
    this.price = 50.0,
    this.status = SeatStatus.available,
  }) : id = '$row-${number.toString().padLeft(2, '0')}';
}