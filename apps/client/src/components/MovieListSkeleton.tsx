import { Skeleton } from "@/components/ui/skeleton";

export function MovieListSkeleton() {
  return (
    <div className="flex gap-4 overflow-hidden">
      {Array.from({ length: 5 }).map((_, i) => (
        <div
          key={i}
          className="basis-1/2 md:basis-1/3 lg:basis-1/4 xl:basis-1/5 shrink-0 space-y-4"
        >
          <div className="relative aspect-[2/3] overflow-hidden rounded-2xl border border-white/5">
            <Skeleton className="h-full w-full" />

            {/* Genre Badge Skeleton */}
            <div className="absolute top-3 left-3">
              <Skeleton className="h-6 w-16 rounded-full opacity-50" />
            </div>
          </div>

          <div className="px-1 space-y-2">
            <Skeleton className="h-5 w-3/4" />
            <div className="flex gap-2">
              <Skeleton className="h-3 w-12 opacity-50" />
              <Skeleton className="h-3 w-12 opacity-50" />
              <Skeleton className="h-3 w-12 opacity-50" />
            </div>
          </div>
        </div>
      ))}
    </div>
  );
}
