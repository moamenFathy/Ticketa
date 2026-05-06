import {
  Carousel,
  CarouselContent,
  CarouselItem,
  CarouselNext,
  CarouselPrevious,
} from "@/components/ui/carousel";
import type { Movie } from "@/types/movie";

interface MovieListProps {
  movies: Movie[];
}

export function MovieList({ movies }: MovieListProps) {
  return (
    <Carousel className="w-full">
      <CarouselContent>
        {movies.map((movie) => (
          <CarouselItem key={movie.id} className="basis-1/5">
            <div className="p-1">
              <span>{movie.title}</span>
            </div>
          </CarouselItem>
        ))}
      </CarouselContent>
      <div className="flex items-center gap-2 mt-6">
        <CarouselPrevious className="static translate-y-0" />
        <CarouselNext className="static translate-y-0" />
      </div>
    </Carousel>
  );
}

export default MovieList;
