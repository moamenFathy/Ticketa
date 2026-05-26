import { Route, Routes } from "react-router-dom";
import RootLayout from "./pages/layout/RootLayout";
import Home from "./pages/Home";
import MovieDetails from "./pages/MovieDetails";
import Showtimes from "./pages/Showtimes";
import ShowtimeSeats from "./pages/ShowtimeSeats";
import Login from "./pages/Login";
import Register from "./pages/Register";
import Scan from "./pages/Scan";

const App = () => {
  return (
    <Routes>
      <Route element={<RootLayout />}>
        <Route index path="/" element={<Home />} />
        <Route path="movies" element={<h1>Movies</h1>} />
        <Route path="showtimes" element={<Showtimes />} />
        <Route path="showtimes/:id" element={<ShowtimeSeats />} />
        <Route path="movies/:id" element={<MovieDetails />} />
        <Route path="login" element={<Login />} />
        <Route path="register" element={<Register />} />
        <Route path="bookings/:reference" element={<Scan />} />
        <Route path="*" element={<h1>not found</h1>} />
      </Route>
    </Routes>
  );
};

export default App;
