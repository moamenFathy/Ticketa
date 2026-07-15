import { Route, Routes } from "react-router-dom";
import { ErrorBoundary } from "./components/ErrorBoundary";
import RootLayout from "./pages/layout/RootLayout";
import Home from "./pages/Home";
import MovieDetails from "./pages/MovieDetails";
import Showtimes from "./pages/Showtimes";
import ShowtimeSeats from "./pages/ShowtimeSeats";
import Checkout from "./pages/Checkout";
import Login from "./pages/Login";
import Register from "./pages/Register";
import Scan from "./pages/Scan";
import Profile from "./pages/Profile";
import ForgetPassword from "./pages/ForgetPassword";
import ResetPassword from "./pages/ResetPassword";
import Movies from "./pages/Movies";
import NotFound from "./pages/NotFound";

const App = () => {
  return (
    <ErrorBoundary>
      <Routes>
        <Route element={<RootLayout />}>
        <Route index path="/" element={<Home />} />
        <Route path="movies" element={<Movies />} />
        <Route path="showtimes" element={<Showtimes />} />
        <Route path="showtimes/:id" element={<ShowtimeSeats />} />
        <Route path="checkout" element={<Checkout />} />
        <Route path="movies/:id" element={<MovieDetails />} />
        <Route path="login" element={<Login />} />
        <Route path="forgot-password" element={<ForgetPassword />} />
        <Route path="reset-password" element={<ResetPassword />} />
        <Route path="register" element={<Register />} />
        <Route path="profile" element={<Profile />} />
        <Route path="bookings/:reference" element={<Scan />} />
        <Route path="*" element={<NotFound />} />
      </Route>
    </Routes>
    </ErrorBoundary>
  );
};

export default App;
