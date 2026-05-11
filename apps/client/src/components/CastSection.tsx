import { motion } from "framer-motion";
import { User } from "lucide-react";
import {
  Carousel,
  CarouselContent,
  CarouselItem,
  CarouselNext,
  CarouselPrevious,
} from "@/components/ui/carousel";
import type { Cast } from "@/types/movie";

const TMDB_IMG = "https://image.tmdb.org/t/p";

interface CastSectionProps {
  cast: Cast[];
}

export const CastSection = ({ cast }: CastSectionProps) => {
  return (
    <section className="mt-40 space-y-16">
      <div className="flex flex-col md:flex-row items-end justify-between gap-6">
        <div className="space-y-4">
          <motion.span
            initial={{ opacity: 0, x: -20 }}
            whileInView={{ opacity: 1, x: 0 }}
            className="text-primary font-black uppercase tracking-[0.6em] text-[11px] block"
          >
            Behind the characters
          </motion.span>
          <h2 className="text-5xl md:text-7xl font-black tracking-tighter italic italic-outline text-black/90 dark:text-white/90">
            The Ensemble
          </h2>
        </div>
      </div>

      <div className="relative">
        <Carousel opts={{ align: "start", dragFree: true }} className="w-full">
          <CarouselContent className="-ml-6">
            {cast.map((person, index) => (
              <CarouselItem
                key={person.name + index}
                className="pl-6 basis-full sm:basis-1/2 md:basis-1/3 lg:basis-1/4 xl:basis-1/5 group"
              >
                <motion.div
                  initial={{ opacity: 0, y: 30 }}
                  whileInView={{ opacity: 1, y: 0 }}
                  viewport={{ once: true }}
                  transition={{ delay: index * 0.05 }}
                  className="relative aspect-[3/4] rounded-[2.5rem] overflow-hidden border border-black/10 dark:border-white/5 bg-gray-950 group-hover:border-primary/30 transition-all duration-500 shadow-2xl"
                >
                  {person.profile_path ? (
                    <img
                      src={`${TMDB_IMG}/w500${person.profile_path}`}
                      alt={person.name}
                      className="w-full h-full object-cover transition-all duration-700 group-hover:scale-105"
                    />
                  ) : (
                    <div className="w-full h-full flex items-center justify-center bg-black/5 dark:bg-white/5">
                      <User className="w-16 h-16 text-black/10 dark:text-white/10" />
                    </div>
                  )}

                  <div className="absolute inset-0 bg-gradient-to-t from-black via-black/40 to-transparent flex flex-col justify-end p-6 select-none">
                    <h4 className="text-lg font-black text-white leading-tight drop-shadow-md">
                      {person.name}
                    </h4>
                    <p className="text-primary font-bold uppercase text-[10px] tracking-[0.15em] mt-1.5 drop-shadow-md">
                      {person.character}
                    </p>
                  </div>
                </motion.div>
              </CarouselItem>
            ))}
          </CarouselContent>
          <div className="flex justify-end gap-4 mt-8">
            <CarouselPrevious className="static translate-y-0 w-12 h-12 bg-black/5 dark:bg-white/5 border-black/10 dark:border-white/10 text-primary hover:bg-primary hover:border-primary hover:text-white transition-all scale-100" />
            <CarouselNext className="static translate-y-0 w-12 h-12 bg-black/5 dark:bg-white/5 border-black/10 dark:border-white/10 text-primary hover:bg-primary hover:border-primary hover:text-white transition-all scale-100" />
          </div>
        </Carousel>
      </div>
    </section>
  );
};
