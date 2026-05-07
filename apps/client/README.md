# Ticketa Client

A modernized movie application client built with React 19, TypeScript, and Vite. 

## Tech Stack & Architecture

- **Framework:** React 19 + TypeScript 6.0
- **Build Tool:** Vite 8 
- **Routing:** React Router 7
- **Styling:** Tailwind CSS 4 + shadcn/ui components (Radix UI) 
- **Data Fetching:** TanStack Query (React Query v5) + Axios
- **Animations:** Framer Motion

## Detailed Implementation & Folder Structure

```text
src/
├── api/             # API layer setup
│   ├── client.ts    # Axios instance with timeout and interceptors for API errors
│   ├── movies.api.ts# Typed movie API endpoints functions
│   ├── queryKeys.ts # React Query key factory pattern (e.g. queryKeys.movies.nowPlaying)
│   └── errors.ts    # Custom error typing and handling
├── assets/          # Static assets (images, fonts, etc.)
├── components/      # Reusable React components
│   ├── ui/          # Generic shadcn UI components (badge, button, carousel, skeleton)
│   ├── Card.tsx     # Reusable movie card with Framer Motion hover effects and TMDB images
│   ├── HeroSection.tsx # Application main hero banner UI
│   ├── MovieList.tsx   # Displays a grid/carousel of Movie cards
│   ├── MovieListSkeleton.tsx # Loading skeleton state for the movie list
│   └── Navbar.tsx   # Top navigation component
├── hooks/           # Custom React hooks
│   └── useMovies.ts # React Query wrappers (e.g. useNowPlayingMovies) bundling API calls
├── lib/             # Utility functions
│   └── utils.ts     # generic utilities (e.g., `cn()` for Tailwind class conditional merging)
├── pages/           # Application route pages
│   ├── Home.tsx     # Homepage consuming the useMovies hook & UI components
│   └── layout/      
│       └── RootLayout.tsx # Global layout housing the Navbar and React Router `<Outlet />`
├── providers/       # Global context providers
│   └── QueryProvider.tsx # TanStack QueryClient setup and wrapper
├── types/           # TypeScript generic models
│   ├── api.ts       # API response & error data shapes
│   └── movie.ts     # Domain models for movies
├── App.tsx          # Application router configuration and nested route definitions
├── main.tsx         # Application entry point, wraps the app closely with providers
└── index.css        # Global CSS setup, Tailwind initialization, and Dark Theme variables
```

## Data Fetching & Query Management

We use a layered architecture for data fetching to enforce strict separation of concerns, utilizing **TanStack Query (React Query)** combined with **Axios**:

1. **Query Key Factory Pattern (`src/api/queryKeys.ts`)**:
   To prevent cache key typos and ensure consistent cache invalidation across the app, we centralize our query keys into query key factories.
   ```typescript
   export const queryKeys = {
     movies: {
       all: ['movies'] as const,
       nowPlaying: () => [...queryKeys.movies.all, 'nowPlaying'] as const,
       details: (id: string) => [...queryKeys.movies.all, 'detail', id] as const,
     }
   };
   ```

2. **API Endpoints (`src/api/movies.api.ts`)**:
   We define pure asynchronous functions that fetch data using our configured Axios client (`client.ts`). These functions are dedicated solely to communication and data typing, lacking any knowledge of React context.

3. **Custom React Hooks (`src/hooks/useMovies.ts`)**:
   We encapsulate `useQuery` and `useMutation` logic into reusable custom hooks that bind the query keys and API fetchers securely together. UI components, like specific pages in `/src/pages/`, simply consume our custom hooks (`useNowPlayingMovies()`), beautifully abstracting away caching, refetching, and network state semantics from UI markup.

## Setup & Scripts

Ensure you have a `.env` file at the root of the project pointing to your backend:

```env
VITE_API_URL=http://localhost:3000/api
```

In the project directory, you can run:

- `npm run dev` - Starts the Vite development server with HMR.
- `npm run build` - Type-checks the workspace and builds the optimal production React app.
- `npm run lint` - Validates code against ESLint recommendations.
- `npm run preview` - Bootstraps a local server to preview the production build.

