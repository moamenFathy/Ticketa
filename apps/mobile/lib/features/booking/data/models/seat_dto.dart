class SeatDto {
  final int row;
  final int seatNumber;

  const SeatDto({required this.row, required this.seatNumber});

  factory SeatDto.fromJson(Map<String, dynamic> json) => SeatDto(
        row: json['row'] ?? 0,
        seatNumber: json['seatNumber'] ?? 0,
      );

  Map<String, dynamic> toJson() => {'row': row, 'seatNumber': seatNumber};

  String get id => '${row}_$seatNumber';
}
