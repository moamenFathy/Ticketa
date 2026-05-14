import { useGetShowtimes } from "@/hooks/useShowtimes";

const Showtimes = () => {
  const { data: showtimes } = useGetShowtimes();
  return (
    <div>
      {showtimes?.map((showtime) => (
        <div key={showtime.movieId}>{showtime.title}</div>
      ))}
    </div>
  );
};

export default Showtimes;
