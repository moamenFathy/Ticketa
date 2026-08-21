import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketa/features/booking/data/models/booking_history_dto.dart';
import 'package:ticketa/features/booking/data/booking_repository.dart';

enum TicketsFilter { all, upcoming, past }

abstract class MyTicketsState {}

class MyTicketsInitial extends MyTicketsState {}

class MyTicketsLoading extends MyTicketsState {}

class MyTicketsLoaded extends MyTicketsState {
  final List<BookingHistoryItemDto> tickets;
  final int upcomingCount;
  final int pastCount;
  final bool hasMore;
  final bool isLoadingMore;

  MyTicketsLoaded({
    required this.tickets,
    required this.upcomingCount,
    required this.pastCount,
    required this.hasMore,
    this.isLoadingMore = false,
  });
}

class MyTicketsEmpty extends MyTicketsState {}

class MyTicketsError extends MyTicketsState {
  final String message;

  MyTicketsError(this.message);
}

class MyTicketsCubit extends Cubit<MyTicketsState> {
  final BookingRepository _repository;

  MyTicketsCubit(this._repository) : super(MyTicketsInitial());

  TicketsFilter _filter = TicketsFilter.all;
  int _page = 1;
  bool _hasMore = false;
  List<BookingHistoryItemDto> _tickets = [];

  String get _filterParam => switch (_filter) {
        TicketsFilter.all => 'All',
        TicketsFilter.upcoming => 'Upcoming',
        TicketsFilter.past => 'Past',
      };

  Future<void> loadTickets({bool refresh = false}) async {
    if (refresh) {
      _page = 1;
      _tickets = [];
    }

    emit(MyTicketsLoading());
    try {
      final pageData = await _repository.getBookingHistory(
        page: _page,
        pageSize: 10,
        filter: _filterParam,
      );

      _tickets = refresh ? pageData.items : [..._tickets, ...pageData.items];
      _hasMore = pageData.hasMore;

      if (_tickets.isEmpty) {
        emit(MyTicketsEmpty());
        return;
      }

      emit(
        MyTicketsLoaded(
          tickets: List.unmodifiable(_tickets),
          upcomingCount: _tickets
              .where((t) => t.isUpcoming)
              .length,
          pastCount: _tickets.where((t) => t.isPast).length,
          hasMore: _hasMore,
        ),
      );
    } catch (e) {
      debugPrint('[tickets] load failed: $e');
      emit(MyTicketsError('Failed to load tickets.'));
    }
  }

  Future<void> loadMore() async {
    final state = this.state;
    if (state is! MyTicketsLoaded || !state.hasMore || state.isLoadingMore) {
      return;
    }

    emit(MyTicketsLoaded(
      tickets: state.tickets,
      upcomingCount: state.upcomingCount,
      pastCount: state.pastCount,
      hasMore: state.hasMore,
      isLoadingMore: true,
    ));

    _page += 1;
    try {
      final pageData = await _repository.getBookingHistory(
        page: _page,
        pageSize: 10,
        filter: _filterParam,
      );

      _tickets = [..._tickets, ...pageData.items];
      _hasMore = pageData.hasMore;

      emit(MyTicketsLoaded(
        tickets: List.unmodifiable(_tickets),
        upcomingCount: _tickets.where((t) => t.isUpcoming).length,
        pastCount: _tickets.where((t) => t.isPast).length,
        hasMore: _hasMore,
      ));
    } catch (e) {
      debugPrint('[tickets] loadMore failed: $e');
      _page -= 1;
      emit(state);
    }
  }

  void changeFilter(TicketsFilter filter) {
    if (_filter == filter) return;
    _filter = filter;
    loadTickets(refresh: true);
  }
}