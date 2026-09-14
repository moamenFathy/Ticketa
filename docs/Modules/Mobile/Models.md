# Mobile Data Models Catalog & Serialization Reference

> **Directory:** `apps/mobile/lib/features/*/models/`  
> **Target Framework:** Dart 3.11 / Flutter 3.x  
> **Serialization Strategy:** Robust handwritten `fromJson`/`toJson` factory constructors with defensive type casting, null safety fallbacks, and presentation helpers.

This document serves as the single source of truth for all data transfer objects (DTOs) and domain models across the Ticketa mobile client.

---

## 1. Domain Modeling Architecture

Mobile models in Ticketa follow a **defensive deserialization** architecture:
- **Null Safety Resilience:** Numeric properties safely parse both numbers and strings (`(json['val'] as num?)?.toDouble() ?? 0.0`), dates handle ISO 8601 strings with fallback to `DateTime.now()`.
- **Backend Field Fallbacks:** Deserializers support both camelCase and PascalCase DTO output from ASP.NET Core (`json['name'] ?? json['Name'] ?? ''`).
- **Computed Presentation Properties:** Models encapsulate formatting getters (`fullPosterUrl`, `isUpcoming`, `seatsDisplay`, `dateFormatted`, `timeFormatted`) keeping Flutter widget trees purely declarative.

---

## 2. Comprehensive Model Catalog

### 2.1 Movie & Cinema Discovery Models
**File:** `apps/mobile/lib/features/home/data/models/movie.dart`

#### `Movie`
Represents a cinematic title with media assets, showtime schedules, and cast metadata.
| Property | Type | Description |
| :--- | :--- | :--- |
| `id` | `String` | Unique movie identifier. |
| `title` | `String` | Movie title in English/Arabic. |
| `posterUrl` | `String` | Full poster image URI (TMDB or local CDN). |
| `backdropUrl` | `String` | Landscape banner backdrop image URI. |
| `genre` | `String` | Primary genre category (Action, Sci-Fi, Drama...). |
| `rating` | `double` | 10-star rating score (e.g. 8.4). |
| `duration` | `int` | Total runtime in minutes. |
| `showTimes` | `List<DateTime>` | Array of scheduled showtime timestamps. |
| `showtimeInfos` | `List<ShowtimeInfo>`| Array of rich showtime objects with hall & pricing. |
| `hallType` | `String` | Cinema hall tier (`IMAX`, `Standard`, `Gold`). |
| `overview` | `String` | Synopsis and plot summary. |
| `trailerKey` | `String?` | YouTube video ID / URL key for trailer playback. |
| `cast` | `List<CastMember>` | Key actors and crew members. |
| `hasTrailer` | `bool` *(computed)* | Returns `true` if `trailerKey` is present. |

#### `CastMember`
Represents an actor or actress in a film.
| Property | Type | Description |
| :--- | :--- | :--- |
| `name` | `String` | Actor's full name. |
| `character` | `String` | Character or role name. |
| `profilePath` | `String?` | Actor avatar photo path on TMDB. |
| `order` | `int` | Billing credit order. |

#### `ShowtimeInfo`
Represents an individual scheduled screening session.
| Property | Type | Description |
| :--- | :--- | :--- |
| `id` | `int` | Showtime primary key ID. |
| `startTime` | `DateTime` | Showtime screening timestamp. |
| `price` | `double` | Base ticket price in EGP/USD. |
| `hallName` | `String` | Name of auditorium/hall. |
| `totalSeats` | `int` | Total capacity of the hall. |
| `hallType` | `String` *(computed)* | Calculates `IMAX` (>=220 seats), `Standard` (>=80 seats), or `Gold`. |

---

### 2.2 Booking & Seat Layout Models
**Files:** `apps/mobile/lib/features/booking/data/models/`

#### `SeatDto` (`seat_dto.dart`)
Represents an individual physical cinema seat coordinate.
| Property | Type | Description |
| :--- | :--- | :--- |
| `row` | `int` | 1-indexed row number. |
| `seatNumber` | `int` | 1-indexed column seat number. |
| `id` | `String` *(computed)* | Unique string identifier in `'${row}_${seatNumber}'` format. |

#### `ShowtimeSeatDto` (`showtime_seat_dto.dart`)
Root payload describing a hall's seating grid layout, pricing tiers, and booked seats.
| Property | Type | Description |
| :--- | :--- | :--- |
| `showtimeId` | `int` | Target showtime identifier. |
| `movieId` | `int` | Associated movie ID. |
| `movieTitle` | `String` | Movie title. |
| `moviePosterPath`| `String?` | Relative poster image path. |
| `hallName` | `String` | Cinema hall designation. |
| `hallType` | `String` | Hall tier (`IMAX`, `Standard`, `Gold`). |
| `startsAt` | `DateTime` | Screening date and time. |
| `basePrice` | `double` | Standard seat base price. |
| `rows` | `int` | Total number of horizontal seat rows. |
| `seatsPerRow` | `int` | Number of seat columns per row. |
| `rowCategoryMap` | `Map<int, String>` | Mapping of row index to category (`Standard`, `VIP`, `Premium`). |
| `categoryPrices` | `Map<String, double>` | Dynamic ticket price per seat category tier. |
| `bookedSeats` | `List<SeatDto>` | List of seats currently occupied or reserved. |

#### `BookingCreateDto` (`booking_create_dto.dart`)
Request payload submitted to initiate a seat reservation or booking.
| Property | Type | Description |
| :--- | :--- | :--- |
| `showtimeId` | `int` | Target showtime identifier. |
| `seats` | `List<SeatDto>` | Array of user-selected seat coordinates. |

#### `BookingResultDto` (`booking_result_dto.dart`)
Response received upon submitting a booking request.
| Property | Type | Description |
| :--- | :--- | :--- |
| `succeeded` | `bool` | True if reservation succeeded without conflicts. |
| `bookingReference`| `String?` | Unique alphanumeric booking reference (e.g. `TK-98214`). |
| `totalAmount` | `double?` | Total cost of booked seats. |
| `conflictingSeats`| `List<SeatDto>`| List of seats that were taken concurrently by another user. |

#### `BookingDetailsDto` (`booking_details_dto.dart`)
Complete receipt and ticket details for an individual confirmed reservation.
| Property | Type | Description |
| :--- | :--- | :--- |
| `userId` | `String` | Customer user ID. |
| `userEmail` | `String` | Customer email address. |
| `bookingReference`| `String` | Unique alphanumeric booking reference code. |
| `status` | `String` | Booking status (`Confirmed`, `Pending`, `Cancelled`). |
| `bookedAt` | `DateTime` | Transaction timestamp. |
| `totalAmount` | `double` | Final charged price. |
| `movieTitle` | `String` | Movie title. |
| `moviePosterPath`| `String?` | Movie poster path. |
| `startsAt` | `DateTime` | Showtime screening timestamp. |
| `hallName` | `String` | Hall name. |
| `hallType` | `String` | Hall type. |
| `seats` | `List<BookingDetailsSeatDto>` | Array of booked seats with individual category and price. |
| `seatsDisplay` | `String` *(computed)* | Formatted string of seats (e.g. `"R1-S4, R1-S5"`). |
| `dateFormatted` | `String` *(computed)* | Formatted date string (`YYYY-MM-DD`). |
| `timeFormatted` | `String` *(computed)* | Formatted time string (`HH:mm`). |

#### `BookingHistoryItemDto` & `PagedBookingHistoryDto` (`booking_history_dto.dart`)
Models for user's past and upcoming booking history list.
| Property | Type | Description |
| :--- | :--- | :--- |
| `bookingReference`| `String` | Booking identifier. |
| `movieTitle` | `String` | Movie title. |
| `moviePosterPath`| `String?` | Poster path. |
| `showtimeStartsAt`| `DateTime` | Screening date/time. |
| `seatCount` | `int` | Total number of tickets in booking. |
| `totalAmount` | `double` | Total booking price. |
| `status` | `BookingStatus` | Enum: `confirmed`, `cancelled`, `completed`, `refunded`. |
| `isUpcoming` | `bool` *(computed)* | `true` if `showtimeStartsAt` is in the future. |
| `isPast` | `bool` *(computed)* | `true` if screening has passed. |
| `fullPosterUrl` | `String?` *(computed)* | Fully resolved TMDB poster image URL. |

---

### 2.3 Payment & Stripe DTOs
**File:** `apps/mobile/lib/features/payment/data/models/payment_models.dart`

#### `PaymentConfigDto`
Configuration metadata returned by the payment server.
| Property | Type | Description |
| :--- | :--- | :--- |
| `publishableKey` | `String` | Stripe public key used to initialize `Stripe.publishableKey`. |

#### `CreatePaymentIntentDto`
Payload sent to create a Stripe PaymentIntent for a set of seats.
| Property | Type | Description |
| :--- | :--- | :--- |
| `showtimeId` | `int` | Showtime ID. |
| `seats` | `List<SeatDto>` | Selected seats to purchase. |

#### `PaymentIntentResultDto`
Result returned from the backend Stripe PaymentIntent generation endpoint.
| Property | Type | Description |
| :--- | :--- | :--- |
| `clientSecret` | `String` | Stripe client secret used to initialize `PaymentSheet`. |
| `paymentIntentId`| `String` | Unique Stripe `pi_...` ID. |
| `totalAmount` | `double` | Exact calculated amount to be authorized. |

#### `ConfirmPaymentResultDto`
Confirmation result returned after Stripe webhook or client confirmation.
| Property | Type | Description |
| :--- | :--- | :--- |
| `succeeded` | `bool` | True if payment and booking are finalized. |
| `bookingReference`| `String?` | Generated cinema booking reference. |
| `totalAmount` | `double?` | Total charged amount. |
| `message` | `String` | Status or failure message. |
