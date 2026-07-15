import Navbar from "@/components/Navbar";
import Footer from "@/components/Footer";
import ScrollToTop from "@/components/ScrollToTop";
import { Outlet, useLocation } from "react-router-dom";
import { Toaster } from "sonner";

const AUTH_ROUTES = ["/login", "/register", "/forgot-password", "/reset-password"];

const RootLayout = () => {
  const { pathname } = useLocation();
  const showFooter = !AUTH_ROUTES.includes(pathname);

  return (
    <div className="min-h-screen bg-background text-foreground flex flex-col">
      <Toaster position="top-center" richColors />
      <Navbar />
      <main className="pt-16 flex-1">
        <ScrollToTop />
        <Outlet />
      </main>
      {showFooter && <Footer />}
    </div>
  );
};

export default RootLayout;
