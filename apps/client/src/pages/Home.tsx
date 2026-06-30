import HeroSection from "@/components/HeroSection";
import MovieList from "@/components/MovieList";
import ComingSoonList from "@/components/ComingSoonList";
import { MovieListSkeleton } from "@/components/skeletons/MovieListSkeleton";
import { Button } from "@/components/ui/button";
import { useNowPlayingMovies, useComingSoonMovies } from "@/hooks/useMovies";
import { Link } from "react-router-dom";
import ErrorState from "@/components/ErrorState";
import HeroSectionSkeleton from "@/components/skeletons/HeroSectionSkeleton";
import { Separator } from "@/components/ui/separator";

const Home = () => {
  const {
    data: nowPlaying,
    isLoading: nowPlayingLoading,
    isError: nowPlayingError,
    refetch: refetchNowPlaying,
  } = useNowPlayingMovies();
  const {
    data: comingSoon,
    isLoading: comingSoonLoading,
    isError: comingSoonError,
    refetch: refetchComingSoon,
  } = useComingSoonMovies();

  if (nowPlayingLoading || comingSoonLoading)
    return (
      <>
        <HeroSectionSkeleton />
        <MovieListSkeleton />
      </>
    );
  if ((nowPlayingError || !nowPlaying) && (comingSoonError || !comingSoon))
    return (
      <ErrorState
        refetch={() => {
          refetchNowPlaying();
          refetchComingSoon();
        }}
      />
    );

  const heroMovies = nowPlaying?.slice(0, 6) || [];

  return (
    <>
      <HeroSection movies={heroMovies} />
      <section className="pt-12">
        <div className="flex justify-between items-center px-6">
          <h1 className="text-2xl font-bold">Now showing</h1>
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
          {nowPlaying && nowPlaying.length > 0 ? (
            <MovieList movies={nowPlaying} />
          ) : (
            <p className="text-muted-foreground text-center py-12">
              No upcoming movies yet. Check back later!
            </p>
          )}
        </div>
      </section>
      <Separator className="max-w-[95%] mx-auto" />
      <section className="pt-12">
        <div className="flex justify-between items-center px-6">
          <h1 className="text-2xl font-bold">Coming Soon</h1>
        </div>
        <div className="p-6 mx-auto">
          {comingSoon && comingSoon.length > 0 ? (
            <ComingSoonList movies={comingSoon} />
          ) : (
            <p className="text-muted-foreground text-center py-12">
              No upcoming movies yet. Check back later!
            </p>
          )}
        </div>
      </section>
    </>
  );
};

export default Home;
