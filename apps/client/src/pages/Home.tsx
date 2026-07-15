import HeroSection from "@/components/HeroSection";
import MovieList from "@/components/MovieList";
import GenreMovieList from "@/components/GenreMovieList";
import { MovieListSkeleton } from "@/components/skeletons/MovieListSkeleton";
import { Button } from "@/components/ui/button";
import {
  useNowPlayingMovies,
  useComingSoonMovies,
  useMostPopularMovies,
} from "@/hooks/useMovies";
import { Link } from "react-router-dom";
import ErrorState from "@/components/ErrorState";
import HeroSectionSkeleton from "@/components/skeletons/HeroSectionSkeleton";
import { Separator } from "@/components/ui/separator";
import { useGoogleOneTapLogin } from "@react-oauth/google";
import { useAuth, useGoogleAuth } from "@/hooks/useAuth";

const Home = () => {
  const { isLoggedIn, isInitializing } = useAuth();
  const { mutate: googleAuth } = useGoogleAuth();

  useGoogleOneTapLogin({
    onSuccess: (credentialResponse) => {
      if (credentialResponse.credential) {
        googleAuth(credentialResponse.credential);
      }
    },
    onError: () => console.error("Google One Tap Login Failed"),
    disabled: isLoggedIn || isInitializing,
    cancel_on_tap_outside: false,
    use_fedcm_for_prompt: false,
  });

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

  const {
    data: heroMovies,
    isLoading: heroMoviesLoading,
    isError: heroMoviesError,
    refetch: refetchHeroMovies,
  } = useMostPopularMovies();

  if (nowPlayingLoading || comingSoonLoading || heroMoviesLoading)
    return (
      <>
        <HeroSectionSkeleton />
        <MovieListSkeleton />
      </>
    );
  if (
    (nowPlayingError || !nowPlaying) &&
    (comingSoonError || !comingSoon) &&
    (heroMoviesError || !heroMovies)
  )
    return (
      <ErrorState
        refetch={() => {
          refetchNowPlaying();
          refetchComingSoon();
          refetchHeroMovies();
        }}
      />
    );

  return (
    <>
      <HeroSection movies={heroMovies || []} />
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
        <div className="py-6 mx-auto">
          {nowPlaying && nowPlaying.length > 0 ? (
            <GenreMovieList movies={nowPlaying} />
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
        <div className="py-6 mx-auto">
          {comingSoon && comingSoon.length > 0 ? (
            <MovieList movies={comingSoon} comingSoon />
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
