import HeroSection from "@/components/HeroSection";
import MovieList from "@/components/MovieList";
import { Button } from "@/components/ui/button";
import { Link } from "react-router-dom";

const Home = () => {
  return (
    <>
      <HeroSection />
      <section>
        <div className="flex justify-between items-center px-6">
          <h1 className="text-2xl font-bold mb-4">Popular Movies</h1>
          <Link to="/movies" className="">
            <Button variant="ghost">See All</Button>
          </Link>
        </div>
        <div className="p-6 mx-auto">
          <MovieList />
        </div>
      </section>
    </>
  );
};

export default Home;
