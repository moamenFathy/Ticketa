# 🧪 Testing Architecture & Execution Plan

> **Ticketa** treats testing as an engineering discipline to prove that business-critical operations—especially high-concurrency seat selection, financial transactions, and RBAC rules—behave strictly according to specifications.

---

## 🏗️ The Testing Pyramid

```text
          /\
         /E2E\          Minimal Playwright golden path (Browse -> Seat -> Pay -> Ticket)
        /------\
       /Integration\     Real SQL Server via Testcontainers (Concurrency, EF Specs, UTC)
      /------------\
     /  Unit Tests  \    Comprehensive business logic coverage (xUnit + Moq, fast & isolated)
    /----------------\
```

1. **Unit Tests (Core & Services)**: Fast, memory-only, Moq-backed execution isolating business logic from databases and networks.
2. **Integration Tests (Testcontainers + SQL Server)**: Real SQL Server containers proving concurrency constraints, EF Core query translation, and unique index collision behavior.
3. **End-to-End Tests (Playwright)**: Minimal user journey tests validating the full customer checkout path.

---

## 🎯 Testing Philosophy: Genuine vs. Vacuous Tests

### ❌ The Trap: Tautological / Vacuous Testing
A test is **vacuous** if its assertions are merely written to match whatever the code currently produces. Such tests provide a false sense of security, passing even when the underlying business calculation is fundamentally wrong.

### ✅ The Standard: Requirement-Derived Assertions
* Expected values must be derived by hand from the domain requirement **before inspecting code output** (e.g. `3 VIP Seats × $100 base × 1.5 multiplier = $450`).
* **Manual Mutation Check**: Intentionally alter the production logic (e.g. change multiplier `1.5m` to `1.4m`). The test **must** fail immediately.
* **Automated Mutation Testing (Stryker.NET)**: Automatically mutates binaries and verifies that tests kill every mutant mutant (`Mutant Killed` vs `Mutant Survived`).

---

## 📋 Naming & Structural Conventions

| Item | Standard Convention | Example |
| :--- | :--- | :--- |
| **Project** | `Ticketa.Tests` (created via `dotnet new xunit`) | — |
| **Directory** | Mirrors production source tree | `Ticketa.Tests/Infrastructure/Services/BookingServiceTests.cs` |
| **Class Name** | `<TargetClass>Tests` | `BookingServiceTests.cs` |
| **Method Name** | `<MethodUnderTest>_<Scenario>_<ExpectedResult>` | `CreateAsync_WithConflictingSeat_ReturnsConflictResult` |
| **Structure** | Strict **Arrange-Act-Assert (AAA)** pattern | — |
| **Test Fixtures** | Fluent Test Data Builders | `ShowtimeBuilder`, `BookingBuilder`, `BookedSeatBuilder` |
| **Theory vs Fact** | `[Theory]` + `[InlineData]` for parameter variations; `[Fact]` for distinct mock graphs | — |

---

## 🧱 The Test Data Builder Pattern

### 🛑 Why We Avoid Manual Entity Instantiation
Complex domain models like `Showtime`, `Booking`, and `BookedSeat` have deep object graphs (e.g. `Hall`, `Movie`, navigation collections, pricing, UTC timestamps, and enum statuses).

Manually initializing these objects directly within test methods creates severe architectural problems:
1. **Noisy Setup**: 15–20 lines of repetitive setup code per test obscures what the test is actually verifying.
2. **Brittle Test Suites**: Adding a new required property or relation to an entity breaks dozens of test files across the solution.
3. **Loss of Test Intent**: Readers cannot easily distinguish between required domain data and irrelevant boilerplate.

### 💡 The Solution: Fluent Builders (`Ticketa.Tests/TestBuilders/`)
Test Data Builders provide complete, sensible default instances out-of-the-box, exposing expressive fluent methods for only the properties relevant to the specific test scenario:

```csharp
// Fluent and expressive — overrides only what matters for the test scenario
var showtime = new ShowtimeBuilder()
    .WithId(1)
    .WithHallType(HallType.Gold)
    .WithPrice(100m)
    .WithStatus(ShowtimeStatus.SoldOut)
    .Build();

var seat = new BookedSeatBuilder()
    .WithShowtimeId(1)
    .WithSeat(row: 1, seatNumber: 5)
    .WithCategory(SeatCategory.VIP)
    .Build();
```

* **`ShowtimeBuilder`**: Preconfigures valid default `Hall` (Standard, 182 visible seats), `Movie` (Active), and UTC timeframes.
* **`BookedSeatBuilder`**: Sets up valid row/seat coordinates, seat categories, and unit pricing.
* **`BookingBuilder`**: Bundles booked seat collections, computes `TotalAmount`, and sets confirmed status.

---

## 📊 Code Coverage & Risk Analysis (ReportGenerator & Stryker)

### Running Coverage Locally
The repository includes an automated batch script (`run-coverage.bat`) for generating and visualizing code coverage reports:

```cmd
@echo off
dotnet test --collect:"XPlat Code Coverage"
reportgenerator -reports:"**/coverage.cobertura.xml" -targetdir:"coveragereport" -reporttypes:Html
start coveragereport/index.html
```

### Risk Hotspot Identification (Crap Score)
ReportGenerator tracks **Crap Score** ($\text{Complexity} \times \text{Uncovered Paths}$) to direct testing priorities towards the most vulnerable components:

* `PaymentManagementSpecification.ApplyOrdering` — High Complexity / Ordering permutations
* `MovieSpecification.ApplyOrdering` / `ApplyFilters`
* `BookingService.CreateAsync` — High Concurrency critical section

### Running Mutation Testing (Stryker)
```bash
dotnet tool install -g dotnet-stryker
dotnet stryker
```

---

## 🗺️ 10-Phase Risk-Ordered Testing Roadmap

```text
Phase 0 [Done]  ──>  Phase 1 [Booking]  ──>  Phase 2 [Payment]  ──>  Phase 3 [Auth]
        │
        └───>  Phase 4 [Showtimes] ──> Phase 5 [Specs] ──> Phase 6 [Permissions]
                │
                └───>  Phase 7 [Profile] ──> Phase 8 [Archiving] ──> Phase 9 [Concurrency ⭐]
```

### Phase 0 — Core Helpers & Math ✅
* `HallTypeHelper.GetPriceMultiplier`: Verified `VIP (1.5x)`, `Premium (1.2x)`, `Regular (1.0x)`.
* `HallTemplate.VisibleSeatCount` & `InvisibleSeatCount`: Bowl-shape skip math calculations verified across Standard (110 seats), IMAX (214 seats), and Gold (38 seats).

### Phase 1 — Booking Core Logic ✅ (Implemented in `BookingServiceTests.cs`)

The `BookingService` test suite covers **13 comprehensive scenarios** across 5 categories of business guarantees:

#### 1. 🛡️ Safety & Zero-Dirty-Write Guarantees
* `CreateAsync_WhenShowtimeNotFound_ReturnsConflictWithEmptySeatsAndNeverSaves`
  * Verifies missing showtime returns `Succeeded = false`.
  * **Moq Assertion**: Verifies `Bookings.CreateAsync` and `SaveAsync` were **never called** (`Times.Never`), guaranteeing no partial records.
* `CreateAsync_WhenSeatsAlreadyBooked_ReturnsConflictWithConflictingSeatsAndNeverCreatesBooking`
  * When requested seats collide with existing bookings, returns `Succeeded = false` with conflicting seat coordinates.
  * **Moq Assertion**: Verifies `Bookings.CreateAsync` and `SaveAsync` were **never called**.

#### 2. 💰 Financial Correctness & Pricing Multipliers
* `CreateAsync_WithValidSeats_CalculatesPriceMultipliersAndTotalCorrectly`
  * Standard Hall Base Price = $100.
  * User selects Row 1 (Regular, $1.0\times = \$100$) + Row 10 (VIP, $1.5\times = \$150$).
  * **Assertions**: Verifies per-seat pricing, category assignments, and that `TotalAmount` on the created booking equals exactly **$250.00**.

#### 3. 🎟️ Capacity State Machine & Automated Status Transitions
* `CreateAsync_WhenBookingFillsCapacity_TransitionsShowtimeStatusToSoldOutAndUpdates`
  * Capacity = 38 visible seats, existing booked = 36. User books 2 seats ($36 + 2 = 38 \ge 38$).
  * **Assertions**: Verifies `Showtime.Status` transitions to `ShowtimeStatus.SoldOut` and `Showtimes.UpdateAsync` is called.
* `CreateAsync_WhenBookingDoesNotFillCapacity_ShowtimeStatusRemainsScheduled`
  * Capacity = 38 visible seats, existing booked = 10. User books 2 seats ($10 + 2 = 12 < 38$).
  * **Assertions**: Verifies `Showtime.Status` remains `ShowtimeStatus.Scheduled` with zero redundant update queries.

#### 4. ⚡ Storage Concurrency & Exception Handling
* `CreateAsync_WhenDbUpdateExceptionOccurs_CatchesExceptionAndReturnsLateConflict`
  * Simulates a database-level unique constraint collision (`DbUpdateException` on `IX_BookedSeats_ShowtimeId_Row_SeatNumber`).
  * **Assertions**: Verifies the exception is caught gracefully and re-queries to return the colliding seat coordinates rather than failing with an unhandled 500 error.

#### 5. 🔄 Refund & Cancellation Integrity
* `CancelBookingsForPaymentAsync_WhenShowtimeNotFound_ReturnsFailureWithMessage`
* `CancelBookingsForPaymentAsync_WhenPaymentSeatsEmpty_ReturnsFailureWithMessage`
* `CancelBookingsForPaymentAsync_WhenNoMatchingBookedSeatsFound_ReturnsFailureWithMessage`
* `CancelBookingsForPaymentAsync_WhenPartialSeatsCancelled_DeletesMatchedSeatsAndPreservesBookingStatus`
  * When 1 of 2 seats is refunded, only the targeted `BookedSeat` is deleted; the remaining seat and `Booking.Status = Confirmed` are preserved.
* `CancelBookingsForPaymentAsync_WhenAllSeatsForBookingCancelled_UpdatesBookingStatusToCancelled`
  * When all seats for a booking are refunded, transitions `Booking.Status` to `Cancelled`.
* `CancelBookingsForPaymentAsync_WhenSoldOutShowtimeHasCapacityFreed_RevertsStatusToScheduled`
  * If a `SoldOut` showtime drops below capacity after a refund, automatically re-opens the session by setting `Showtime.Status = Scheduled`.
* `CancelBookingsForPaymentAsync_WhenSoldOutShowtimeStillAtOrAboveCapacity_StatusRemainsSoldOut`
  * If remaining seats still meet capacity, preserves `ShowtimeStatus.SoldOut`.

---

### Phase 2 — Payments (Stripe SDK Boundary)
* `PaymentService.CreateIntentAsync`:
  * Verifies amount calculation converted to minor currency units (cents/piastres $\times 100$).
  * Idempotency key stability: `"intent-{userId}-{showtimeId}-{sortedSeats}"` produces identical keys regardless of input array order.
* `PaymentService.ConfirmAsync`:
  * Succeeded intent + `metadata["userId"] == currentUserId` $\rightarrow$ triggers booking creation.
  * `userId` mismatch $\rightarrow$ security rejection.
  * Post-payment conflict $\rightarrow$ triggers automated refund through Stripe SDK.
  * Resilient email dispatch $\rightarrow$ SMTP failures are caught and logged without aborting confirmed bookings.

### Phase 3 — Authentication & Security
* Anti-enumeration: `RegisterAsync` on an unconfirmed email resends code without leaking account existence.
* OTP validation: `ConfirmEmailAsync` rejects expired/invalid codes and issues JWT on valid input.
* Token refresh: Revoked/expired refresh tokens reject renewal; valid tokens rotate both access and refresh tokens.

### Phase 4 — Showtime Scheduling & 15-Minute Buffer
* `HasConflictAsync`: Enforces strict 15-minute turnaround buffer between consecutive showtimes in the same hall.
* Boundary tests: Tests exact overlap limits ($14\text{ min} \rightarrow \text{conflict}$, $15\text{ min} \rightarrow \text{valid}$).
* `SaveBatchAsync`: Validates multi-item drag-and-drop updates, 5-hour advance scheduling rules, and prevents modifying completed sessions.

### Phase 5 — Specifications & Query Builders
* Integration tests with SQLite/SQL Server for `PaymentManagementSpecification`, `MovieSpecification`, and `BookingHistorySpecification`.

### Phase 6 — Permissions & RBAC
* `PermissionAuthorizationHandler`: Verifies claim match succeeds and missing claim fails explicitly.
* `RoleService.UpsertAsync`: Validates claim delta synchronization (adds new claims, drops unselected claims).

### Phase 7 — User Profile & History
* `ChangePasswordAsync`: Identity password verification without terminating active sessions.
* `GetBookingHistoryAsync`: Pagination clamping ($\le 25$ items) and `HasMore` boolean flag boundary calculation.

### Phase 8 — Background Services & Archiving
* `ShowtimeCompletionSpecification`: Filters completed showtimes requiring soft-archiving.
* Soft-delete index isolation: Asserts queries filter out `IsArchived = true` rows by default.

### Phase 9 — Integration: The Concurrency Test ⭐
* Spawns a real disposable SQL Server via **Testcontainers.MsSql**.
* Fires two parallel `CreateAsync` requests for the **exact same seat** at the same instant.
* Proves that the `(ShowtimeId, Row, SeatNumber)` unique constraint blocks the second request, triggering the automated conflict and refund path.

### Phase 10 — Minimal E2E Golden Path (Playwright)
* Executes the complete user journey: Browse Movie $\rightarrow$ Pick Showtime $\rightarrow$ Select Seat $\rightarrow$ Stripe Checkout $\rightarrow$ View QR Ticket.

---

## 📌 Definition of Done for Any Test

1. Assertions test specific semantic values rather than generic `NotNull` or `DoesNotThrow`.
2. Expected test values are calculated independently of implementation code.
3. Mutations applied to the production code cause the test to fail.
4. Happy path and failure/edge conditions are both verified.
5. Tests are fully isolated with zero shared mutable state or execution-order dependency.
