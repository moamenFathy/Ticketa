import { useGetShowtimes } from "@/hooks/useShowtimes";
import { Calendar, Clock, Ticket, Film, PlayCircle } from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";
import { useMemo, useState } from "react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { MovieListSkeleton } from "@/components/MovieListSkeleton";
import { Card, CardContent } from "@/components/ui/card";
import { format } from "date-fns";
import ErrorState from "@/components/ErrorState";

const Showtimes = () => {
  const {
    data: moviesWithShowtimes,
    isLoading,
    isError,
    refetch,
  } = useGetShowtimes();

  const [selectedMovieId, setSelectedMovieId] = useState<string | null>(null);
  const [isVideoVisible, setIsVideoVisible] = useState(false);

  const selectedMovie =
    moviesWithShowtimes?.find((m) => m.movieId === selectedMovieId) ||
    moviesWithShowtimes?.[0];

  const hallNames = useMemo(
    () => [
      ...new Set(
        selectedMovie?.showtimes.map((showtime) => showtime.hallName) ?? [],
      ),
    ],
    [selectedMovie?.showtimes],
  );

  if (isLoading) {
    return (
      <div className="container mx-auto px-4 py-12">
        <div className="flex flex-col gap-8">
          <div className="space-y-4">
            <div className="h-10 w-64 bg-muted animate-pulse rounded-lg" />
            <div className="h-4 w-96 bg-muted animate-pulse rounded-lg" />
          </div>
          <MovieListSkeleton />
        </div>
      </div>
    );
  }

  if (isError) {
    return <ErrorState refetch={refetch} />;
  }

  return (
    <div className="min-h-screen bg-background text-foreground pb-20">
      {/* Hero Section for Selected Movie */}
      <AnimatePresence mode="wait">
        {selectedMovie && (
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
                        size="sm"
                        className="rounded-full gap-2"
                        onClick={() => setIsVideoVisible(true)}
                      >
                        <PlayCircle className="w-4 h-4" />
                        Watch Trailer
                      </Button>
                    )}
                  </motion.div>
                </div>
              </div>
            </div>
          </motion.div>
        )}
      </AnimatePresence>

      <div className="container mx-auto px-4 -mt-6 relative z-20">
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-8">
          {/* Movie Selection Sidebar */}
          <div className="lg:col-span-4 space-y-6">
            <div className="flex items-center justify-between">
              <h2 className="text-xl font-bold flex items-center gap-2">
                <Ticket className="w-5 h-5 text-primary" />
                Select Movie
              </h2>
              <span className="text-xs text-muted-foreground uppercase font-semibold">
                {moviesWithShowtimes?.length} Titles
              </span>
            </div>

            <div className="flex flex-col gap-3 max-h-[60vh] overflow-y-auto pr-2 custom-scrollbar">
              {moviesWithShowtimes?.map((movie) => (
                <motion.div
                  key={movie.movieId}
                  whileHover={{ x: 5 }}
                  whileTap={{ scale: 0.98 }}
                >
                  <Card
                    className={`cursor-pointer transition-all duration-300 border-none overflow-hidden ${
                      selectedMovieId === movie.movieId ||
                      (!selectedMovieId &&
                        moviesWithShowtimes?.[0]?.movieId === movie.movieId)
                        ? "bg-primary text-primary-foreground shadow-lg shadow-primary/20 ring-1 ring-primary"
                        : "bg-card hover:bg-accent"
                    }`}
                    onClick={() => setSelectedMovieId(movie.movieId)}
                  >
                    <CardContent className="p-3">
                      <div className="flex gap-4 items-center">
                        <div className="w-12 h-18 rounded-md overflow-hidden shrink-0">
                          <img
                            src={`https://image.tmdb.org/t/p/w200${movie.posterPath}`}
                            alt={movie.title}
                            className="w-full h-full object-cover"
                          />
                        </div>
                        <div className="flex flex-col overflow-hidden">
                          <h3 className="font-bold truncate text-sm">
                            {movie.title}
                          </h3>
                          <p
                            className={`text-xs ${
                              selectedMovieId === movie.movieId ||
                              (!selectedMovieId &&
                                moviesWithShowtimes?.[0]?.movieId ===
                                  movie.movieId)
                                ? "text-primary-foreground/80"
                                : "text-muted-foreground"
                            }`}
                          >
                            {movie.showtimes.length} sessions today
                          </p>
                        </div>
                      </div>
                    </CardContent>
                  </Card>
                </motion.div>
              ))}
            </div>
          </div>

          {/* Showtimes Display */}
          <div className="lg:col-span-8 space-y-8">
            <div className="bg-card rounded-3xl p-6 md:p-8 border border-white/5 shadow-xl">
              <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-8">
                <div className="space-y-1">
                  <h3 className="text-2xl font-bold">Available Sessions</h3>
                  <div className="flex items-center gap-2 text-muted-foreground text-sm">
                    <Calendar className="w-4 h-4" />
                    <span>{format(new Date(), "EEEE, MMMM do")}</span>
                  </div>
                </div>
                <div className="flex gap-2">
                  {hallNames.map((hall) => (
                    <Badge
                      key={hall}
                      variant="outline"
                      className="text-primary border-primary/30 uppercase tracking-[0.2em] px-3 py-1"
                    >
                      {hall}
                    </Badge>
                  ))}
                </div>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <AnimatePresence mode="popLayout">
                  {selectedMovie?.showtimes.map((showtime, index) => (
                    <motion.div
                      key={showtime.id}
                      initial={{ opacity: 0, y: 10 }}
                      animate={{ opacity: 1, y: 0 }}
                      transition={{ delay: index * 0.05 }}
                    >
                      <button className="w-full group">
                        <div className="flex items-center justify-between p-4 rounded-2xl bg-accent/50 group-hover:bg-primary transition-all duration-300 border border-white/5 group-hover:border-primary">
                          <div className="flex items-center gap-4">
                            <div className="bg-background group-hover:bg-white/20 p-3 rounded-xl transition-colors">
                              <Clock className="w-5 h-5 text-primary group-hover:text-white" />
                            </div>
                            <div className="text-left">
                              <p className="text-xl font-black group-hover:text-white">
                                {format(new Date(showtime.startTime), "p")}
                              </p>
                              <div className="flex items-center gap-2 mt-1">
                                <Badge
                                  variant="outline"
                                  className="text-[10px] text-primary border-primary/30 group-hover:text-white group-hover:border-white/30 uppercase tracking-widest px-2 py-0"
                                >
                                  {showtime.hallName}
                                </Badge>
                                <p className="text-xs text-muted-foreground group-hover:text-white/70">
                                  Starts at{" "}
                                  {format(new Date(showtime.startTime), "p")}
                                </p>
                              </div>
                            </div>
                          </div>
                          <div className="text-right">
                            <p className="text-lg font-bold group-hover:text-white">
                              {showtime.price} $
                            </p>
                            <span className="text-[10px] uppercase font-black tracking-widest text-primary group-hover:text-white/80">
                              Book Now
                            </span>
                          </div>
                        </div>
                      </button>
                    </motion.div>
                  )) || (
                    <div className="col-span-full py-12 text-center text-muted-foreground border-2 border-dashed rounded-3xl">
                      No more showtimes available for today.
                    </div>
                  )}
                </AnimatePresence>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Video Modal */}
      <AnimatePresence>
        {isVideoVisible && selectedMovie?.trailerKey && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="fixed inset-0 z-[100] bg-black/95 backdrop-blur-2xl flex items-center justify-center p-4 lg:p-20"
            onClick={() => setIsVideoVisible(false)}
          >
            <motion.div
              initial={{ scale: 0.9, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              exit={{ scale: 0.9, opacity: 0 }}
              className="relative w-full max-w-6xl aspect-video rounded-[2rem] overflow-hidden shadow-2xl border border-white/10"
              onClick={(e) => e.stopPropagation()}
            >
              <iframe
                className="w-full h-full"
                src={`https://www.youtube.com/embed/${selectedMovie?.trailerKey}?autoplay=1`}
                title="Movie Trailer"
                allow="autoplay; encrypted-media"
                frameBorder="0"
              />
              <Button
                onClick={() => setIsVideoVisible(false)}
                className="absolute top-10 right-6 w-12 h-12 rounded-full bg-white/10 hover:bg-white/20 border border-white/10 backdrop-blur-xl p-0 text-white"
              >
                ✕
              </Button>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
};

export default Showtimes;
