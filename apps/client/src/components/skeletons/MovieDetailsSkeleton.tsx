import { Skeleton } from "../ui/skeleton";

const MovieDetailsSkeleton = () => (
  <div className="min-h-screen bg-white dark:bg-[#080a0f] overflow-hidden">
    {/* 1. Hero Skeleton */}
    <section className="relative h-[95vh] w-full flex items-center justify-center">
      {/* Backdrop Skeleton */}
      <div className="absolute inset-0 w-full h-full opacity-20 dark:opacity-30">
        <Skeleton className="w-full h-full bg-black/10 dark:bg-white/10" />
      </div>

      <div className="relative z-20 w-full max-w-7xl px-6 grid grid-cols-1 lg:grid-cols-12 gap-12 lg:gap-24 items-center">
        {/* Poster Skeleton (Left) */}
        <div className="hidden lg:block lg:col-span-4">
          <Skeleton className="aspect-[2/3] rounded-[3rem] bg-black/5 dark:bg-white/10 shadow-2xl" />
        </div>

        {/* Details Skeleton (Right) */}
        <div className="lg:col-span-8 space-y-8">
          {/* Genres */}
          <div className="flex gap-3">
            <Skeleton className="h-8 w-20 rounded-full bg-black/5 dark:bg-white/5" />
            <Skeleton className="h-8 w-24 rounded-full bg-black/5 dark:bg-white/5" />
            <Skeleton className="h-8 w-16 rounded-full bg-black/5 dark:bg-white/5" />
          </div>

          {/* Title */}
          <div className="space-y-4">
            <Skeleton className="h-24 w-3/4 rounded-2xl bg-black/5 dark:bg-white/5" />
            <Skeleton className="h-24 w-1/2 rounded-2xl bg-black/5 dark:bg-white/5" />
          </div>

          {/* Stats Bar */}
          <div className="flex flex-wrap gap-4 mt-8">
            <Skeleton className="h-20 w-32 rounded-3xl bg-black/5 dark:bg-white/5" />
            <Skeleton className="h-20 w-40 rounded-3xl bg-black/5 dark:bg-white/5" />
            <Skeleton className="h-20 w-32 rounded-3xl bg-black/5 dark:bg-white/5" />
            <Skeleton className="h-20 w-32 rounded-3xl bg-black/5 dark:bg-white/5" />
          </div>

          {/* Synopsis */}
          <div className="space-y-4">
            <Skeleton className="h-4 w-24 rounded bg-black/5 dark:bg-white/5" />
            <div className="space-y-2">
              <Skeleton className="h-6 w-full rounded bg-black/5 dark:bg-white/5" />
              <Skeleton className="h-6 w-11/12 rounded bg-black/5 dark:bg-white/5" />
              <Skeleton className="h-6 w-4/5 rounded bg-black/5 dark:bg-white/5" />
            </div>
          </div>

          {/* Buttons */}
          <div className="flex flex-wrap gap-6 pt-4">
            <Skeleton className="h-16 w-52 rounded-2xl bg-black/10 dark:bg-white/10" />
            <Skeleton className="h-16 w-48 rounded-2xl bg-black/5 dark:bg-white/5" />
          </div>
        </div>
      </div>
    </section>

    {/* 2. Cast Skeleton Area */}
    <section className="relative z-20 px-6 lg:px-20 max-w-7xl mx-auto py-20">
      <div className="space-y-8">
        <Skeleton className="h-4 w-40 rounded bg-black/5 dark:bg-white/5" />
        <Skeleton className="h-16 w-64 rounded-xl bg-black/5 dark:bg-white/5" />
        <div className="flex gap-6 pt-10 overflow-hidden">
          {[1, 2, 3, 4, 5].map((i) => (
            <Skeleton
              key={i}
              className="min-w-[200px] aspect-[3/4] rounded-[2.5rem] bg-black/5 dark:bg-white/5"
            />
          ))}
        </div>
      </div>
    </section>
  </div>
);

export default MovieDetailsSkeleton;
