import { Skeleton } from "@/components/ui/skeleton";

const HeroSectionSkeleton = () => {
  return (
    <section className="relative h-[85vh] w-full overflow-hidden bg-black">
      {/* Background Skeleton */}
      <div className="absolute inset-0">
        <Skeleton className="h-full w-full rounded-none bg-white/5" />
        <div className="absolute inset-0 bg-linear-to-t from-[#030712] via-[#030712]/40 to-transparent" />
        <div className="absolute inset-0 bg-linear-to-r from-[#030712] via-transparent to-transparent" />
      </div>

      {/* Main Content Skeleton */}
      <div className="relative h-full container mx-auto px-6 flex flex-col justify-end pb-20 md:pb-28">
        <div className="flex flex-col md:flex-row items-end gap-10">
          {/* Floating Poster Skeleton */}
          <div className="hidden lg:block shrink-0">
            <Skeleton className="w-48 h-72 rounded-2xl bg-white/10" />
          </div>

          <div className="flex-1 space-y-6 w-full">
            <div className="space-y-4">
              <div className="flex items-center gap-3">
                <Skeleton className="h-7 w-28 rounded-md bg-white/10" />
                <Skeleton className="h-5 w-32 bg-white/10" />
              </div>

              <Skeleton className="h-16 md:h-24 w-3/4 bg-white/10" />

              <div className="space-y-2">
                <Skeleton className="h-5 w-full max-w-2xl bg-white/10" />
                <Skeleton className="h-5 w-2/3 max-w-2xl bg-white/10" />
              </div>

              <Skeleton className="h-5 w-48 bg-white/10" />

              <div className="flex flex-wrap items-center gap-4 pt-4">
                <Skeleton className="h-16 w-48 rounded-2xl bg-white/10" />
                <Skeleton className="h-16 w-16 rounded-2xl bg-white/10" />
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Thumbnails Skeleton */}
      <div className="absolute bottom-10 right-10 z-20 hidden md:flex items-center gap-3 p-3 bg-black/40 backdrop-blur-2xl rounded-[2rem] border border-white/10">
        {[...Array(6)].map((_, i) => (
          <Skeleton
            key={i}
            className={`shrink-0 rounded-2xl bg-white/10 ${
              i === 0 ? "w-32 h-20" : "w-20 h-14"
            }`}
          />
        ))}
      </div>
    </section>
  );
};

export default HeroSectionSkeleton;
