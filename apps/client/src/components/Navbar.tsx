import { Link, NavLink } from "react-router-dom";
import {
  Calendar,
  Home,
  LogIn,
  Menu,
  Moon,
  Sun,
  Ticket,
  UserPlus,
} from "lucide-react";
import { useState, useEffect } from "react";
import { Button } from "@/components/ui/button";
import {
  Sheet,
  SheetContent,
  SheetHeader,
  SheetTitle,
  SheetTrigger,
} from "@/components/ui/sheet";
import { Separator } from "@/components/ui/separator";
import { useAuth } from "@/hooks/useAuth";

export default function Navbar() {
  const [isOpen, setIsOpen] = useState(false);
  const [dark, setDark] = useState(
    () => localStorage.getItem("theme") === "dark",
  );
  const { user, isLoggedIn } = useAuth();

  useEffect(() => {
    document.documentElement.classList.toggle("dark", dark);
    localStorage.setItem("theme", dark ? "dark" : "light");
  }, [dark]);

  const navLinks = [
    { to: "/", label: "Home", icon: Home },
    { to: "/showtimes", label: "Showtimes", icon: Calendar },
  ];

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
            <Ticket size={28} className="text-primary" />
            <span>
              ticke<span className="text-primary">ta</span>
            </span>
          </Link>

          {/* Nav links - Desktop */}
          <nav className="hidden md:flex items-center gap-6 text-sm font-medium">
            {navLinks.map((link) => (
              <NavLink key={link.to} to={link.to}>
                {link.label}
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
            {isLoggedIn ? (
              <Link to="/profile">
                <Button variant="ghost" size="sm" className="font-semibold">
                  {user?.name}
                </Button>
              </Link>
            ) : (
              <>
              <Link to="/login">
              <Button variant="ghost" size="sm" className="font-semibold">
                Login
              </Button>
            </Link>
            <Link to="/register">
              <Button size="sm" className="font-semibold rounded-full px-5">
                Register
              </Button>
            </Link>
              </>
            )}
          </div>

          {/* Mobile Menu */}
          <div className="md:hidden">
            <Sheet open={isOpen} onOpenChange={setIsOpen}>
              <SheetTrigger asChild>
                <Button
                  variant="ghost"
                  size="icon"
                  className="hover:bg-accent ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2"
                >
                  <Menu size={24} />
                </Button>
              </SheetTrigger>
              <SheetContent side="right" className="w-80 p-0 overflow-hidden">
                <div className="h-full flex flex-col">
                  <SheetHeader className="p-6 border-b border-border/50 bg-muted/20">
                    <SheetTitle className="flex items-center gap-2">
                      <Ticket size={24} className="text-primary" />
                      <span className="font-black tracking-tighter text-2xl">
                        ticke<span className="text-primary">ta</span>
                      </span>
                    </SheetTitle>
                  </SheetHeader>

                  <div className="flex-1 overflow-y-auto py-6 px-4">
                    <div className="space-y-4">
                      <p className="text-xs font-semibold text-muted-foreground uppercase tracking-wider px-2">
                        Menu
                      </p>
                      <nav className="flex flex-col gap-1">
                        {navLinks.map((link) => (
                          <NavLink
                            key={link.to}
                            to={link.to}
                            onClick={() => setIsOpen(false)}
                            className={({ isActive }) =>
                              `flex items-center gap-3 px-3 py-3 rounded-xl transition-all duration-200 
                            ${
                              isActive
                                ? "bg-primary/10 text-primary font-bold shadow-sm"
                                : "text-muted-foreground hover:bg-accent hover:text-foreground"
                            }
                              `
                            }
                          >
                            <link.icon size={20} />
                            <span>{link.label}</span>
                          </NavLink>
                        ))}
                      </nav>
                    </div>

                    <Separator className="my-6 opacity-50" />

                    <div className="space-y-4">
                      <p className="text-xs font-semibold text-muted-foreground uppercase tracking-wider px-2">
                        Account
                      </p>
                      <div className="flex flex-col gap-2">
                        <Link to="/login" onClick={() => setIsOpen(false)}>
                          <Button
                            variant="ghost"
                            className="w-full justify-start gap-3 rounded-xl h-12 text-muted-foreground hover:text-primary hover:bg-primary/5"
                          >
                            <LogIn size={20} />
                            Login
                          </Button>
                        </Link>
                        <Link to="/register" onClick={() => setIsOpen(false)}>
                          <Button className="w-full justify-start gap-3 rounded-xl h-12 shadow-md shadow-primary/20">
                            <UserPlus size={20} />
                            Create Account
                          </Button>
                        </Link>
                      </div>
                    </div>
                  </div>

                  <div className="p-6 bg-muted/10 border-t border-border mt-auto">
                    <p className="text-xs text-center text-muted-foreground">
                      &copy; 2026 Ticketa. All rights reserved.
                    </p>
                  </div>
                </div>
              </SheetContent>
            </Sheet>
          </div>
        </div>
      </div>
    </header>
  );
}
