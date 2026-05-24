import 'package:flutter/material.dart';
import 'package:ticketa/core/theme/app_colors.dart';
import 'package:ticketa/l10n/app_localizations.dart';
import 'package:ticketa/core/utils/localization_helper.dart';

class MyTicketsPage extends StatefulWidget {
  const MyTicketsPage({super.key});

  @override
  State<MyTicketsPage> createState() => _MyTicketsPageState();
}

class _MyTicketsPageState extends State<MyTicketsPage> {
  int _selectedFilter = 0;

  final List<_TicketItem> _tickets = const [
    _TicketItem(
      movie: 'Dune: Part Two',
      cinema: 'Vox Cinemas - Mall of Egypt',
      date: 'Fri, 24 May',
      time: '08:30 PM',
      hall: 'IMAX 02',
      seats: 'G7, G8',
      status: _TicketStatus.upcoming,
      price: '420 EGP',
      code: 'TK-8402',
    ),
    _TicketItem(
      movie: 'Inside Out 2',
      cinema: 'Galaxy Cairo Festival',
      date: 'Sat, 25 May',
      time: '06:15 PM',
      hall: 'Screen 05',
      seats: 'C4, C5, C6',
      status: _TicketStatus.upcoming,
      price: '510 EGP',
      code: 'TK-1918',
    ),
    _TicketItem(
      movie: 'The Batman',
      cinema: 'Point 90 Cinema',
      date: '12 Apr 2026',
      time: '09:00 PM',
      hall: 'Screen 01',
      seats: 'D10',
      status: _TicketStatus.past,
      price: '160 EGP',
      code: 'TK-5541',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final tickets = _filteredTickets;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            title: Text(
              l10n.myTickets,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 0,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _TicketsSummary(
                  upcoming: _tickets
                      .where(
                        (ticket) => ticket.status == _TicketStatus.upcoming,
                      )
                      .length,
                  past: _tickets
                      .where((ticket) => ticket.status == _TicketStatus.past)
                      .length,
                ),
                const SizedBox(height: 18),
                _FilterChips(
                  selectedIndex: _selectedFilter,
                  labels: [
                    localeCopy(context, 'All', 'الكل'),
                    localeCopy(context, 'Upcoming', 'القادمة'),
                    localeCopy(context, 'Past', 'السابقة'),
                  ],
                  onChanged: (index) => setState(() => _selectedFilter = index),
                ),
                const SizedBox(height: 18),
                ...tickets.map((ticket) => _TicketCard(ticket: ticket)),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  List<_TicketItem> get _filteredTickets {
    if (_selectedFilter == 1) {
      return _tickets
          .where((ticket) => ticket.status == _TicketStatus.upcoming)
          .toList();
    }

    if (_selectedFilter == 2) {
      return _tickets
          .where((ticket) => ticket.status == _TicketStatus.past)
          .toList();
    }

    return _tickets;
  }
}

class _TicketsSummary extends StatelessWidget {
  final int upcoming;
  final int past;

  const _TicketsSummary({required this.upcoming, required this.past});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.warmOrange,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.warmOrange.withValues(alpha: 0.24),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.confirmation_number_rounded,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localeCopy(context, 'Ready for movie night', 'جاهز لليلة السينما'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  localeCopy(
                    context,
                    '$upcoming upcoming • $past past',
                    '$upcoming قادمة • $past سابقة',
                  ),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.76),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  final int selectedIndex;
  final List<String> labels;
  final ValueChanged<int> onChanged;

  const _FilterChips({
    required this.selectedIndex,
    required this.labels,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
        ),
      ),
      child: Row(
        children: List.generate(labels.length, (index) {
          final isSelected = index == selectedIndex;

          return Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => onChanged(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.warmOrange : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  labels[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : theme.colorScheme.onSurface.withValues(alpha: 0.58),
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  final _TicketItem ticket;

  const _TicketCard({required this.ticket});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPast = ticket.status == _TicketStatus.past;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 58,
                  height: 74,
                  decoration: BoxDecoration(
                    color: AppColors.warmOrange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.movie_filter_rounded,
                    color: isPast
                        ? theme.colorScheme.onSurface.withValues(alpha: 0.34)
                        : AppColors.warmOrange,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              ticket.movie,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0,
                              ),
                            ),
                          ),
                          _StatusPill(status: ticket.status),
                        ],
                      ),
                      const SizedBox(height: 7),
                      Text(
                        ticket.cinema,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.52,
                          ),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _InfoChip(Icons.calendar_month_rounded, ticket.date),
                          _InfoChip(Icons.schedule_rounded, ticket.time),
                          _InfoChip(Icons.event_seat_rounded, ticket.seats),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _DashedDivider(color: theme.colorScheme.onSurface),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 13, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: _TicketMeta(label: ticket.hall, value: ticket.code),
                ),
                Text(
                  ticket.price,
                  style: const TextStyle(
                    color: AppColors.warmOrange,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final _TicketStatus status;

  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    final isPast = status == _TicketStatus.past;
    final color = isPast ? Colors.grey : AppColors.success;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        isPast
            ? localeCopy(context, 'Past', 'سابقة')
            : localeCopy(context, 'Upcoming', 'قادمة'),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 0,
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.46),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.68),
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}

class _TicketMeta extends StatelessWidget {
  final String label;
  final String value;

  const _TicketMeta({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.48),
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 13,
            fontWeight: FontWeight.w900,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }
}

class _DashedDivider extends StatelessWidget {
  final Color color;

  const _DashedDivider({required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        18,
        (index) => Expanded(
          child: Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            color: color.withValues(alpha: 0.08),
          ),
        ),
      ),
    );
  }
}

enum _TicketStatus { upcoming, past }

class _TicketItem {
  final String movie;
  final String cinema;
  final String date;
  final String time;
  final String hall;
  final String seats;
  final _TicketStatus status;
  final String price;
  final String code;

  const _TicketItem({
    required this.movie,
    required this.cinema,
    required this.date,
    required this.time,
    required this.hall,
    required this.seats,
    required this.status,
    required this.price,
    required this.code,
  });
}

