import { Link, NavLink } from "react-router-dom";
import { Calendar, Home, Moon, Sun } from "lucide-react";
import { useState, useEffect } from "react";
import { Button } from "@/components/ui/button";
import { useAuth, useGoogleAuth, useLogout } from "@/hooks/useAuth";
import UserDropdown from "./UserDropdown";
import MobileMenu from "./MobileMenu";
import logo from "../assets/final_logo.svg";
import { useGoogleOneTapLogin } from "@react-oauth/google";

const navLinks = [
  { to: "/", label: "Home", icon: Home },
  { to: "/showtimes", label: "Showtimes", icon: Calendar },
];

export default function Navbar() {
  const [isOpen, setIsOpen] = useState(false);
  const [dark, setDark] = useState(
    () => localStorage.getItem("theme") === "dark",
  );
  const { user, isLoggedIn } = useAuth();
  const logoutMutation = useLogout();
  const { mutate: googleAuth } = useGoogleAuth();

  useGoogleOneTapLogin({
    onSuccess: (credentialResponse) => {
      if (credentialResponse.credential) {
        googleAuth(credentialResponse.credential);
      }
    },
    onError: () => {
      console.error("Google One Tap Login Failed");
    },
    disabled: isLoggedIn,
    cancel_on_tap_outside: false,
    use_fedcm_for_prompt: false, // Disable FedCM to fix NetworkError across different accounts
  });

  useEffect(() => {
    document.documentElement.classList.toggle("dark", dark);
    localStorage.setItem("theme", dark ? "dark" : "light");
  }, [dark]);

  const handleLogout = () => {
    logoutMutation.mutate();
    setIsOpen(false);
  };

  return (
    <header
      className="fixed top-0 left-0 right-0 z-50 h-16 border-b border-border bg-background/80 backdrop-blur-md"
      style={{ zIndex: 100 }}
    >
      <div className="mx-auto flex h-full max-w-7xl items-center justify-between px-6">
        <div className="flex items-center gap-8">
          {/* Logo */}
          <Link
            to="/"
            className="flex items-center gap-2 font-bold text-xl hover:opacity-80 transition-opacity"
          >
            <img
              src={logo}
              alt="Ticketa"
              className="h-10 w-10 object-contain"
            />
            <span className="font-black tracking-tighter uppercase hover:text-primary transition-colors">
              ticke<span className="text-primary">ta</span>
            </span>
          </Link>

          {/* Nav links - Desktop */}
          <nav className="hidden md:flex items-center gap-1.5 text-sm">
            {navLinks.map((link) => (
              <NavLink
                key={link.to}
                to={link.to}
                className={({ isActive }) =>
                  `relative px-4 py-1.5 rounded-full font-bold transition-all duration-300 overflow-hidden group
                  ${
                    isActive
                      ? "text-primary bg-primary/10 shadow-[0_0_20px_rgba(201,169,110,0.1)] ring-1 ring-primary/25"
                      : "text-zinc-500 hover:text-zinc-200 hover:bg-zinc-800/40"
                  }`
                }
              >
                <span className="relative z-10">{link.label}</span>
                {/* Subtle shine effect for active state */}
                <div className="absolute inset-0 bg-linear-to-r from-transparent via-white/5 to-transparent -translate-x-full group-hover:animate-[shimmer_1.5s_infinite] pointer-events-none" />
              </NavLink>
            ))}
          </nav>
        </div>

        {/* Right side */}
        <div className="flex items-center gap-3">
          <button
            onClick={() => setDark(!dark)}
            className="p-2 rounded-full text-muted-foreground hover:text-foreground hover:bg-accent transition-all duration-300"
            aria-label="Toggle theme"
          >
            {dark ? (
              <Sun size={20} className="rotate-0 scale-100 transition-all" />
            ) : (
              <Moon size={20} className="rotate-0 scale-100 transition-all" />
            )}
          </button>

          <div className="hidden md:flex items-center gap-3">
            {isLoggedIn && user ? (
              <UserDropdown
                name={user.name}
                email={user.email}
                handleLogout={handleLogout}
              />
            ) : (
              <>
                <Link to="/login">
                  <Button
                    variant="ghost"
                    size="sm"
                    className="font-semibold text-muted-foreground"
                  >
                    Login
                  </Button>
                </Link>
                <Link to="/register">
                  <Button
                    size="sm"
                    className="font-semibold rounded-full px-6 shadow-lg shadow-primary/20"
                  >
                    Register
                  </Button>
                </Link>
              </>
            )}
          </div>

          {/* Mobile Menu */}
          <MobileMenu
            isLoggedIn={isLoggedIn}
            name={user?.name}
            email={user?.email}
            navLinks={navLinks}
            isOpen={isOpen}
            setIsOpen={setIsOpen}
            handleLogout={handleLogout}
          />
        </div>
      </div>
    </header>
  );
}
