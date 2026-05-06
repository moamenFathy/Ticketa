import {
  Carousel,
  CarouselContent,
  CarouselItem,
  CarouselNext,
  CarouselPrevious,
} from "@/components/ui/carousel";

export function MovieList() {
  return (
    <Carousel className="w-lg">
      <CarouselContent>
        {Array.from({ length: 20 }).map((_, index) => (
          <CarouselItem key={index} className="basis-1/2">
            <div className="p-1">
              <span>{index + 1}</span>
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
