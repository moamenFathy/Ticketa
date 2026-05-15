import Navbar from "@/components/Navbar";
import ScrollToTop from "@/components/ScrollToTop";
import { Outlet } from "react-router-dom";

const RootLayout = () => {
  return (
    <div className="min-h-screen bg-background text-foreground">
      <Navbar />
      <main className="pt-16">
        <ScrollToTop />
        <Outlet />
      </main>
    </div>
  );
};

export default RootLayout;
