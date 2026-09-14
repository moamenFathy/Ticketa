# Mobile Testing & Quality Assurance Guide

> **Test Suite Directory:** `apps/mobile/test/`  
> **Key Packages:** `flutter_test`, `bloc_test`, `mocktail`

---

## 1. Testing Pyramid & Strategy

The Ticketa mobile client follows a three-tiered testing methodology:

```
        ▲
       / \
      / E2E \       Integration Tests (Full Booking Flow)
     /-------\
    /  Widget \     Widget & Screen Verification (Seat Grid, GlassCard, ARB)
   /-----------\
  /    Unit     \   Cubit State Transitions, Repositories, DTO Serialization
 /---------------\
```

1. **Unit Tests (Cubit & State Machines):** Validates state emissions using `bloc_test`.
2. **DTO & Serialization Tests:** Verifies defensive type casting and null safety handling across all 12 model classes.
3. **Widget & Layout Tests:** Verifies UI rendering, RTL layout mirroring, and component interaction.

---

## 2. Cubit Testing Examples

### Testing `BookingCubit` Seat Toggle & Selection Limit
```dart
void main() {
  group('BookingCubit Tests', () {
    late BookingRepository mockRepository;
    late BookingCubit cubit;

    setUp(() {
      mockRepository = MockBookingRepository();
      cubit = BookingCubit(mockRepository);
    });

    tearDown(() => cubit.close());

    blocTest<BookingCubit, BookingState>(
      'emits [BookingLoading, SeatMapLoaded] when loadSeatMap succeeds',
      build: () {
        when(() => mockRepository.getSeatMap(any()))
            .thenAnswer((_) async => testShowtimeSeatDto);
        return cubit;
      },
      act: (c) => c.loadSeatMap(1),
      expect: () => [
        isA<BookingLoading>(),
        isA<SeatMapLoaded>(),
      ],
    );

    test('toggleSeat prevents selecting more than 10 seats', () {
      cubit.emit(SeatMapLoaded(
        seatMap: testShowtimeSeatDto,
        selectedSeats: List.generate(10, (i) => '1_$i'),
      ));

      final result = cubit.toggleSeat('1_11');
      expect(result, false);
      expect((cubit.state as SeatMapLoaded).selectedSeats.length, 10);
    });
  });
}
```

---

## 3. Mocking & Dependency Injection in Tests

When executing unit and widget tests, bypass `getIt` network dependencies by registering mock singletons:

```dart
setUpAll(() {
  getIt.registerLazySingleton<ApiService>(() => MockApiService());
  getIt.registerLazySingleton<NavigationService>(() => MockNavigationService());
});
```

---

## 4. Running the Test Suites

To execute all mobile test suites with code coverage generation:

```bash
cd apps/mobile
flutter test --coverage
```
