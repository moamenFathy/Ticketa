# Mobile Reusable UI Widgets Catalog

> **Directories:** `apps/mobile/lib/core/widgets/` & `apps/mobile/lib/features/*/presentation/widgets/`  
> **Aesthetic Philosophy:** Premium Dark Cinema Theme, Frosted Glassmorphism (`BackdropFilter`), Smooth Micro-interactions, and Adaptive Typography.

---

## 1. Core Shared Widgets (`core/widgets/`)

### 1.1 `GlassCard` (`glass_card.dart`)
A high-performance frosted glassmorphic container using `BackdropFilter` with customizable Gaussian blur and opacity.
- **Properties:** `child`, `blur: 10.0`, `opacity: 0.1`, `borderRadius`, `border`, `padding`.
- **Adaptive Appearance:** Automatically switches between white frosted glow in dark mode and subtle dark tint in light mode.

### 1.2 `AppShimmer` (`app_shimmer.dart`)
A 60 FPS skeleton loading gradient wrapper powered by the `shimmer` package.
- **Modes:** `AppShimmer.card`, `AppShimmer.text`, `AppShimmer.avatar`.
- **Colors:** Deep charcoal base (`#1A252A`) with soft silver highlight.

### 1.3 `CustomDatePicker` (`custom_date_picker.dart`)
A custom themed date selector supporting ISO date format selection with calendar modal and wheel picker.

### 1.4 `GoogleLogo` (`google_logo.dart`)
Vector-drawn official Google 4-color "G" logo for the social authentication button.

---

## 2. Booking & Cinema Widgets (`features/booking/presentation/widgets/`)

### 2.1 `CinemaScreenPainter` (`cinema_screen_painter.dart`)
A custom `CustomPainter` that renders a glowing curved cinema projection screen on Flutter `Canvas`.
- **IMAX Curve:** Uses `Path.quadraticBezierTo` to draw an authentic curved IMAX projection screen.
- **Lighting Shader:** Applies a radial and linear projection light glow falling downwards across the seat grid.

### 2.2 `CinemaSeatGrid` (`cinema_seat_grid.dart`)
An interactive matrix rendering cinema seating rows:
- **Seat States:** Available, Selected (Warm Orange `#F2612B`), Reserved/Booked (Muted Grey), VIP/Gold.
- **Haptic Feedback:** Vibrates on seat tap.
- **Multi-Selection Cap:** Enforces a maximum selection of 10 seats per booking.

### 2.3 `SeatLegend` (`seat_legend.dart`)
Horizontal legend showing seat color indicators: Available, Selected, Reserved, VIP.

### 2.4 `SeatDateSelector` & `TimeSelector`
- `SeatDateSelector`: Horizontal carousel of upcoming calendar days with weekday, day number, and month labels.
- `TimeSelector`: Horizontal pill wrap of available screening hours (e.g. `14:30`, `18:00`, `21:15`) with hall type tags (`IMAX`, `3D`).

### 2.5 `SeatSelectionAppBar` & `SeatSelectionBottomBar`
- `SeatSelectionAppBar`: Frosted back button, movie title, and cinema hall name.
- `SeatSelectionBottomBar`: Displays total selected seat count, calculated price sum, and sticky "Checkout" button.

---

## 3. Movie Discovery & Home Widgets (`features/home/presentation/widgets/`)

### 3.1 `HomeHeroSection` & `HeroCard`
- `HomeHeroSection`: Animated `PageView` featuring top trending movies with parallax effect.
- `HeroCard`: High-resolution backdrop image, gradient overlay, rating badge, and "Book Tickets" CTA button.

### 3.2 `MovieHorizontalList` & `SmallMovieCard`
- `MovieHorizontalList`: Scrollable horizontal carousel with section header and "See All" button.
- `SmallMovieCard`: Aspect ratio `2:3` movie poster with hero transition, rating tag, and genre label.

### 3.3 `MovieCastList` (`movie_cast_list.dart`)
Circular avatar list of movie cast members with character roles.

### 3.4 `TrailerVideoModal` & `FullscreenTrailerPlayer`
- `TrailerVideoModal`: Bottom sheet with embedded YouTube video player.
- `FullscreenTrailerPlayer`: Full-screen immersive landscape video player with playback controls.

---

## 4. Payment & Ticketing Widgets (`features/payment/presentation/widgets/`)

### 4.1 `OrderSummary` (`order_summary.dart`)
Itemized breakdown card displaying movie title, cinema hall, seat list, subtotal, taxes/service fees, and final total.

### 4.2 `TicketCard` (`ticket_card.dart`)
An authentic cinema ticket stub UI with perforated edges, cutout notches, movie poster, showtime details, and dynamic vector QR code generated via `qr_flutter`.

---

## 5. Settings & Profile Widgets (`features/settings/presentation/widgets/`)

### 5.1 `ProfileHeader` (`profile_header.dart`)
Displays user avatar, display name, email, and VIP member badge.

### 5.2 `PremiumStats` (`premium_stats.dart`)
Stats row showing total movies watched, active tickets count, and loyalty points.

### 5.3 `SettingsTile` (`settings_tile.dart`)
Custom list tile with icon, title, subtitle, trailing switch/chevron, and press animation.

### 5.4 `LanguageSelector` (`language_selector.dart`)
Modal sheet allowing instantaneous switching between English and Arabic.
