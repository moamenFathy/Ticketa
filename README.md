# 🎟️ Ticketa Monorepo

Welcome to the **Ticketa** monorepo! This repository unites all core subsystems of the Ticketa cinema booking and movie ticketing platform into a single repository with preserved git history across all services.

---

## 📁 Repository Structure

```text
Ticketa/
├── apps/
│   ├── server/           # Backend (ASP.NET Core Web API + MVC Admin Portal)
│   ├── client/           # Frontend Web Application (React.js + TypeScript / Vite)
│   └── mobile/           # Cross-platform Mobile Application (Flutter)
├── .github/              # Shared CI/CD workflows and actions
├── .gitignore            # Root gitignore rules
├── .gitattributes        # Line-endings & attributes
└── README.md             # Monorepo documentation
```

---

## 🚀 Subsystems Overview

### 1. ⚙️ Server (`apps/server`)
- **Tech Stack**: C# / .NET 8, ASP.NET Core Web API, ASP.NET Core MVC, Entity Framework Core, SQL Server.
- **Components**:
  - `Ticketa.API`: RESTful endpoints for mobile & web clients.
  - `Ticketa.Web`: MVC Backoffice / Admin Management dashboard.
  - `Ticketa.Core`: Domain models, interfaces, and business entities.
  - `Ticketa.Infrastructure`: Data persistence, migrations, and third-party integrations (Stripe, TMDB, Email).
  - `Ticketa.Tests` & `Ticketa.Test`: Unit & integration tests.

### 2. 🌐 Client Web (`apps/client`)
- **Tech Stack**: React 18, TypeScript, Vite / TailwindCSS.
- **Features**: Responsive customer-facing web experience for movie browsing, seat selection, and online checkout.

### 3. 📱 Mobile (`apps/mobile`)
- **Tech Stack**: Flutter 3.x, Dart, BLoC / Cubit State Management, Clean Architecture.
- **Features**: Native iOS and Android application with bilingual (AR/EN) support, interactive seat maps, QR ticketing, and payment gateway integration.

---

## 🛠️ Getting Started

### Prerequisites
- [.NET 8 SDK](https://dotnet.microsoft.com/download)
- [Node.js (v18+)](https://nodejs.org/) & [npm](https://npmjs.com/)
- [Flutter SDK (3.x)](https://flutter.dev/docs/get-started/install)
- [SQL Server](https://www.microsoft.com/sql-server/)

### Running the Subsystems

#### Backend (Server):
```bash
cd apps/server
dotnet restore
dotnet build
dotnet run --project Ticketa.API
```

#### Frontend (Client):
```bash
cd apps/client
npm install
npm run dev
```

#### Mobile (Flutter):
```bash
cd apps/mobile
flutter pub get
flutter run
```

---

## 🌿 Branching Strategy
- `development`: Primary integration branch where active development and feature merges happen.
- `main`: Production-ready releases.
- `feature/*`: Specific feature branches branched from `development`.
