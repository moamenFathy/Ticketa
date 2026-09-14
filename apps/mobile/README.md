<div align="center">

  <img src="../../assets/ticketa_readme_banner.jpg" alt="Ticketa Platform Showcase" width="100%" style="border-radius: 14px; box-shadow: 0 12px 36px rgba(0,0,0,0.18);" />

  <br/><br/>

  [![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
  [![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
  [![Architecture](https://img.shields.io/badge/Architecture-Clean%20%2B%20Feature--First-7C3AED?style=for-the-badge)](../../docs/Modules/Mobile/Architecture.md)
  [![State Management](https://img.shields.io/badge/State-Bloc%20%2F%20Cubit-1D61E7?style=for-the-badge)](../../docs/Modules/Mobile/StateManagement.md)
  [![Backend Ecosystem](https://img.shields.io/badge/.NET%209-ASP.NET%20Core-512BD4?style=for-the-badge&logo=dotnet&logoColor=white)](https://dotnet.microsoft.com)
  [![Stripe Payments](https://img.shields.io/badge/Payments-Stripe%203D%20Secure-635BFF?style=for-the-badge&logo=stripe&logoColor=white)](https://stripe.com)
  [![QR Code Entry](https://img.shields.io/badge/Cinema%20Pass-Vector%20QR-10B981?style=for-the-badge&logo=qr-code&logoColor=white)](../../docs/Modules/Mobile/Features/PaymentAndCheckout.md)

  <p align="center">
    <b>A cinema ticketing & movie discovery mobile client built with Flutter. Engineered with Clean Architecture, BLoC/Cubit State Management, Stripe Payment Sheet, Interactive Canvas Hall Seat Selection, Digital QR Cinema Passes, and Full Dual-Language (AR/EN) RTL/LTR Support.</b>
  </p>

  <p align="center">
    <a href="#-overview--vision">Overview</a> •
    <a href="#-key-features">Features</a> •
    <a href="#-architecture--design-patterns">Architecture</a> •
    <a href="#-ecosystem--backend-integration">Ecosystem & API</a> •
    <a href="#-tech-stack--dependencies">Tech Stack</a> •
    <a href="#-documentation-hub">Documentation Hub</a>
  </p>

</div>

---

## 📖 Overview & Vision

**Ticketa Mobile** is a cinema discovery and reservation mobile client built for modern moviegoers. It delivers a fluid cinema experience, from exploring blockbuster trailers to reserving specific auditorium seats (Standard, VIP, IMAX) in real-time, executing instant Stripe checkout, and storing contactless QR tickets in a personal digital wallet.

```
                                  ┌───────────────────────────────┐
                                  │       Ticketa Ecosystem       │
                                  └──────────────┬────────────────┘
                                                 │
                   ┌─────────────────────────────┼─────────────────────────────┐
                   ▼                             ▼                             ▼
       ┌───────────────────────┐     ┌───────────────────────┐     ┌───────────────────────┐
       │   Flutter Mobile App  │◄───►│   .NET 9.0 REST API   │◄───►│ React Admin Dashboard │
       │   (iOS & Android)     │     │   (Core & Clean Arch) │     │ (Management Portal)   │
       └───────────────────────┘     └───────────┬───────────┘     └───────────────────────┘
                                                 │
                                 ┌───────────────┴───────────────┐
                                 ▼                               ▼
                     ┌───────────────────────┐       ┌───────────────────────┐
                     │   Stripe 3D Secure    │       │  TMDB Media Metadata  │
                     └───────────────────────┘       └───────────────────────┘
```

---

## 🌟 Key Features

- 🎬 **Hero Discovery Spotlight:** Parallax carousel highlighting top blockbusters with instant booking actions.
- 🍿 **Curated Theater Shelves:** Now Showing, Top Booked box-office hits, and Coming Soon releases.
- 🎥 **In-App Trailer Playback:** Embedded YouTube modal player and full-screen landscape video player.
- 🎟️ **Interactive Seating Grid:** Custom Canvas-painted cinema screen (IMAX / Standard / VIP) with real-time seat selection, multi-seat cap, and tier pricing.
- 💳 **Stripe Payment Sheet:** Seamless in-app checkout supporting Credit/Debit cards, Apple Pay, Google Pay, and 3D Secure 2.
- 📱 **Digital Ticket Wallet & QR:** Perforated ticket pass stubs with dynamic QR codes for instant gate validation.
- 🌍 **Dual-Language (AR/EN) Support:** Full Arabic RTL mirroring with Tajawal/Cairo typography and dynamic language switching.
- 🌓 **Cinema Dark Aesthetic:** Custom frosted glassmorphism (`GlassCard`), neon orange brand accents (`#F2612B`), and light/dark theme modes.

---

## 🏛️ Architecture & Design Patterns

The mobile application follows **Feature-First Clean Architecture**:
- **Presentation:** Flutter widgets and reactive `Cubit` controllers.
- **Domain & Data:** Strongly typed immutable DTOs and abstract repositories.
- **Core Infrastructure:** `ApiService` (Dio wrapper with 401 automatic token refresh via `PersistCookieJar`), centralized `NavigationService`, and `MessageService`.

---

## 📚 Documentation Hub

For exhaustive technical guides, deep-dives, and API specifications, consult the official documentation modules:

- 🏛️ [Mobile Architecture & Engineering Guide](../../docs/Modules/Mobile/Architecture.md)
- ⚙️ [Core Services & Network Pipeline](../../docs/Modules/Mobile/CoreServices.md)
- 🌍 [Localization & RTL Support](../../docs/Modules/Mobile/Localization.md)
- 📊 [Data Models & DTO Reference](../../docs/Modules/Mobile/Models.md)
- 🧭 [Navigation & Routing Matrix](../../docs/Modules/Mobile/Navigation.md)
- 🔄 [State Management (BLoC / Cubit)](../../docs/Modules/Mobile/StateManagement.md)
- 🗄️ [Repositories & Endpoints](../../docs/Modules/Mobile/Repositories.md)
- 🎨 [Reusable UI Widgets](../../docs/Modules/Mobile/Widgets.md)
- 🌟 [Feature Modules & Flow Deep-Dives](../../docs/Modules/Mobile/Features/)
- 📱 [Screen Deep-Dives](../../docs/Modules/Mobile/Screens/)
