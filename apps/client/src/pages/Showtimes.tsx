import { useGetShowtimes } from "@/hooks/useShowtimes";
import { Calendar, Ticket } from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";
import { useMemo, useState } from "react";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent } from "@/components/ui/card";
import { format, parseISO } from "date-fns";
import ErrorState from "@/components/ErrorState";
import HeroShowtimes from "@/components/HeroShowtimes";
import TrailerDialog from "@/components/TrailerDialog";
import ShowtimesCards from "@/components/ShowtimesCards";
import { Separator } from "@/components/ui/separator";
import ShowtimeSkeleton from "@/components/skeletons/ShowtimeSkeleton";

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

  const groupedShowtimes = useMemo(() => {
    if (!selectedMovie?.showtimes) return {};
    return selectedMovie.showtimes.reduce(
      (acc, showtime) => {
        const date = format(parseISO(showtime.startTime), "yyyy-MM-dd");
        if (!acc[date]) {
          acc[date] = [];
        }
        acc[date].push(showtime);
        return acc;
      },
      {} as Record<string, typeof selectedMovie.showtimes>,
    );
  }, [selectedMovie]);

  const hallNames = useMemo(
    () => [
      ...new Set(
        selectedMovie?.showtimes.map((showtime) => showtime.hallName) ?? [],
      ),
    ],
    [selectedMovie],
  );

  if (isLoading) {
    return <ShowtimeSkeleton />;
  }

  if (isError) {
    return <ErrorState refetch={refetch} />;
  }

  return (
    <div className="min-h-screen bg-background text-foreground pb-20">
      {/* Hero Section for Selected Movie */}
      <AnimatePresence mode="wait">
        {selectedMovie && (
          <HeroShowtimes
            selectedMovie={selectedMovie}
            setIsVideoVisible={setIsVideoVisible}
          />
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

              <div className="space-y-12">
                <AnimatePresence mode="popLayout">
                  {Object.entries(groupedShowtimes).length > 0 ? (
                    Object.entries(groupedShowtimes).map(
                      ([date, showtimes]) => (
                        <div key={date} className="space-y-6">
                          <div className="flex items-center gap-4">
                            <h4 className="text-lg font-semibold whitespace-nowrap">
                              {format(parseISO(date), "EEEE, MMMM do")}
                            </h4>
                            <Separator className="flex-1" />
                          </div>
                          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                            {showtimes.map((showtime, index) => (
                              <ShowtimesCards
                                key={showtime.id}
                                showtime={showtime}
                                index={index}
                              />
                            ))}
                          </div>
                        </div>
                      ),
                    )
                  ) : (
                    <div className="col-span-full py-12 text-center text-muted-foreground border-2 border-dashed rounded-3xl">
                      No more showtimes available.
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
          <TrailerDialog
            trailerKey={selectedMovie.trailerKey}
            setIsVideoVisible={setIsVideoVisible}
          />
        )}
      </AnimatePresence>
    </div>
  );
};

export default Showtimes;
