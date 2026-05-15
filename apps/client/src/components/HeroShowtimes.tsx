import { motion } from "framer-motion";
import { Badge } from "./ui/badge";
import { Film, PlayCircle } from "lucide-react";
import { Button } from "./ui/button";
import type { MoviesShowtimes } from "@/types/showtimes";

interface Props {
  selectedMovie: MoviesShowtimes;
  setIsVideoVisible: (visible: boolean) => void;
}

const HeroShowtimes = ({ selectedMovie, setIsVideoVisible }: Props) => {
  return (
    <motion.div
      key={selectedMovie.movieId}
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0 }}
      className="relative h-[50vh] w-full overflow-hidden"
    >
      <div className="absolute inset-0">
        <img
          src={`https://image.tmdb.org/t/p/original${selectedMovie.posterPath}`}
          alt={selectedMovie.title}
          className="w-full h-full object-cover object-top opacity-30 blur-sm scale-105"
        />
        <div className="absolute inset-0 bg-linear-to-t from-background via-background/60 to-transparent" />
      </div>

      <div className="container mx-auto px-4 h-full flex items-end pb-12 relative z-10">
        <div className="flex flex-col md:flex-row gap-8 items-end w-full">
          <motion.div
            initial={{ y: 20, opacity: 0 }}
            animate={{ y: 0, opacity: 1 }}
            className="hidden md:block w-48 aspect-2/3 rounded-2xl overflow-hidden shadow-2xl border border-white/10"
          >
            <img
              src={`https://image.tmdb.org/t/p/w500${selectedMovie.posterPath}`}
              alt={selectedMovie.title}
              className="w-full h-full object-cover"
            />
          </motion.div>
          <div className="flex-1 space-y-4">
            <motion.div
              initial={{ x: -20, opacity: 0 }}
              animate={{ x: 0, opacity: 1 }}
              transition={{ delay: 0.1 }}
            >
              <Badge
                variant="outline"
                className="mb-2 text-primary border-primary/30 uppercase tracking-[0.2em] px-3 py-1"
              >
                Now Showing
              </Badge>
              <h1 className="text-4xl md:text-6xl font-black tracking-tighter">
                {selectedMovie.title}
              </h1>
            </motion.div>
            <motion.div
              initial={{ y: 10, opacity: 0 }}
              animate={{ y: 0, opacity: 1 }}
              transition={{ delay: 0.2 }}
              className="flex flex-wrap gap-4"
            >
              <div className="flex items-center gap-2 text-muted-foreground">
                <Film className="w-5 h-5 text-primary" />
                <span className="font-medium">Premium Experience</span>
              </div>
              {selectedMovie.trailerKey && (
                <Button
                  variant="secondary"
                  size="default"
                  className="rounded-full gap-2 bg-white/10 hover:bg-primary hover:text-primary-foreground backdrop-blur-md border border-white/20 transition-all duration-500 group shadow-lg shadow-primary"
                  onClick={() => setIsVideoVisible(true)}
                >
                  <PlayCircle className="w-5 h-5 transition-transform group-hover:scale-110" />
                  <span className="font-semibold">Watch Trailer</span>
                </Button>
              )}
            </motion.div>
          </div>
        </div>
      </div>
    </motion.div>
  );
};

export default HeroShowtimes;
