import {
  Carousel,
  CarouselContent,
  CarouselItem,
  CarouselNext,
  CarouselPrevious,
} from "@/components/ui/carousel";
import type { Movie } from "@/types/movie";
import Card from "./Card";

interface MovieListProps {
  movies: Movie[];
}

export function MovieList({ movies }: MovieListProps) {
  return (
    <div className="relative group/main">
      <Carousel
        opts={{ align: "start", slidesToScroll: "auto" }}
        className="w-full px-12"
      >
        <CarouselContent className="-ml-4">
          {movies.map((movie) => (
            <CarouselItem
              key={movie.id}
              className="pl-4 basis-full sm:basis-1/2 md:basis-1/3 lg:basis-1/4 xl:basis-1/5 shrink-0"
            >
              <Card movie={movie} />
            </CarouselItem>
          ))}
        </CarouselContent>

        <CarouselPrevious 
          variant="ghost" 
          className="absolute left-0 top-0 bottom-0 h-full w-12 rounded-none bg-background/50 hover:bg-background/80 border-none text-foreground transition-all duration-300 opacity-30 hover:opacity-100 hover:text-primary disabled:hidden z-30 translate-x-0 !translate-y-0 [&_svg]:w-8 [&_svg]:h-8 [&_svg]:stroke-[3]" 
        />
        <CarouselNext 
          variant="ghost" 
          className="absolute right-0 top-0 bottom-0 h-full w-12 rounded-none bg-background/50 hover:bg-background/80 border-none text-foreground transition-all duration-300 opacity-30 hover:opacity-100 hover:text-primary disabled:hidden z-30 translate-x-0 !translate-y-0 [&_svg]:w-8 [&_svg]:h-8 [&_svg]:stroke-[3]" 
        />
      </Carousel>
    </div>
  );
}

export default MovieList;
