# Ticketa Mobile Documentation Index

Welcome to the comprehensive technical documentation for the **Ticketa Mobile Application** (`apps/mobile`).

---

## 📚 Documentation Table of Contents

### 🏛️ Architecture, Quality & Infrastructure
- [Architecture & Engineering Guide](./Architecture.md) — Feature-First Clean Architecture, bootstrap sequence, dual-token security, error handling, directory layout.
- [Core Services & Network Pipeline](./CoreServices.md) — `ApiService`, interceptor pipeline, `NavigationService`, `MessageService`, `ThemeService`, `LocaleService`, `GoogleAuthService`, `YouTubeUtils`.
- [Localization & Internationalization (i18n)](./Localization.md) — Bilingual (AR/EN) support, RTL layout flipping, font engines, ARB message files.
- [State Management (BLoC / Cubit)](./StateManagement.md) — Cubit catalog, state machines, unidirectional flow, `AppBlocObserver`.
- [Repositories & Data Access](./Repositories.md) — `MovieRepository`, `BookingRepository`, `PaymentRepository`, `AuthRepository`.
- [Data Models & DTO Reference](./Models.md) — Complete serialization catalog, defensive parsing, DTO schemas.
- [Navigation & Routing Matrix](./Navigation.md) — Named routes table, tabbed shell navigation, parameter passing.
- [Design System & UI Guidelines](./DesignSystem.md) — Cinema Dark aesthetic, color tokens, typography, glassmorphism shaders.
- [Reusable Widgets Catalog](./Widgets.md) — Glassmorphism cards, shimmers, cinema screen painter, interactive seat grid.
- [Testing & Quality Assurance](./Testing.md) — BLoC testing strategies, mock injection, coverage scripts.

---

### 🌟 Feature Modules (`docs/Modules/Mobile/Features/`)
- [Authentication & Identity](./Features/Auth.md) — Login, register, email confirmation OTP, Google OAuth, guest mode.
- [Home & Discovery](./Features/Home.md) — Hero spotlight carousel, now showing, top booked, coming soon shelves.
- [Movie Catalog & Media](./Features/MovieCatalog.md) — Movie details, cast gallery, YouTube trailer modal & fullscreen player, showtime dates.
- [Now Showing](./Features/NowShowing.md) — Theater movie catalog, genre chip filters, title search.
- [Cinema Seat Selection & Booking](./Features/BookingAndSeatSelection.md) — Interactive cinema seating matrix, hall types (IMAX/Gold/Standard), seat conflict resolution.
- [Payment & Checkout](./Features/PaymentAndCheckout.md) — Stripe Payment Sheet, 3D Secure, order summary, instant digital ticket issuing.
- [Profile, Settings & Tickets](./Features/ProfileAndSettings.md) — Digital ticket wallet, edit profile, change password, dark mode switch, language selector.

---

### 📱 Screen Deep-Dives (`docs/Modules/Mobile/Screens/`)
- [SplashScreen](./Screens/SplashScreen.md)
- [LoginPage](./Screens/LoginPage.md)
- [RegisterPage](./Screens/RegisterPage.md)
- [ConfirmEmailPage](./Screens/ConfirmEmailPage.md)
- [ForgotPasswordPage](./Screens/ForgotPasswordPage.md)
- [MainPage](./Screens/MainPage.md)
- [HomePage](./Screens/HomePage.md)
- [MovieDetailPage](./Screens/MovieDetailPage.md)
- [SeeAllMoviesPage](./Screens/SeeAllMoviesPage.md)
- [SeeAllCastPage](./Screens/SeeAllCastPage.md)
- [NowShowingPage](./Screens/NowShowingPage.md)
- [SeatSelectionPage](./Screens/SeatSelectionPage.md)
- [PaymentPage](./Screens/PaymentPage.md)
- [BookingSuccessPage](./Screens/BookingSuccessPage.md)
- [MyTicketsPage](./Screens/MyTicketsPage.md)
- [SettingsPage](./Screens/SettingsPage.md)
- [EditProfilePage](./Screens/EditProfilePage.md)
- [ChangePasswordPage](./Screens/ChangePasswordPage.md)
