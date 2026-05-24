import { useState } from "react";
import { Link } from "react-router-dom";
import { useLogin } from "../hooks/useAuth";
import { Button } from "../components/ui/button";
import { Input } from "../components/ui/input";
import {
  Mail,
  Lock,
  Eye,
  EyeOff,
  Loader2,
  ArrowRight,
  ChevronLeft,
  Zap,
  Tag,
  Crown,
} from "lucide-react";
import type { ApiError } from "@/types/api";
import { motion, AnimatePresence } from "framer-motion";
import logo from "../assets/logo-Photoroom.png";

export default function Login() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [isGooglePending, setIsGooglePending] = useState(false);
  const { mutate: login, isPending, error } = useLogin();

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    login({ email, password });
  };

  const handleGoogleLogin = () => {
    setIsGooglePending(true);
    // Simulate google login redirect/popup logic
    setTimeout(() => {
      window.location.href = `${import.meta.env.VITE_API_URL}/auth/google`;
    }, 500);
  };

  const apiError = error as ApiError | null;

  return (
    <div className="h-[calc(100vh-4rem)] grid lg:grid-cols-2 bg-background selection:bg-primary selection:text-primary-foreground overflow-hidden">
      {/* Left Side: Cinematic Branding (Hidden on mobile) */}
      <div className="relative hidden lg:flex flex-col justify-between p-10 overflow-hidden bg-zinc-50 dark:bg-black border-r border-border/50">
        <motion.div
          initial={{ scale: 1.1, opacity: 0 }}
          animate={{ scale: 1, opacity: 1 }}
          transition={{ duration: 1.2, ease: "easeOut" }}
          className="absolute inset-0 z-0"
        >
          <div
            className="w-full h-full opacity-60 dark:opacity-40 brightness-110 dark:brightness-50"
            style={{
              backgroundImage:
                "url('https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?q=80&w=2070&auto=format&fit=crop')",
              backgroundSize: "cover",
              backgroundPosition: "center",
            }}
          />
        </motion.div>

        <div className="absolute inset-0 z-10 bg-linear-to-t from-zinc-50/80 dark:from-black/80 via-transparent to-transparent" />
        <div className="absolute inset-0 z-10 bg-linear-to-r from-zinc-50/90 dark:from-black/90 via-transparent to-transparent" />

        <motion.div
          initial={{ opacity: 0, y: -20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.8, ease: "easeOut" }}
          className="relative z-20 self-start"
        >
          <Link to="/" className="flex items-center gap-6 group">
            <motion.div
              whileHover={{ rotate: -5, scale: 1.1 }}
              transition={{ type: "spring", stiffness: 400, damping: 10 }}
              className="relative"
            >
              <img
                src={logo}
                alt="Ticketa Logo"
                className="h-16 w-16 object-contain drop-shadow-xl"
              />
            </motion.div>
            <div className="flex flex-col">
              <span className="text-4xl font-black tracking-tight text-foreground dark:text-white leading-none">
                TICKETA
              </span>
              <span className="text-xs font-bold tracking-[0.4em] text-primary uppercase mt-2">
                Premium Cinema
              </span>
            </div>
          </Link>
        </motion.div>

        <div className="relative z-20 space-y-6 max-w-lg pl-4">
          <div className="space-y-3">
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.2, duration: 0.8 }}
            >
              <h2 className="text-6xl lg:text-7xl font-black text-foreground dark:text-white leading-[0.85] tracking-tighter uppercase italic">
                <span className="italic-outline-adaptive">Experience</span>{" "}
                <br />
                <span className="text-primary not-italic">Cinema</span>
              </h2>
            </motion.div>
            <motion.p
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.3, duration: 0.6 }}
              className="text-muted-foreground dark:text-zinc-400 text-lg lg:text-xl font-medium leading-relaxed"
            >
              Reserve your favorite seats, explore upcoming blockbusters, and
              manage your bookings all in one place.
            </motion.p>
          </div>

          <motion.div
            initial={{ opacity: 0, x: -10 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ delay: 0.4 }}
            className="flex items-center gap-4"
          >
            <div className="h-px w-12 bg-primary/50" />
            <span className="text-primary font-bold tracking-widest text-[10px] uppercase">
              The Premium Standard
            </span>
          </motion.div>
        </div>

        <motion.div
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.5, duration: 0.6 }}
          className="relative z-20 flex items-center gap-8"
        >
          {[
            { icon: Zap, label: "Fast Booking" },
            { icon: Tag, label: "Exclusive Offers" },
            { icon: Crown, label: "Premium Rewards" },
          ].map((item, i) => (
            <div
              key={i}
              className="flex items-center gap-2.5 group/item cursor-default"
            >
              <div className="h-9 w-9 rounded-xl bg-foreground/5 dark:bg-white/5 border border-foreground/10 dark:border-white/10 flex items-center justify-center group-hover/item:bg-primary/20 group-hover/item:border-primary/30 transition-all duration-300">
                <item.icon className="h-4 w-4 text-muted-foreground dark:text-zinc-500 group-hover/item:text-primary transition-colors" />
              </div>
              <span className="text-muted-foreground dark:text-zinc-500 text-[9px] font-black uppercase tracking-widest group-hover/item:text-foreground dark:group-hover/item:text-zinc-300 transition-colors">
                {item.label}
              </span>
            </div>
          ))}
        </motion.div>
      </div>

      {/* Right Side: Login Form */}
      <div className="flex flex-col justify-center items-center p-6 lg:p-10 relative bg-zinc-50/50 dark:bg-background overflow-y-auto lg:overflow-hidden">
        {/* Mobile Header */}
        <div className="absolute top-6 left-8 lg:hidden">
          <Link to="/" className="flex items-center gap-3 group">
            <img
              src={logo}
              alt="Ticketa"
              className="h-10 w-10 object-contain"
            />
            <span className="text-2xl font-black tracking-tighter text-foreground">
              TICKETA
            </span>
          </Link>
        </div>

        <motion.div
          initial="hidden"
          animate="visible"
          variants={{
            hidden: { opacity: 0 },
            visible: {
              opacity: 1,
              transition: {
                staggerChildren: 0.1,
              },
            },
          }}
          className="w-full max-w-md space-y-8 relative z-10"
        >
          <motion.div
            variants={{
              hidden: { opacity: 0, y: 20 },
              visible: { opacity: 1, y: 0 },
            }}
            className="space-y-2"
          >
            <Link
              to="/"
              className="inline-flex items-center gap-2 text-sm text-muted-foreground hover:text-primary transition-colors mb-2 group/back font-medium"
            >
              <ChevronLeft className="h-4 w-4 group-hover/back:-translate-x-1 transition-transform" />
              Back to home
            </Link>
            <h1 className="text-6xl lg:text-7xl font-black tracking-tighter uppercase italic leading-none">
              <span className="italic-outline-adaptive text-foreground pr-3">
                Sign
              </span>
              <span className="text-primary">In</span>
            </h1>
            <p className="text-muted-foreground font-medium text-base">
              Enter your account details below
            </p>
          </motion.div>

          <form onSubmit={handleSubmit} className="space-y-6">
            <div className="space-y-5">
              <motion.div
                variants={{
                  hidden: { opacity: 0, y: 20 },
                  visible: { opacity: 1, y: 0 },
                }}
                className="space-y-2"
              >
                <label className="text-[11px] font-bold text-muted-foreground uppercase tracking-[0.2em] ml-1">
                  Email Address
                </label>
                <div className="relative group/input">
                  <Mail className="absolute left-5 top-1/2 -translate-y-1/2 h-5 w-5 text-muted-foreground/60 group-focus-within/input:text-primary transition-colors z-10" />
                  <Input
                    type="email"
                    placeholder="john@doe.com"
                    className="h-14 pl-14 bg-white dark:bg-black/40 border-border/60 text-foreground placeholder:text-muted-foreground/40 focus:ring-primary/20 focus:border-primary transition-all rounded-2xl relative z-0 text-base shadow-xs"
                    value={email}
                    autoComplete="username"
                    onChange={(e) => setEmail(e.target.value)}
                    required
                  />
                </div>
              </motion.div>

              <motion.div
                variants={{
                  hidden: { opacity: 0, y: 20 },
                  visible: { opacity: 1, y: 0 },
                }}
                className="space-y-2"
              >
                <div className="flex items-center justify-between ml-1">
                  <label className="text-[11px] font-bold text-muted-foreground uppercase tracking-[0.2em]">
                    Password
                  </label>
                  <Link
                    to="/forgot-password"
                    title="Forgot Password"
                    className="text-[11px] font-bold text-muted-foreground/60 hover:text-primary uppercase tracking-wider transition-colors"
                  >
                    Forgot?
                  </Link>
                </div>
                <div className="relative group/input">
                  <Lock className="absolute left-5 top-1/2 -translate-y-1/2 h-5 w-5 text-muted-foreground/60 group-focus-within/input:text-primary transition-colors z-10" />
                  <Input
                    type={showPassword ? "text" : "password"}
                    placeholder="••••••••"
                    className="h-14 pl-14 pr-14 bg-white dark:bg-black/40 border-border/60 text-foreground placeholder:text-muted-foreground/40 focus:ring-primary/20 focus:border-primary transition-all rounded-2xl relative z-0 text-base shadow-xs"
                    value={password}
                    autoComplete="current-password"
                    onChange={(e) => setPassword(e.target.value)}
                    required
                  />
                  <button
                    type="button"
                    onClick={() => setShowPassword(!showPassword)}
                    className="absolute right-5 top-1/2 -translate-y-1/2 text-muted-foreground/60 hover:text-foreground transition-colors z-10 cursor-pointer"
                  >
                    <AnimatePresence mode="wait">
                      {showPassword ? (
                        <motion.div
                          key="off"
                          initial={{ opacity: 0, scale: 0.8 }}
                          animate={{ opacity: 1, scale: 1 }}
                          exit={{ opacity: 0, scale: 0.8 }}
                        >
                          <EyeOff className="h-5 w-5" />
                        </motion.div>
                      ) : (
                        <motion.div
                          key="on"
                          initial={{ opacity: 0, scale: 0.8 }}
                          animate={{ opacity: 1, scale: 1 }}
                          exit={{ opacity: 0, scale: 0.8 }}
                        >
                          <Eye className="h-5 w-5" />
                        </motion.div>
                      )}
                    </AnimatePresence>
                  </button>
                </div>
              </motion.div>
            </div>

            <AnimatePresence mode="wait">
              {apiError && (
                <motion.div
                  initial={{ opacity: 0, height: 0 }}
                  animate={{ opacity: 1, height: "auto" }}
                  exit={{ opacity: 0, height: 0 }}
                  className="overflow-hidden"
                >
                  <div className="p-4 rounded-2xl bg-destructive/10 border border-destructive/20 flex items-center gap-3">
                    <div className="h-2 w-2 rounded-full bg-destructive animate-pulse" />
                    <p className="text-destructive text-sm font-medium">
                      {apiError.message ||
                        "Invalid credentials. Please try again."}
                    </p>
                  </div>
                </motion.div>
              )}
            </AnimatePresence>

            <motion.div
              variants={{
                hidden: { opacity: 0, y: 20 },
                visible: { opacity: 1, y: 0 },
              }}
              className="space-y-5"
            >
              <Button
                type="submit"
                className="w-full h-14 bg-primary hover:bg-primary/90 text-primary-foreground font-black text-lg rounded-2xl transition-all active:scale-[0.98] shadow-[0_10px_30px_rgba(var(--primary),0.3)] hover:shadow-[0_15px_40px_rgba(var(--primary),0.4)] overflow-hidden relative group"
                disabled={isPending || isGooglePending}
              >
                <div className="absolute inset-0 bg-linear-to-r from-transparent via-white/20 to-transparent -translate-x-full group-hover:translate-x-full transition-transform duration-1000" />
                {isPending ? (
                  <div className="flex items-center justify-center gap-2">
                    <Loader2 className="h-6 w-6 animate-spin" />
                    <span>Processing...</span>
                  </div>
                ) : (
                  <div className="flex items-center justify-center gap-3">
                    <span>Sign In</span>
                    <ArrowRight className="h-6 w-6 group-hover:translate-x-1 transition-transform" />
                  </div>
                )}
              </Button>

              <div className="relative py-2">
                <div className="absolute inset-0 flex items-center">
                  <span className="w-full border-t border-border/60" />
                </div>
                <div className="relative flex justify-center text-[10px] uppercase tracking-[0.4em] font-bold">
                  <span className="bg-zinc-50 dark:bg-background px-6 text-muted-foreground/60">
                    Social Connection
                  </span>
                </div>
              </div>

              <Button
                type="button"
                onClick={handleGoogleLogin}
                variant="outline"
                className="w-full h-14 border-border/60 bg-white/50 dark:bg-black/20 hover:bg-white dark:hover:bg-black/40 dark:hover:border-primary/50 hover:border-primary/50 text-foreground font-bold text-sm rounded-2xl transition-all duration-300 active:scale-[0.98] group relative overflow-hidden shadow-xs"
                disabled={isPending || isGooglePending}
              >
                {isGooglePending ? (
                  <div className="flex items-center justify-center gap-2">
                    <Loader2 className="h-6 w-6 animate-spin text-primary" />
                    <span>Connecting...</span>
                  </div>
                ) : (
                  <div className="flex items-center justify-center gap-4 relative z-10">
                    <svg
                      className="h-5 w-5 transition-transform duration-300 group-hover:scale-110"
                      viewBox="0 0 24 24"
                    >
                      <path
                        fill="#4285F4"
                        d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"
                      />
                      <path
                        fill="#34A853"
                        d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"
                      />
                      <path
                        fill="#FBBC05"
                        d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.25.81-.59z"
                      />
                      <path
                        fill="#EA4335"
                        d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"
                      />
                    </svg>
                    <span className="uppercase tracking-[0.2em] text-[11px] font-black">
                      Continue with Google
                    </span>
                  </div>
                )}
              </Button>
            </motion.div>
          </form>

          <motion.footer
            variants={{
              hidden: { opacity: 0 },
              visible: { opacity: 1 },
            }}
            className="pt-6 border-t border-border/60 flex flex-col items-center gap-4"
          >
            <p className="text-muted-foreground font-medium text-base">
              Don't have an account?{" "}
              <Link
                to="/register"
                title="Register"
                className="text-foreground font-black hover:text-primary transition-colors uppercase tracking-[0.1em] text-sm"
              >
                JOIN NOW
              </Link>
            </p>
          </motion.footer>
        </motion.div>
      </div>
    </div>
  );
}
