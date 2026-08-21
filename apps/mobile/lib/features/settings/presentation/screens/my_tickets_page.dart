import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketa/core/constants/app_constants.dart';
import 'package:ticketa/core/di/injection.dart';
import 'package:ticketa/core/theme/app_colors.dart';
import 'package:ticketa/features/booking/data/models/booking_history_dto.dart';
import 'package:ticketa/features/booking/presentation/cubit/my_tickets_cubit.dart';
import 'package:ticketa/l10n/app_localizations.dart';
import 'package:ticketa/core/utils/localization_helper.dart';

class MyTicketsPage extends StatefulWidget {
  const MyTicketsPage({super.key});

  @override
  State<MyTicketsPage> createState() => _MyTicketsPageState();
}

class _MyTicketsPageState extends State<MyTicketsPage> {
  final _scrollController = ScrollController();
  int _selectedFilter = 0;
  BuildContext? _cubitContext;
  MyTicketsLoaded? _cached;
  bool _isGuest = true;
  bool _checkingAuth = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadAuth();
  }

  Future<void> _loadAuth() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _isGuest = prefs.getBool(AppConstants.isGuestKey) ?? true;
      _checkingAuth = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      _cubitContext?.read<MyTicketsCubit>().loadMore();
    }
  }

  void _onFilterChanged(int index, MyTicketsState state) {
    setState(() => _selectedFilter = index);
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
    _cubitContext?.read<MyTicketsCubit>().changeFilter(
          switch (index) {
            1 => TicketsFilter.upcoming,
            2 => TicketsFilter.past,
            _ => TicketsFilter.all,
          },
        );
  }

  List<BookingHistoryItemDto> _visibleTickets(
      List<BookingHistoryItemDto> tickets) {
    switch (_selectedFilter) {
      case 1:
        return tickets.where((t) => t.isUpcoming).toList();
      case 2:
        return tickets.where((t) => t.isPast).toList();
      default:
        return tickets;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    if (_checkingAuth) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            l10n.myTickets,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.warmOrange),
        ),
      );
    }

    if (_isGuest) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            l10n.myTickets,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.warmOrange.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.confirmation_number_rounded,
                      color: AppColors.warmOrange,
                      size: 64,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    localeCopy(
                      context,
                      'Your tickets are safe here',
                      'تذاكرك محفوظة هنا بأمان',
                    ),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    localeCopy(
                      context,
                      'Sign in to view your bookings,\nQR tickets and upcoming showtimes',
                      'سجل دخولك لعرض حجوزاتك\nوتذاكر QR والعروض القادمة',
                    ),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/login'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.warmOrange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        localeCopy(context, 'Sign In', 'تسجيل الدخول'),
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/register'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.warmOrange,
                        side: BorderSide(
                          color: AppColors.warmOrange.withValues(alpha: 0.3),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        localeCopy(
                          context,
                          'Create Account',
                          'إنشاء حساب',
                        ),
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BlocProvider(
        create: (_) => getIt<MyTicketsCubit>()..loadTickets(),
        child: BlocBuilder<MyTicketsCubit, MyTicketsState>(
          builder: (context, state) {
            _cubitContext = context;
            if (state is MyTicketsLoaded) {
              _cached = state;
            }
            return CustomScrollView(
              controller: _scrollController,
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
                        upcoming: (state is MyTicketsLoaded
                                ? state.upcomingCount
                                : _cached?.upcomingCount) ??
                            0,
                        past: (state is MyTicketsLoaded
                                ? state.pastCount
                                : _cached?.pastCount) ??
                            0,
                      ),
                      const SizedBox(height: 18),
                      _FilterChips(
                        selectedIndex: _selectedFilter,
                        labels: [
                          localeCopy(context, 'All', 'الكل'),
                          localeCopy(context, 'Upcoming', 'القادمة'),
                          localeCopy(context, 'Past', 'السابقة'),
                        ],
                        onChanged: (index) => _onFilterChanged(index, state),
                      ),
                      const SizedBox(height: 18),
                      if (state is MyTicketsLoaded) ...[
                        ..._visibleTickets(state.tickets).map(
                          (ticket) => _TicketCard(ticket: ticket),
                        ),
                        if (state.isLoadingMore)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 18),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.warmOrange,
                                strokeWidth: 2.5,
                              ),
                            ),
                          ),
                        if (_visibleTickets(state.tickets).isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: Center(
                              child: Text(
                                localeCopy(
                                  context,
                                  'No tickets in this category',
                                  'لا توجد تذاكر في هذه الفئة',
                                ),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.45),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                      ] else if (state is MyTicketsLoading) ...[
                        if (_cached == null)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 60),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.warmOrange,
                              ),
                            ),
                          )
                        else
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Center(
                              child: SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: AppColors.warmOrange,
                                  strokeWidth: 2.5,
                                ),
                              ),
                            ),
                          ),
                        if (_cached != null)
                          ..._visibleTickets(_cached!.tickets).map(
                            (ticket) => _TicketCard(ticket: ticket),
                          ),
                      ] else if (state is MyTicketsError) ...[
                        if (_cached != null) ...[
                          ..._visibleTickets(_cached!.tickets).map(
                            (ticket) => _TicketCard(ticket: ticket),
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child: Text(
                              state.message,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.5),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ] else ...[
                          const SizedBox(height: 40),
                          Icon(
                            Icons.error_outline_rounded,
                            size: 56,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.25),
                          ),
                          const SizedBox(height: 14),
                          Center(
                            child: Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.55),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Center(
                            child: TextButton.icon(
                              onPressed: () => _cubitContext
                                  ?.read<MyTicketsCubit>()
                                  .loadTickets(refresh: true),
                              icon: const Icon(Icons.refresh_rounded),
                              label: Text(l10n.retry),
                            ),
                          ),
                        ],
                      ] else if (state is MyTicketsEmpty) ...[
                        if (_cached == null) ...[
                          const SizedBox(height: 60),
                          Icon(
                            Icons.confirmation_number_rounded,
                            size: 56,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.25),
                          ),
                          const SizedBox(height: 14),
                          Center(
                            child: Text(
                              localeCopy(
                                context,
                                'No tickets yet',
                                'لا توجد تذاكر بعد',
                              ),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.55),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ]),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
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
                  localeCopy(
                      context, 'Ready for movie night', 'جاهز لليلة السينما'),
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
  final BookingHistoryItemDto ticket;

  const _TicketCard({required this.ticket});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isPast = ticket.isPast;
    final startsAt = ticket.showtimeStartsAt.toLocal();

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
                    color: isPast
                        ? theme.colorScheme.onSurface.withValues(alpha: 0.06)
                        : AppColors.warmOrange.withValues(alpha: 0.1),
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
                              ticket.movieTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0,
                              ),
                            ),
                          ),
                          _StatusPill(isPast: isPast),
                        ],
                      ),
                      const SizedBox(height: 7),
                      Text(
                        ticket.bookingReference,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.52),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _InfoChip(
                            Icons.calendar_month_rounded,
                            DateFormat('dd MMM yyyy').format(startsAt),
                          ),
                          _InfoChip(
                            Icons.schedule_rounded,
                            DateFormat('h:mm a').format(startsAt),
                          ),
                          _InfoChip(
                            Icons.event_seat_rounded,
                            l10n.seatCount(ticket.seatCount.toString()),
                          ),
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
                  child: _TicketMeta(
                    label: localeCopy(
                        context, 'Reference', 'المرجع').toUpperCase(),
                    value: ticket.bookingReference,
                  ),
                ),
                Text(
                  '${ticket.totalAmount.toStringAsFixed(0)} EGP',
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
  final bool isPast;

  const _StatusPill({required this.isPast});

  @override
  Widget build(BuildContext context) {
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