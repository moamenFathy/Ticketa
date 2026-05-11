import { 
  Star, 
  ArrowLeft, 
  Ticket,
  AlertCircle,
  RefreshCw,
  User,
  Info,
  Globe,
  Clock,
  Calendar,
  Clapperboard
} from "lucide-react";
import { motion, useScroll, useTransform, AnimatePresence } from "framer-motion";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { 
  Carousel, 
  CarouselContent, 
  CarouselItem,
  CarouselNext,
  CarouselPrevious
} from "@/components/ui/carousel";
import { Skeleton } from "@/components/ui/skeleton";
import { useRef, useMemo } from "react";
import { useMovieDetails } from "@/hooks/useMovies";
import { useNavigate, useParams } from "react-router-dom";

// ─── Constants & Helpers ───────────────────────────────────────────────────
const TMDB_IMG = "https://image.tmdb.org/t/p";

const GENRE_COLORS: Record<string, string> = {
  Action: "#ef4444",
  Adventure: "#f59e0b",
  Animation: "#ec4899",
  Comedy: "#facc15",
  Crime: "#4b5563",
  Documentary: "#10b981",
  Drama: "#3b82f6",
  Family: "#8b5cf6",
  Fantasy: "#d946ef",
  History: "#92400e",
  Horror: "#7f1d1d",
  Music: "#06b6d4",
  Mystery: "#6366f1",
  Romance: "#f43f5e",
  "Science Fiction": "#8b5cf6",
  "TV Movie": "#64748b",
  Thriller: "#1f2937",
  War: "#451a03",
  Western: "#b45309",
};

function formatRuntime(minutes: number): string {
  const h = Math.floor(minutes / 60);
  const m = minutes % 60;
  return `${h}h ${m}m`;
}

const MovieDetailsPage = () => {
  const { id } = useParams();
  const navigate = useNavigate();
  const { data: movie, isLoading, isError, refetch } = useMovieDetails(id!);
  
  const containerRef = useRef<HTMLDivElement>(null);
  const { scrollYProgress } = useScroll({
    target: containerRef,
    offset: ["start start", "end start"]
  });

  // Parallax & Motion effects
  const titleY = useTransform(scrollYProgress, [0, 0.3], [0, -100]);
  const titleOpacity = useTransform(scrollYProgress, [0, 0.2], [1, 0]);
  const backdropScale = useTransform(scrollYProgress, [0, 0.5], [1, 1.2]);
  const backdropBlur = useTransform(scrollYProgress, [0, 0.5], [0, 10]);
  const liquidPath = useTransform(scrollYProgress, [0, 0.5], 
    ["M 0,1 C 0.3,0.8 0.7,0.8 1,1 V 0 H 0 Z", "M 0,1 C 0.4,0.7 0.6,0.7 1,1 V 0 H 0 Z"]
  );

  const genreColor = useMemo(() => {
    if (!movie?.genres?.length) return "#3b82f6";
    return GENRE_COLORS[movie.genres[0].name] || "#3b82f6";
  }, [movie]);

  if (isLoading) return <MovieDetailsSkeleton />;
  if (isError || !movie) return <ErrorState refetch={refetch} />;

  return (
    <div 
      ref={containerRef} 
      className="min-h-screen bg-[#080a0f] text-[#e8e4dd] overflow-x-hidden selection:bg-primary selection:text-white pb-32"
      style={{
        backgroundImage: `radial-gradient(circle at 50% -10%, ${genreColor}22, transparent 60%)`
      }}
    >
      {/* 1. Liquid Media Header Stage */}
      <section 
        className="relative h-[85vh] w-full overflow-hidden"
        style={{ clipPath: 'url(#liquid-clip)' }}
      >
        <motion.div 
          style={{ scale: backdropScale, filter: `blur(${backdropBlur}px)` }}
          className="absolute inset-0 w-full h-full"
        >
          {movie.trailerKey ? (
            <div className="absolute inset-0 w-full h-full scale-110">
              <iframe
                className="w-full h-full pointer-events-none object-cover brightness-75 grayscale-[0.2]"
                src={`https://www.youtube.com/embed/${movie.trailerKey}?autoplay=1&mute=1&loop=1&playlist=${movie.trailerKey}&controls=0&showinfo=0&rel=0&modestbranding=1&iv_load_policy=3&disablekb=1`}
                title="Movie Trailer"
                allow="autoplay; encrypted-media"
                frameBorder="0"
              />
            </div>
          ) : (
            <img 
              src={`${TMDB_IMG}/original${movie.backdropPath}`} 
              alt={movie.title}
              className="w-full h-full object-cover opacity-60"
            />
          )}
          
          <div className="absolute inset-0 bg-gradient-to-t from-[#080a0f] via-transparent to-black/40" />
          <div className="absolute inset-0 bg-gradient-to-b from-black/60 via-transparent to-transparent" />
        </motion.div>

        <svg className="absolute bottom-0 w-full h-[150px]" viewBox="0 0 1 1" preserveAspectRatio="none">
          <motion.path 
            d={liquidPath}
            fill="black" 
            clipPath="url(#liquid-clip)"
          />
        </svg>

        {/* Back Navigation */}
        <div className="absolute top-10 left-10 z-50">
          <motion.div whileHover={{ scale: 1.05, x: -5 }} whileTap={{ scale: 0.95 }}>
            <Button 
                variant="ghost"
                onClick={() => navigate(-1)}
                className="flex items-center gap-3 px-6 py-6 rounded-full bg-white/5 border border-white/10 backdrop-blur-xl text-sm font-medium tracking-widest uppercase hover:bg-white/10 transition-all text-white"
            >
                <ArrowLeft className="w-4 h-4" />
                Back
            </Button>
          </motion.div>
        </div>

        {/* Floating Title Layer */}
        <div className="absolute inset-0 flex flex-col items-center justify-center z-20 pointer-events-none px-6">
          <motion.div style={{ y: titleY, opacity: titleOpacity }} className="text-center">
            <motion.span 
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              className="text-primary font-black uppercase tracking-[0.6em] text-[10px] mb-4 block"
            >
              Cinematic Experience
            </motion.span>
            <h1 className="text-7xl md:text-9xl font-black tracking-tighter leading-none text-transparent bg-clip-text bg-gradient-to-b from-white to-white/20 drop-shadow-2xl italic italic-outline">
              {movie.title}
            </h1>
          </motion.div>
        </div>

        {/* Rating Floating Orb */}
        <motion.div 
          initial={{ opacity: 0, scale: 0.5 }}
          animate={{ opacity: 1, scale: 1 }}
          className="absolute bottom-20 right-10 lg:right-20 z-30"
        >
          <div className="relative group">
            <div className="absolute inset-0 bg-primary/40 blur-3xl rounded-full group-hover:bg-primary/60 transition-colors" />
            <div className="relative bg-black/40 backdrop-blur-3xl border border-white/10 p-8 rounded-[3rem] flex flex-col items-center gap-1 shadow-2xl">
              <Star className="w-8 h-8 fill-yellow-500 text-yellow-500 mb-1" />
              <span className="text-4xl font-black leading-none">{movie.voteAverage.toFixed(1)}</span>
              <span className="text-[9px] uppercase font-bold text-white/40 tracking-[0.2em]">IMDB Rating</span>
            </div>
          </div>
        </motion.div>
      </section>

      {/* 2. Content & Information Section */}
      <div className="relative z-20 -mt-20 px-6 lg:px-20">
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-16 items-start">
          
          {/* Holographic Poster Stage */}
          <div className="lg:col-span-4 relative group">
            <motion.div 
              whileHover={{ rotateY: -15, rotateX: 10, translateZ: 50 }}
              className="relative aspect-2/3 rounded-[3rem] overflow-hidden shadow-[0_50px_100px_-20px_rgba(0,0,0,0.8)] border border-white/10 preserve-3d cursor-pointer"
            >
              <img 
                src={`${TMDB_IMG}/w780${movie.posterPath}`} 
                alt={movie.title}
                className="w-full h-full object-cover"
              />
              <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity flex items-end p-10">
                 <Button className="w-full h-14 rounded-2xl bg-primary text-white font-black uppercase tracking-widest gap-3 shadow-xl shadow-primary/40 hover:bg-primary/90">
                    <Ticket className="w-5 h-5" />
                    Book Now
                 </Button>
              </div>
            </motion.div>

            {/* Floating Metadata Cards */}
            <div className="mt-12 flex gap-4 justify-center">
              {[
                { icon: Clock, value: formatRuntime(movie.runtime), label: "Duration" },
                { icon: Calendar, value: new Date(movie.releaseDate).getFullYear(), label: "Year" },
                { icon: Globe, value: movie.language.toUpperCase(), label: "Audio" }
              ].map((item, i) => (
                <motion.div 
                  key={i}
                  initial={{ opacity: 0, y: 20 }}
                  whileInView={{ opacity: 1, y: 0 }}
                  transition={{ delay: i * 0.1 }}
                  whileHover={{ y: -10, backgroundColor: "rgba(255,255,255,0.1)" }}
                  className="bg-white/5 backdrop-blur-2xl border border-white/10 p-5 rounded-[2rem] text-center min-w-[100px] cursor-default transition-colors"
                >
                  <item.icon className="w-5 h-5 text-primary mx-auto mb-2" />
                  <p className="text-[10px] uppercase font-bold text-white/30 tracking-widest mb-1">{item.label}</p>
                  <p className="font-bold text-lg">{item.value}</p>
                </motion.div>
              ))}
            </div>
          </div>

          {/* Storyline & Actions */}
          <div className="lg:col-span-8 space-y-20 lg:pt-20">
             <div className="flex flex-wrap gap-3">
                {movie.genres.map((genre) => (
                  <Badge 
                    key={genre.id} 
                    variant="outline"
                    className="bg-transparent border-white/10 hover:border-primary/50 hover:bg-primary/5 text-white/70 px-6 py-2 rounded-full text-[11px] font-bold uppercase tracking-widest transition-all"
                  >
                    {genre.name}
                  </Badge>
                ))}
             </div>

             <div className="relative">
                <div className="absolute -left-10 top-0 w-1 h-20 bg-primary shadow-[0_0_20px_rgba(234,88,12,0.5)]" />
                <div className="space-y-6">
                  <h3 className="text-[12px] font-black uppercase tracking-[0.5em] text-primary flex items-center gap-3">
                    <Info className="w-4 h-4" />
                    The Narrative
                  </h3>
                  <motion.p 
                    initial={{ opacity: 0 }}
                    whileInView={{ opacity: 1 }}
                    transition={{ duration: 1 }}
                    className="text-3xl md:text-5xl font-medium tracking-tight leading-[1.3] text-white/90"
                  >
                    {movie.overview}
                  </motion.p>
                </div>
             </div>

             {/* Dynamic Call-to-Action Stage */}
             <div className="relative p-1 bg-gradient-to-r from-primary/50 to-transparent rounded-[3.5rem] shadow-2xl">
                <div className="bg-[#080a0f] rounded-[3.4rem] p-10 flex flex-col md:flex-row items-center justify-between gap-10">
                   <div className="space-y-2 text-center md:text-left">
                      <p className="text-white/40 font-bold uppercase tracking-widest text-xs italic">Now playing in premium theaters</p>
                      <h4 className="text-3xl font-black tracking-tight italic italic-outline text-white/90">Reserve your seat today</h4>
                   </div>
                   <Button 
                      size="lg" 
                      className="h-20 px-16 rounded-[2.5rem] font-black text-2xl gap-4 bg-primary hover:bg-primary/90 transition-all hover:scale-[1.05] active:scale-95 border-b-[6px] border-orange-800 text-white"
                      style={{
                        boxShadow: `0 20px 60px -10px ${genreColor}66` // 66 for ~40% opacity in hex
                      }}
                    >
                       <Ticket className="w-7 h-7" />
                       Book Tickets
                   </Button>
                </div>
             </div>
          </div>
        </div>

        {/* 3. The Orbital Ensemble Section */}
        <section className="mt-60 space-y-20">
          <div className="text-center space-y-4">
             <h2 className="text-6xl md:text-8xl font-black tracking-tighter italic italic-outline text-white/10">The Ensemble</h2>
             <p className="text-primary font-bold uppercase tracking-[0.6em] text-[11px]">Featuring Stellar Performance</p>
          </div>

          <div className="relative">
             <div className="absolute inset-0 bg-radial-gradient from-primary/5 via-transparent to-transparent pointer-events-none" />
             
             <Carousel opts={{ align: "center", dragFree: true }} className="w-full">
                <CarouselContent className="-ml-10">
                  {movie.cast.map((person, index) => (
                    <CarouselItem key={person.name + index} className="pl-10 basis-full sm:basis-1/2 md:basis-1/3 lg:basis-1/4 xl:basis-1/5 group">
                      <motion.div 
                        initial={{ opacity: 0, scale: 0.8, rotateY: 20 }}
                        whileInView={{ opacity: 1, scale: 1, rotateY: 0 }}
                        viewport={{ once: true }}
                        transition={{ delay: index * 0.05 }}
                        className="relative h-[600px] rounded-[4rem] overflow-hidden border border-white/5 bg-[#121212] group-hover:border-primary/30 transition-all duration-700 shadow-2xl"
                      >
                        {person.profile_path ? (
                          <img 
                            src={`${TMDB_IMG}/w500${person.profile_path}`} 
                            alt={person.name}
                            className="w-full h-full object-cover grayscale group-hover:grayscale-0 transition-all duration-1000 group-hover:scale-110"
                          />
                        ) : (
                          <div className="w-full h-full flex items-center justify-center bg-white/5">
                            <User className="w-24 h-24 text-white/10" />
                          </div>
                        )}
                        
                        <div className="absolute inset-0 bg-gradient-to-t from-black via-transparent to-transparent flex flex-col justify-end p-12 translate-y-10 group-hover:translate-y-0 transition-transform duration-500">
                          <h4 className="text-3xl font-black text-white leading-tight mb-2">{person.name}</h4>
                          <div className="h-1 w-12 bg-primary mb-4 group-hover:w-full transition-all duration-700" />
                          <p className="text-primary font-black uppercase text-[10px] tracking-[0.3em]">{person.character}</p>
                        </div>
                      </motion.div>
                    </CarouselItem>
                  ))}
                </CarouselContent>
                <CarouselPrevious className="hidden md:flex -left-12 bg-black/50 border-white/10 text-white w-14 h-14 hover:bg-black/70 transition-colors" />
                <CarouselNext className="hidden md:flex -right-12 bg-black/50 border-white/10 text-white w-14 h-14 hover:bg-black/70 transition-colors" />
             </Carousel>
          </div>
        </section>
      </div>

      <style>{`
        .italic-outline {
          -webkit-text-stroke: 1px rgba(255,255,255,0.1);
        }
        .preserve-3d {
          transform-style: preserve-3d;
        }
      `}</style>
    </div>
  );
};

const MovieDetailsSkeleton = () => (
  <div className="min-h-screen bg-[#080a0f] p-20 space-y-20">
    <Skeleton className="h-[70vh] w-full rounded-[4rem]" />
    <div className="grid grid-cols-1 lg:grid-cols-12 gap-16">
      <Skeleton className="lg:col-span-4 aspect-2/3 rounded-[3rem]" />
      <div className="lg:col-span-8 space-y-10">
        <Skeleton className="h-20 w-3/4 rounded-2xl" />
        <Skeleton className="h-40 w-full rounded-2xl" />
        <Skeleton className="h-20 w-full rounded-full" />
      </div>
    </div>
  </div>
);

const ErrorState = ({ refetch }: { refetch: () => void }) => (
  <div className="flex flex-col items-center justify-center min-h-screen p-6 text-center bg-[#080a0f] text-white">
    <div className="bg-red-500/10 p-8 rounded-full mb-8 shadow-2xl shadow-red-500/20">
      <Clapperboard className="w-16 h-16 text-red-500" />
    </div>
    <h2 className="text-4xl font-black tracking-tight mb-4 italic">Film Reel Interrupted</h2>
    <p className="text-white/40 max-w-md mb-10 font-medium text-lg leading-relaxed">
      We couldn't retrieve the cinematic data for this title. Check your connection to the projector.
    </p>
    <Button onClick={() => refetch()} className="gap-3 h-14 px-10 rounded-2xl font-black text-lg bg-primary hover:bg-primary/90 shadow-lg shadow-primary/20 text-white">
      <RefreshCw className="w-5 h-5" />
      Retry Projection
    </Button>
  </div>
);

export default MovieDetailsPage;


export default MovieDetailsPage;


export default MovieDetailsPage;
