import { Route, Routes } from "react-router-dom";
import RootLayout from "./pages/layout/RootLayout";

const App = () => {
  return (
    <Routes>
      <Route element={<RootLayout />}>
        <Route index path="/" element={<h1>Home</h1>} />
        <Route path="movies" element={<h1>Movies</h1>} />
        <Route path="login" element={<h1>Login</h1>} />
        <Route path="register" element={<h1>Register</h1>} />
        <Route path="*" element={<h1>not found</h1>} />
      </Route>
    </Routes>
  );
};

export default App;
