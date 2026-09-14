import { useState } from "react";
import { Link } from "react-router-dom";
import { useLogin, useGoogleAuth } from "../hooks/useAuth";
import { Button } from "../components/ui/button";
import { Input } from "../components/ui/input";
import { Mail, Lock, Loader2, ArrowRight, ChevronLeft } from "lucide-react";
import type { ApiError } from "@/types/api";
import { motion } from "framer-motion";
import SuccessCheckmark from "@/components/Auth Components/SuccessCheckmark";
import PasswordToggle from "@/components/Auth Components/PasswordToggle";
import ErrorBanner from "@/components/Auth Components/ErrorBanner";
import AdvantagesSection from "@/components/Auth Components/AdvantagesSection";
import z from "zod";
import { useForm, useWatch } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { Field, FieldError, FieldLabel } from "@/components/ui/field";
import { GoogleLogin } from "@react-oauth/google";
import BrandLogo from "@/components/Auth Components/BrandLogo";
import { iconClass, errorBorderClass } from "@/lib/utils";

const formSchema = z.object({
  email: z
    .string()
    .min(1, "Email is required")
    .email("Please enter a valid email address"),
  password: z.string().min(6, "Password must be at least 6 characters long"),
});

type FormValues = z.infer<typeof formSchema>;

export default function Login() {
  const form = useForm<FormValues>({
    resolver: zodResolver(formSchema),
    mode: "onBlur",
    defaultValues: { email: "", password: "" },
  });

  const { errors, touchedFields } = form.formState;
  const [showPassword, setShowPassword] = useState(false);
  const { mutate: login, isPending, error: apiErrorFromMutation } = useLogin();
  const { mutate: googleAuth, isPending: isGoogleAuthPending } =
    useGoogleAuth();

  const emailValue = useWatch({ control: form.control, name: "email" }) || "";

  const onSubmit = (values: FormValues) => {
    login(values);
  };

  const apiError = apiErrorFromMutation as ApiError | null;
  const isLoading = isPending || isGoogleAuthPending;

  return (
    <div className="h-[calc(100vh-4rem)] grid lg:grid-cols-2 bg-background selection:bg-primary/20 overflow-hidden">
      {/* Left Side: Branding */}
      <div className="relative hidden lg:flex flex-col justify-between p-10 overflow-hidden bg-zinc-50 dark:bg-black border-r border-border/30">
        <motion.div
          initial={{ scale: 1.1, opacity: 0 }}
          animate={{ scale: 1, opacity: 1 }}
          transition={{ duration: 1.2, ease: "easeOut" }}
          className="absolute inset-0 z-0"
        >
          <div
            className="w-full h-full opacity-50 dark:opacity-35 brightness-110 dark:brightness-50"
            style={{
              backgroundImage:
                "url('https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?q=80&w=2070&auto=format&fit=crop')",
              backgroundSize: "cover",
              backgroundPosition: "center",
            }}
          />
        </motion.div>
        <div className="absolute inset-0 z-10 bg-linear-to-t from-zinc-50/80 dark:from-black/85 via-transparent to-transparent" />
        <div className="absolute inset-0 z-10 bg-linear-to-r from-zinc-50/90 dark:from-black/90 via-transparent to-transparent" />

        <BrandLogo />

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
            <div className="h-px w-12 bg-primary/40" />
            <span className="text-primary font-bold tracking-widest text-[10px] uppercase">
              The Premium Standard
            </span>
          </motion.div>
        </div>

        <AdvantagesSection />
      </div>

      {/* Right Side: Login Form */}
      <div className="relative flex flex-col items-center p-6 lg:p-5 overflow-y-auto bg-zinc-50/40 dark:bg-background h-full">
        <motion.div
          initial="hidden"
          animate="visible"
          variants={{
            hidden: { opacity: 0 },
            visible: { opacity: 1, transition: { staggerChildren: 0.1 } },
          }}
          className="w-full max-w-md space-y-8 relative z-10"
        >
          <motion.div
            variants={{
              hidden: { opacity: 0, y: 16 },
              visible: { opacity: 1, y: 0 },
            }}
            className="space-y-2"
          >
            <Link
              to="/"
              className="inline-flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground transition-colors mb-3 group/back font-medium"
            >
              <ChevronLeft className="h-4 w-4 group-hover/back:-translate-x-1 transition-transform" />
              Back to home
            </Link>
            <h1 className="text-5xl lg:text-6xl font-black tracking-tighter uppercase italic leading-none">
              <span className="text-foreground pr-3">Sign</span>
              <span className="text-primary">In</span>
            </h1>
            <p className="text-muted-foreground/70 font-medium text-sm">
              Enter your account details below
            </p>
          </motion.div>

          <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-5">
            {/* Email */}
            <motion.div
              variants={{
                hidden: { opacity: 0, y: 16 },
                visible: { opacity: 1, y: 0 },
              }}
            >
              <Field
                data-invalid={!!errors.email}
                data-disabled={isLoading || undefined}
              >
                <FieldLabel
                  htmlFor="email"
                  className="text-[11px] font-bold text-muted-foreground/60 uppercase tracking-[0.15em] ml-1"
                >
                  Email Address
                </FieldLabel>
                <div className="relative">
                  <Mail
                    className={`absolute left-4 top-1/2 -translate-y-1/2 h-4.5 w-4.5 z-10 transition-colors ${iconClass(!!errors.email, touchedFields.email)}`}
                  />
                  <Input
                    id="email"
                    type="email"
                    placeholder="john@doe.com"
                    autoComplete="email"
                    autoFocus
                    disabled={isLoading}
                    className={`h-14 pl-12 pr-4 rounded-2xl text-sm shadow-xs transition-all duration-300 ${errorBorderClass(
                      errors.email?.message,
                      touchedFields.email,
                    )}`}
                    {...form.register("email")}
                  />
                  <SuccessCheckmark
                    show={
                      !!touchedFields.email &&
                      !errors.email &&
                      emailValue.length > 0
                    }
                  />
                </div>
                <FieldError
                  errors={errors.email ? [errors.email] : undefined}
                />
              </Field>
            </motion.div>

            {/* Password */}
            <motion.div
              variants={{
                hidden: { opacity: 0, y: 16 },
                visible: { opacity: 1, y: 0 },
              }}
            >
              <Field
                data-invalid={!!errors.password}
                data-disabled={isLoading || undefined}
              >
                <div className="flex items-center justify-between ml-1">
                  <FieldLabel
                    htmlFor="password"
                    className="text-[11px] font-bold text-muted-foreground/60 uppercase tracking-[0.15em]"
                  >
                    Password
                  </FieldLabel>
                  <Link
                    to="/forgot-password"
                    className="text-[11px] font-bold text-muted-foreground/60 hover:text-primary uppercase tracking-wider transition-colors"
                  >
                    Forgot?
                  </Link>
                </div>
                <div className="relative">
                  <Lock
                    className={`absolute left-4 top-1/2 -translate-y-1/2 h-4.5 w-4.5 z-10 transition-colors ${iconClass(!!errors.password, touchedFields.password)}`}
                  />
                  <Input
                    id="password"
                    type={showPassword ? "text" : "password"}
                    placeholder="••••••••"
                    autoComplete="current-password"
                    disabled={isLoading}
                    className={`h-14 pl-12 pr-12 rounded-2xl text-sm shadow-xs transition-all duration-300 ${errorBorderClass(errors.password?.message, touchedFields.password)}`}
                    {...form.register("password")}
                  />
                  <PasswordToggle
                    show={showPassword}
                    onToggle={() => setShowPassword(!showPassword)}
                  />
                </div>
                <FieldError
                  errors={errors.password ? [errors.password] : undefined}
                />
              </Field>
            </motion.div>

            <ErrorBanner message={apiError?.message || null} />

            {/* Submit */}
            <motion.div
              variants={{
                hidden: { opacity: 0, y: 16 },
                visible: { opacity: 1, y: 0 },
              }}
              className="space-y-5"
            >
              <Button
                type="submit"
                className="w-full h-14 bg-primary hover:bg-primary/90 text-primary-foreground font-black text-base rounded-2xl active:scale-[0.98] shadow-[0_8px_28px_rgba(var(--primary),0.25)] hover:shadow-[0_12px_36px_rgba(var(--primary),0.35)] overflow-hidden relative group transition-all duration-300"
                disabled={isLoading}
              >
                <div className="absolute inset-0 bg-linear-to-r from-transparent via-white/15 to-transparent -translate-x-full group-hover:translate-x-full transition-transform duration-1000" />
                {isPending ? (
                  <span className="flex items-center justify-center gap-2.5">
                    <Loader2 className="h-5 w-5 animate-spin" />
                    <span>Processing...</span>
                  </span>
                ) : (
                  <span className="flex items-center justify-center gap-2.5">
                    <span>Sign In</span>
                    <ArrowRight className="h-4.5 w-4.5 group-hover:translate-x-1 transition-transform" />
                  </span>
                )}
              </Button>

              {/* Google */}
              <div className="relative py-1">
                <div className="absolute inset-0 flex items-center">
                  <span className="w-full border-t border-border/40" />
                </div>
                <div className="relative flex justify-center text-[10px] uppercase tracking-[0.35em] font-bold">
                  <span className="bg-zinc-50 dark:bg-background px-5 text-muted-foreground/50">
                    Social Connection
                  </span>
                </div>
              </div>

              <div className="flex justify-center">
                <GoogleLogin
                  onSuccess={(credentialResponse) => {
                    if (credentialResponse.credential) {
                      googleAuth(credentialResponse.credential);
                    }
                  }}
                  onError={() => {
                    console.error("Google Login Failed");
                  }}
                  useOneTap
                  theme={"filled_black"}
                  shape="pill"
                  width="100%"
                />
              </div>
            </motion.div>
          </form>

          <motion.footer
            variants={{ hidden: { opacity: 0 }, visible: { opacity: 1 } }}
            className="pt-4 border-t border-border/40 flex flex-col items-center gap-4"
          >
            <p className="text-muted-foreground/70 font-medium text-sm">
              Don't have an account?{" "}
              <Link
                to="/register"
                className="text-foreground font-black hover:text-primary transition-colors uppercase tracking-[0.08em] text-[11px]"
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
