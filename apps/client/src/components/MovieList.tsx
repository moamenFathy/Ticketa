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
    <Carousel
      opts={{ align: "start", slidesToScroll: "auto" }}
      className="w-full group"
    >
      <CarouselContent className="-ml-4">
        {movies.map((movie) => (
          <CarouselItem
            key={movie.id}
            className="pl-4 basis-1/2 md:basis-1/3 lg:basis-1/4 xl:basis-1/5"
          >
            <Card movie={movie} />
          </CarouselItem>
        ))}
      </CarouselContent>
      <div className="absolute inset-y-0 left-0 right-0 pointer-events-none flex justify-between z-20 group">
        <div className="h-full w-10 bg-gradient-to-r from-background/40 to-transparent opacity-0 group-hover:opacity-100 transition-all duration-500 flex items-center justify-start pl-2">
          <CarouselPrevious className="static pointer-events-auto h-24 w-14 rounded-2xl bg-black/60 hover:bg-primary border-none text-white transition-all opacity-0 group-hover:opacity-100 scale-90 hover:scale-100 shadow-2xl backdrop-blur-md [&_svg]:w-8 [&_svg]:h-8 [&_svg]:stroke-[3]" />
        </div>
        <div className="h-full w-10 bg-gradient-to-l from-background/40 to-transparent opacity-0 group-hover:opacity-100 transition-all duration-500 flex items-center justify-end pr-2">
          <CarouselNext className="static pointer-events-auto h-24 w-14 rounded-2xl bg-black/60 hover:bg-primary border-none text-white transition-all opacity-0 group-hover:opacity-100 scale-90 hover:scale-100 shadow-2xl backdrop-blur-md [&_svg]:w-8 [&_svg]:h-8 [&_svg]:stroke-[3]" />
        </div>
      </div>
    </Carousel>
  );
}

export default MovieList;
