# Mobile Screen Deep-Dive: `MainPage`

> **File Path:** `apps/mobile/lib/features/main/presentation/screens/main_page.dart`  
> **Route Name:** `'/main'`  
> **Scale:** 243 lines of Dart code  
> **Tabs:** 4 Indexed Views (`HomePage`, `NowShowingPage`, `MyTicketsPage`, `SettingsPage`)  
> **Navigation UI:** iOS Native `CNTabBar` / Android Floating `GNav` Bar

---

## 1. Overview & Business Objectives

`MainPage` is the central navigation host for the Ticketa app. It hosts four distinct modules in an `IndexedStack` preserving tab state while providing smooth cross-tab animated transitions (fade + slight vertical slide).

---

## 2. Adaptive Navigation Architecture

```mermaid
graph TD
    Main[MainPage Shell] --> Stack[IndexedStack with AnimationController]
    
    Stack --> T0[Tab 0: HomePage]
    Stack --> T1[Tab 1: NowShowingPage]
    Stack --> T2[Tab 2: MyTicketsPage]
    Stack --> T3[Tab 3: SettingsPage]
    
    Main --> PlatformCheck{Theme.platform == iOS?}
    PlatformCheck -->|Yes| IosBar[CNTabBar: Cupertino Native SF Symbols]
    PlatformCheck -->|No| AndroidBar[GNav Floating Frosted Glass Bar]
    
    IosBar --> SwitchTab[Tab Switcher with RTL Reversal]
    AndroidBar --> SwitchTab
```

---

## 3. Tab Index Matrix

| Index (LTR) | Index (RTL) | Tab Label | Icon (iOS / Android) | Screen Component |
| :--- | :--- | :--- | :--- | :--- |
| **0** | **3** | `Home` | `house.fill` / `Icons.movie_filter_rounded` | `HomePage` |
| **1** | **2** | `Now Showing` | `film.fill` / `Icons.local_play_rounded` | `NowShowingPage` |
| **2** | **1** | `My Tickets` | `ticket.fill` / `Icons.confirmation_number_rounded` | `MyTicketsPage` |
| **3** | **0** | `Account` | `person.fill` / `Icons.person_rounded` | `SettingsPage` |
