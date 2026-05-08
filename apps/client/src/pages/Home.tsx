import HeroSection from "@/components/HeroSection";
import MovieList from "@/components/MovieList";
import { MovieListSkeleton } from "@/components/MovieListSkeleton";
import { Button } from "@/components/ui/button";
import { useNowPlayingMovies } from "@/hooks/useMovies";
import { Link } from "react-router-dom";
import { AlertCircle, RefreshCw } from "lucide-react";

const Home = () => {
  const { data: movies, isLoading, isError, refetch } = useNowPlayingMovies();

  if (isError) {
    return (
      <div className="flex flex-col items-center justify-center min-h-100 p-6 text-center">
        <div className="bg-destructive/10 p-4 rounded-full mb-4">
          <AlertCircle className="w-10 h-10 text-destructive" />
        </div>
        <h2 className="text-2xl font-bold tracking-tight mb-2">
          Something went wrong
        </h2>
        <p className="text-muted-foreground max-w-100 mb-6">
          We couldn't load the movies. Please check your internet connection and
          try again.
        </p>
        <Button onClick={() => refetch()} className="gap-2">
          <RefreshCw className="w-4 h-4" />
          Try Again
        </Button>
      </div>
    );
  }

  return (
    <>
      <HeroSection movies={movies?.slice(0, 6) || []} />
      <section className="pt-12">
        <div className="flex justify-between items-center px-6">
          <h1 className="text-2xl font-bold">Popular Movies</h1>
          <Link to="/movies">
            <Button
              variant="ghost"
              className="text-muted-foreground hover:text-foreground"
            >
              See All
            </Button>
          </Link>
        </div>
        <div className="p-6 mx-auto">
          {isLoading ? (
            <MovieListSkeleton />
          ) : (
            <MovieList movies={movies || []} />
          )}
        </div>
      </section>
    </>
  );
};

export default Home;
