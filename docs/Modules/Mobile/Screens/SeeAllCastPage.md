# Mobile Screen Deep-Dive: `SeeAllCastPage`

> **File Path:** `apps/mobile/lib/features/home/presentation/screens/see_all_cast_page.dart`  
> **Route Type:** Imperative MaterialPageRoute  
> **Parameters:** `cast` (List<CastMember>), `movieTitle` (String)  
> **Layout:** 3-column avatar grid

---

## 1. Overview & Business Objectives

`SeeAllCastPage` renders the complete ensemble cast and crew for a movie:
1. **Credited Cast Gallery:** 3-column grid featuring high-resolution actor headshots.
2. **Actor Details:** Real actor name and in-movie character role.
3. **Image Fallbacks:** Graceful initials fallback placeholder when TMDB headshot is unavailable.
