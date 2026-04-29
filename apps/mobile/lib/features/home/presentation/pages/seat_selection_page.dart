import 'package:flutter/material.dart';
import 'dart:math' as math;

class SeatSelectionPage extends StatefulWidget {
  const SeatSelectionPage({super.key});

  @override
  State<SeatSelectionPage> createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends State<SeatSelectionPage>{
  int _selectedDateIndex = 0;
  int _selectedTimeIndex = 1;
  
  // منطق اختيار المقاعد
  final List<String> _selectedSeats = [];
  final double _pricePerSeat = 20.0; // السعر لكل كرسي

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildAppBar(),
            
            const SizedBox(height: 10),
            
            // Dates Section (Film Strip Style)
            _buildUniqueDateSelector(),
            
            const SizedBox(height: 20),
            
            // Times Section (Centered Pills)
            _buildUniqueTimeSelector(),
            
            const SizedBox(height: 30),
            
            // Screen & Seats Area
            Expanded(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  // تم إزالة التوهج الخلفي بناءً على طلبك
                  
                  // رسم الشاشة والمنظور
                  CustomPaint(
                    size: Size(MediaQuery.of(context).size.width, 300),
                    painter: ScreenAndPerspectivePainter(),
                  ),

                  // سهم الإشارة وكلمة SCREEN
                  Positioned(
                    top: 35,
                    child: Column(
                      children: [
                        Icon(Icons.keyboard_arrow_up_rounded, color: Colors.white.withOpacity(0.5), size: 24),
                        Text(
                          "SCREEN",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 10,
                            letterSpacing: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // توزيع المقاعد التفاعلي
                  Positioned(
                    top: 90,
                    child: _buildSeatLayout(),
                  ),
                ],
              ),
            ),
            
            // Legend
            _buildLegend(),
            
            // Bottom Action Bar
            _buildBottomAction(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: _buildCircleBtn(Icons.arrow_back_ios_new)
          ),
          const Text("Select Seats", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          _buildCircleBtn(Icons.more_vert),
        ],
      ),
    );
  }

  Widget _buildUniqueDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 24, bottom: 12),
          child: Text("OCTOBER", style: TextStyle(color: Colors.white38, letterSpacing: 3, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: 14,
            itemBuilder: (context, index) {
              bool isSelected = index == _selectedDateIndex;
              return GestureDetector(
                onTap: () => setState(() => _selectedDateIndex = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 75,
                  margin: const EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFFF4500) : const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: const Color(0xFFFF4500).withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 2,
                      )
                    ] : [],
                  ),
                  child: Stack(
                    children: [
                      _buildFilmHoles(),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _getDayName(index),
                              style: TextStyle(
                                color: isSelected ? Colors.white70 : Colors.white24,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${15 + index}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilmHoles() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(3, (i) => Container(width: 6, height: 6, decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(2)))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(3, (i) => Container(width: 6, height: 6, decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(2)))),
          ),
        ),
      ],
    );
  }

  Widget _buildUniqueTimeSelector() {
    List<String> times = ["08:00", "10:30", "14:00", "18:45"];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: times.asMap().entries.map((entry) {
        int index = entry.key;
        bool isSelected = index == _selectedTimeIndex;
        return GestureDetector(
          onTap: () => setState(() => _selectedTimeIndex = index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 6),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white.withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? const Color(0xFFFF4500) : Colors.white10,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Text(
              entry.value,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white38,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSeatLayout() {
    return Column(
      children: List.generate(7, (row) {
        int seatsInRow = 8 + (row % 2); 
        return Padding(
          padding: EdgeInsets.only(bottom: 15, left: row * 5.0, right: row * 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(seatsInRow, (col) {
              String seatId = "$row-$col";
              bool isSelected = _selectedSeats.contains(seatId);
              bool isReserved = (row == 2 && col == 3) || (row == 4 && col == 4);
              
              Color seatColor = Colors.white24;
              if (isReserved) seatColor = const Color(0xFF00C853);
              if (isSelected) seatColor = const Color(0xFFFFD600);
              
              return GestureDetector(
                onTap: isReserved ? null : () {
                  setState(() {
                    if (isSelected) {
                      _selectedSeats.remove(seatId);
                    } else {
                      _selectedSeats.add(seatId);
                    }
                  });
                },
                child: _CinemaSeat(color: seatColor),
              );
            }),
          ),
        );
      }),
    );
  }

  Widget _buildBottomAction() {
    double total = _selectedSeats.length * _pricePerSeat;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(30)),
            child: Text(
              "${_selectedSeats.length}", 
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)
            ),
          ),
          GestureDetector(
            onTap: _selectedSeats.isEmpty ? null : () {
              // أكشن الحجز
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
              decoration: BoxDecoration(
                color: _selectedSeats.isEmpty ? Colors.white10 : const Color(0xFFFF4500), 
                borderRadius: BorderRadius.circular(30)
              ),
              child: Text(
                "Buy For ${total.toStringAsFixed(2)}", 
                style: TextStyle(
                  color: _selectedSeats.isEmpty ? Colors.white24 : Colors.white, 
                  fontWeight: FontWeight.bold, 
                  fontSize: 16
                )
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _legendItem("Available", Colors.white24),
          _legendItem("Selected", const Color(0xFFFFD600)),
          _legendItem("Reserved", const Color(0xFF00C853)),
        ],
      ),
    );
  }

  Widget _legendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          CircleAvatar(radius: 5, backgroundColor: color),
          const SizedBox(width: 5),
          Text(label, style: const TextStyle(color: Colors.white38, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildCircleBtn(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(color: Color(0xFF1A1A1A), shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  String _getDayName(int index) {
    const days = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"];
    return days[index % 7];
  }
}

class _CinemaSeat extends StatelessWidget {
  final Color color;
  const _CinemaSeat({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 30,
      height: 28,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Backrest
          Positioned(
            top: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 26,
              height: 22,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
            ),
          ),
          // Seat Base
          Positioned(
            bottom: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 30,
              height: 10,
              decoration: BoxDecoration(
                color: color.withOpacity(0.8),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          // Subtle details
          Positioned(
            top: 4,
            child: Container(
              width: 20,
              height: 2,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScreenAndPerspectivePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = const Color(0xFFFF4500)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    var path = Path();
    path.moveTo(size.width * 0.05, 35);
    path.quadraticBezierTo(size.width * 0.5, -15, size.width * 0.95, 35);
    canvas.drawPath(path, paint);

    var shadowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [const Color(0xFFFF4500).withOpacity(0.3), Colors.transparent],
      ).createShader(Rect.fromLTWH(0, 35, size.width, 300));

    var shadowPath = Path();
    shadowPath.moveTo(size.width * 0.05, 35);
    shadowPath.quadraticBezierTo(size.width * 0.5, -15, size.width * 0.95, 35);
    shadowPath.lineTo(size.width * 1.1, 300); 
    shadowPath.lineTo(size.width * -0.1, 300);
    shadowPath.close();
    canvas.drawPath(shadowPath, shadowPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}