import { Link, NavLink } from "react-router-dom";
import { Moon, Sun, Ticket } from "lucide-react";
import { useState, useEffect } from "react";
import { Button } from "@/components/ui/button";

export default function Navbar() {
  const [dark, setDark] = useState(
    () => localStorage.getItem("theme") === "dark",
  );

  useEffect(() => {
    document.documentElement.classList.toggle("dark", dark);
    localStorage.setItem("theme", dark ? "dark" : "light");
  }, [dark]);

  return (
    <header className="fixed top-0 left-0 right-0 z-50 h-16 border-b border-border bg-background/80 backdrop-blur-md">
      <div className="mx-auto flex h-full max-w-7xl items-center justify-between px-6">
        {/* Logo */}
        <Link to="/" className="flex items-center gap-2 font-bold text-xl">
          <Ticket size={28} className="text-primary" />
          <span>
            ticke<span className="text-primary">ta</span>
          </span>
        </Link>

        {/* Nav links */}
        <nav className="flex items-center gap-6 text-sm font-medium">
          <NavLink to="/movies">Movies</NavLink>
        </nav>

        {/* Right side */}
        <div className="flex items-center gap-3">
          <button
            onClick={() => setDark(!dark)}
            className="text-muted-foreground hover:text-foreground transition-colors"
          >
            {dark ? <Sun size={18} /> : <Moon size={18} />}
          </button>

          <Link to="/login">
            <Button variant="ghost" size="sm">
              Login
            </Button>
          </Link>

          <Link to="/register">
            <Button size="sm">Register</Button>
          </Link>
        </div>
      </div>
    </header>
  );
}
