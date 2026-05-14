import HeroSection from "@/components/HeroSection";
import MovieList from "@/components/MovieList";
import { MovieListSkeleton } from "@/components/MovieListSkeleton";
import { Button } from "@/components/ui/button";
import { useNowPlayingMovies } from "@/hooks/useMovies";
import { Link } from "react-router-dom";
import ErrorState from "@/components/ErrorState";

const Home = () => {
  const { data: movies, isLoading, isError, refetch } = useNowPlayingMovies();

  if (isError) {
    return <ErrorState refetch={refetch} />;
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
