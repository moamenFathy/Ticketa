import { motion } from "framer-motion";
import { Badge } from "./ui/badge";
import { Film, PlayCircle } from "lucide-react";
import { Button } from "./ui/button";
import {
  TMDB_IMAGE_ORIGINAL_URL,
  TMDB_IMAGE_POSTER_URL,
} from "@/api/constants";
import { Link } from "react-router-dom";

interface Props {
  movieId: string;
  title: string;
  posterPath: string;
  trailerKey: string;
  setIsVideoVisible: (visible: boolean) => void;
}

const HeroShowtimes = ({
  movieId,
  title,
  posterPath,
  trailerKey,
  setIsVideoVisible,
}: Props) => {
  return (
    <motion.div
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0 }}
      className="relative h-[30vh] md:h-[50vh] w-full overflow-hidden"
    >
      <div className="absolute inset-0">
        <img
          src={`${TMDB_IMAGE_ORIGINAL_URL}${posterPath}`}
          alt={title}
          className="w-full h-full object-cover object-top opacity-30 blur-sm scale-105"
        />
        <div className="absolute inset-0 bg-linear-to-t from-background via-background/60 to-transparent" />
      </div>

      <div className="container mx-auto px-4 h-full flex items-end pb-12 relative z-10">
        <div className="flex flex-col md:flex-row gap-8 items-end w-full">
          <Link to={`/movies/${movieId}`}>
            <motion.div
              initial={{ y: 20, opacity: 0 }}
              animate={{ y: 0, opacity: 1 }}
              className="hidden md:block w-48 aspect-2/3 rounded-2xl overflow-hidden shadow-2xl border border-white/10"
            >
              <img
                src={`${TMDB_IMAGE_POSTER_URL}${posterPath}`}
                alt={title}
                className="w-full h-full object-cover"
              />
            </motion.div>
          </Link>
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
              <Link to={`/movies/${movieId}`}>
                <h1 className="text-4xl md:text-6xl font-black tracking-tighter">
                  {title}
                </h1>
              </Link>
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
              {trailerKey && (
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
