import { Skeleton } from "@/components/ui/skeleton";

const ShowtimeSeatsSkeleton = () => {
  return (
    <div className="min-h-screen bg-background text-foreground overflow-x-hidden">
      <div className="container mx-auto px-4 py-8 max-w-6xl">
        {/* Back Button Skeleton */}
        <div className="mb-6">
          <Skeleton className="h-5 w-20" />
        </div>

        {/* Hero Card Skeleton */}
        <div className="relative rounded-3xl overflow-hidden border border-border bg-card/60 backdrop-blur-md shadow-2xl mb-8 p-6 md:p-8 flex flex-col md:flex-row gap-6 items-start md:items-center">
          <Skeleton className="w-28 md:w-36 aspect-[2/3] rounded-2xl shrink-0" />
          <div className="flex-1 space-y-4 w-full">
            <div className="space-y-2">
              <Skeleton className="h-6 w-32 rounded-md" />
              <Skeleton className="h-10 w-3/4 max-w-md" />
            </div>
            <div className="flex gap-4">
              <Skeleton className="h-5 w-24" />
              <Skeleton className="h-5 w-24" />
              <Skeleton className="h-5 w-32" />
            </div>
          </div>
          <div className="flex md:flex-col gap-2 shrink-0">
            <Skeleton className="h-10 w-32 rounded-xl" />
            <Skeleton className="h-10 w-32 rounded-xl" />
          </div>
        </div>

        {/* Main Content Skeleton */}
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6 items-start">
          {/* Seat Map Skeleton */}
          <div className="lg:col-span-2 rounded-3xl border border-border bg-card/50 backdrop-blur-md shadow-xl overflow-hidden">
            {/* Screen Skeleton */}
            <div className="px-8 pt-8 pb-4 flex flex-col items-center gap-2">
              <Skeleton className="w-full max-w-xl h-2 rounded-full" />
              <Skeleton className="h-3 w-16" />
            </div>

            {/* Seat Grid Skeleton */}
            <div className="p-8 flex flex-col items-center gap-2">
              {[...Array(8)].map((_, r) => (
                <div key={r} className="flex gap-1.5">
                  {[...Array(14)].map((_, s) => (
                    <Skeleton key={s} className="w-7 h-7 rounded-md" />
                  ))}
                </div>
              ))}
            </div>

            {/* Legend Skeleton */}
            <div className="border-t border-border px-6 py-4 flex flex-wrap gap-6">
              {[...Array(4)].map((_, i) => (
                <div key={i} className="flex items-center gap-2 text-xs">
                  <Skeleton className="w-5 h-5 rounded-sm" />
                  <Skeleton className="h-4 w-16" />
                </div>
              ))}
            </div>
          </div>

          {/* Sidebar Skeleton */}
          <div className="rounded-3xl border border-border bg-card/50 backdrop-blur-md shadow-xl p-6 space-y-6">
            <div className="space-y-2">
              <Skeleton className="h-6 w-32" />
              <Skeleton className="h-4 w-24" />
            </div>
            <div className="space-y-3">
              {[...Array(3)].map((_, i) => (
                <Skeleton key={i} className="h-20 w-full rounded-2xl" />
              ))}
            </div>
            <div className="pt-4 space-y-3">
              <div className="flex justify-between">
                <Skeleton className="h-4 w-16" />
                <Skeleton className="h-4 w-12" />
              </div>
              <Skeleton className="h-12 w-full rounded-xl" />
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default ShowtimeSeatsSkeleton;
