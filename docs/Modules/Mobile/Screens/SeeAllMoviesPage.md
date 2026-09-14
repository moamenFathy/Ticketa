# Mobile Screen Deep-Dive: `SeeAllMoviesPage`

> **File Path:** `apps/mobile/lib/features/home/presentation/screens/see_all_movies_page.dart`  
> **Route Type:** Imperative MaterialPageRoute  
> **Parameters:** `title` (String), `movies` (List<Movie>)  
> **Layout:** 2-column responsive grid with live search filtering

---

## 1. Overview & Business Objectives

`SeeAllMoviesPage` displays the complete movie list when a user taps "See All" on any home shelf:
1. **Header & Title:** Custom app bar displaying the section name (e.g. "Now Showing", "Top Booked", "Coming Soon").
2. **Search Input:** Local search bar filtering movies instantly by title and genre.
3. **Responsive Grid:** 2-column grid layout adapting to mobile and tablet screen widths.
4. **Movie Poster Card:** Poster image, star rating, title, and release details with hero transitions to `MovieDetailPage`.
