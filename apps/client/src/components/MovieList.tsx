import {
  Carousel,
  CarouselContent,
  CarouselItem,
  CarouselNext,
  CarouselPrevious,
} from "@/components/ui/carousel";
import type { Movie } from "@/types/movie";
import { Link } from "react-router-dom";
import MovieCard from "./MovieCard";
import ComingSoonCard from "./ComingSoonCard";

interface MovieListProps {
  movies: Movie[];
  comingSoon?: boolean;
}

export function MovieList({ movies, comingSoon }: MovieListProps) {
  return (
    <div className="relative group/main">
      <Carousel
        opts={{ align: "start", slidesToScroll: "auto", dragFree: true }}
        className="w-full px-4 sm:px-12"
      >
        <CarouselContent className="-ml-4">
          {movies.map((movie) => (
            <CarouselItem
              key={movie.id}
              className="pl-4 basis-[60%] sm:basis-1/2 md:basis-1/3 lg:basis-1/4 xl:basis-1/5 shrink-0"
            >
              <Link to={`/movies/${movie.id}`} className="block w-full h-full">
                {comingSoon ? (
                  <ComingSoonCard movie={movie} />
                ) : (
                  <MovieCard movie={movie} />
                )}
              </Link>
            </CarouselItem>
          ))}
        </CarouselContent>

        <CarouselPrevious
          variant="ghost"
          className="hidden sm:flex absolute left-0 top-0 bottom-0 h-full w-12 rounded-none bg-background/50 hover:bg-background/80 border-none text-foreground transition-all duration-300 opacity-30 hover:opacity-100 hover:text-primary disabled:hidden z-30 translate-x-0 translate-y-0! [&_svg]:w-8 [&_svg]:h-8 [&_svg]:stroke-3"
        />
        <CarouselNext
          variant="ghost"
          className="hidden sm:flex absolute right-0 top-0 bottom-0 h-full w-12 rounded-none bg-background/50 hover:bg-background/80 border-none text-foreground transition-all duration-300 opacity-30 hover:opacity-100 hover:text-primary disabled:hidden z-30 translate-x-0 translate-y-0! [&_svg]:w-8 [&_svg]:h-8 [&_svg]:stroke-3"
        />
      </Carousel>
    </div>
  );
}

export default MovieList;
