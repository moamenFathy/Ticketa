import { useState } from "react";
import { Link, useSearchParams } from "react-router-dom";
import { useResetPassword } from "../hooks/useAuth";
import { Button } from "../components/ui/button";
import { Input } from "../components/ui/input";
import { Lock, Loader2, Save } from "lucide-react";
import type { ApiError } from "@/types/api";
import { motion, AnimatePresence } from "framer-motion";
import logo from "../assets/final_logo.svg";
import SuccessCheckmark from "@/components/Auth Components/SuccessCheckmark";
import ErrorBanner from "@/components/Auth Components/ErrorBanner";
import AdvantagesSection from "@/components/Auth Components/AdvantagesSection";
import PasswordToggle from "@/components/Auth Components/PasswordToggle";
import PasswordStrength from "@/components/Auth Components/PasswordStrength";
import z from "zod";
import { useForm, useWatch } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { Field, FieldError, FieldLabel } from "@/components/ui/field";
import { iconClass, errorBorderClass } from "@/lib/utils";

const formSchema = z
  .object({
    password: z.string().min(6, "Password must be at least 6 characters long"),
    confirmPassword: z.string().min(1, "Please confirm your password"),
  })
  .refine((data) => data.password === data.confirmPassword, {
    message: "Passwords don't match",
    path: ["confirmPassword"],
  });

type FormValues = z.infer<typeof formSchema>;

export default function ResetPassword() {
  const [searchParams] = useSearchParams();
  const email = searchParams.get("email") || "";
  const token = searchParams.get("token") || "";

  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);

  const form = useForm<FormValues>({
    resolver: zodResolver(formSchema),
    mode: "onBlur",
    defaultValues: { password: "", confirmPassword: "" },
  });

  const { errors, touchedFields } = form.formState;
  const {
    mutate: resetPassword,
    isPending,
    error: apiErrorFromMutation,
    isSuccess,
  } = useResetPassword();

  const passwordValue =
    useWatch({ control: form.control, name: "password" }) || "";

  const onSubmit = (values: FormValues) => {
    if (!email || !token) return;
    resetPassword({
      email,
      token,
      newPassword: values.password,
    });
  };

  const apiError = apiErrorFromMutation as ApiError | null;

  if (!email || !token) {
    return (
      <div className="h-[calc(100vh-4rem)] flex flex-col items-center justify-center p-6 text-center space-y-6">
        <div className="h-20 w-20 rounded-3xl bg-destructive/10 flex items-center justify-center text-destructive">
          <Lock className="h-10 w-10" />
        </div>
        <div className="space-y-2">
          <h1 className="text-2xl font-black tracking-tight">
            Invalid Reset Link
          </h1>
          <p className="text-muted-foreground max-w-sm mx-auto">
            This password reset link is invalid or has expired. Please request a
            new one.
          </p>
        </div>
        <Button
          asChild
          className="rounded-2xl px-8 h-12 font-bold transition-all active:scale-95"
        >
          <Link to="/forgot-password">Request New Link</Link>
        </Button>
      </div>
    );
  }

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
                "url('https://images.unsplash.com/photo-1478720568477-152d9b164e26?q=80&w=2070&auto=format&fit=crop')",
              backgroundSize: "cover",
              backgroundPosition: "center",
            }}
          />
        </motion.div>
        <div className="absolute inset-0 z-10 bg-linear-to-t from-zinc-50/80 dark:from-black/85 via-transparent to-transparent" />
        <div className="absolute inset-0 z-10 bg-linear-to-r from-zinc-50/90 dark:from-black/90 via-transparent to-transparent" />

        <motion.div
          initial={{ opacity: 0, y: -20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.8, ease: "easeOut" }}
          className="relative z-20 self-start"
        >
          <Link to="/" className="flex items-center gap-5 group">
            <motion.div
              whileHover={{ rotate: -4, scale: 1.08 }}
              transition={{ type: "spring", stiffness: 400, damping: 10 }}
            >
              <img
                src={logo}
                alt="Ticketa"
                className="h-14 w-14 object-contain drop-shadow-xl"
              />
            </motion.div>
            <div className="flex flex-col">
              <span className="text-3xl font-black tracking-tight text-foreground dark:text-white leading-none">
                TICKETA
              </span>
              <span className="text-[10px] font-bold tracking-[0.35em] text-primary uppercase mt-1.5">
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
                <span className="italic-outline-adaptive">Reset</span> <br />
                <span className="text-primary not-italic">Identity</span>
              </h2>
            </motion.div>
            <motion.p
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.3, duration: 0.6 }}
              className="text-muted-foreground dark:text-zinc-400 text-lg lg:text-xl font-medium leading-relaxed"
            >
              Strengthen your security with a new password and continue enjoying
              your favorite blockbusters.
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
              Security Protocol
            </span>
          </motion.div>
        </div>

        <AdvantagesSection />
      </div>

      {/* Right Side: Form */}
      <div className="relative flex items-center justify-center p-6 sm:p-12 overflow-y-auto no-scrollbar">
        <div className="w-full max-w-md mx-auto">
          <AnimatePresence mode="wait">
            {!isSuccess ? (
              <motion.div
                key="form"
                initial={{ opacity: 0, scale: 0.95 }}
                animate={{ opacity: 1, scale: 1 }}
                exit={{ opacity: 0, scale: 0.95 }}
                transition={{ duration: 0.4, ease: "easeOut" }}
                className="space-y-10"
              >
                <div className="space-y-3">
                  <div className="flex items-center gap-3">
                    <div className="h-1 w-12 bg-primary rounded-full" />
                    <span className="text-xs font-bold tracking-widest text-primary uppercase">
                      Security phase
                    </span>
                  </div>
                  <h1 className="text-4xl font-black tracking-tight text-foreground sm:text-5xl">
                    Secure your <span className="text-primary">vault.</span>
                  </h1>
                  <p className="text-muted-foreground text-lg font-medium leading-relaxed max-w-[90%]">
                    Choose a strong password to protect your cinematic
                    experience.
                  </p>
                </div>

                {apiError && (
                  <ErrorBanner message={apiError.message || "Reset failure"} />
                )}

                <form
                  onSubmit={form.handleSubmit(onSubmit)}
                  className="space-y-6"
                >
                  {/* New Password */}
                  <Field>
                    <div className="flex items-center justify-between mb-2">
                      <FieldLabel className="text-xs font-bold uppercase tracking-wider text-muted-foreground/70">
                        New Password
                      </FieldLabel>
                    </div>
                    <div className="relative group">
                      <div className="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none z-10">
                        <Lock
                          className={`h-5 w-5 transition-colors duration-300 ${iconClass(
                            !!errors.password,
                            touchedFields.password,
                          )}`}
                        />
                      </div>
                      <Input
                        type={showPassword ? "text" : "password"}
                        {...form.register("password")}
                        className={`h-14 pl-12 pr-12 bg-muted/30 backdrop-blur-sm transition-all duration-300 rounded-2xl text-base font-medium ${errorBorderClass(
                          errors.password?.message,
                          touchedFields.password,
                        )}`}
                        placeholder="••••••••"
                      />
                      <PasswordToggle
                        show={showPassword}
                        onToggle={() => setShowPassword(!showPassword)}
                      />
                      <div className="absolute inset-0 rounded-2xl transition-all duration-300 group-focus-within:ring-4 group-focus-within:ring-primary/5 pointer-events-none" />
                    </div>
                    <PasswordStrength password={passwordValue} />
                    {errors.password && (
                      <FieldError className="mt-2 text-xs font-bold text-destructive/90 flex items-center gap-1.5">
                        <div className="h-1 w-1 bg-destructive rounded-full" />
                        {errors.password.message}
                      </FieldError>
                    )}
                  </Field>

                  {/* Confirm Password */}
                  <Field>
                    <div className="flex items-center justify-between mb-2">
                      <FieldLabel className="text-xs font-bold uppercase tracking-wider text-muted-foreground/70">
                        Confirm Password
                      </FieldLabel>
                    </div>
                    <div className="relative group">
                      <div className="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none z-10">
                        <Lock
                          className={`h-5 w-5 transition-colors duration-300 ${iconClass(
                            !!errors.confirmPassword,
                            touchedFields.confirmPassword,
                          )}`}
                        />
                      </div>
                      <Input
                        type={showConfirmPassword ? "text" : "password"}
                        {...form.register("confirmPassword")}
                        className={`h-14 pl-12 pr-12 bg-muted/30 backdrop-blur-sm transition-all duration-300 rounded-2xl text-base font-medium ${errorBorderClass(
                          errors.confirmPassword?.message,
                          touchedFields.confirmPassword,
                        )}`}
                        placeholder="••••••••"
                      />
                      <PasswordToggle
                        show={showConfirmPassword}
                        onToggle={() =>
                          setShowConfirmPassword(!showConfirmPassword)
                        }
                      />
                      <div className="absolute inset-0 rounded-2xl transition-all duration-300 group-focus-within:ring-4 group-focus-within:ring-primary/5 pointer-events-none" />
                    </div>
                    {errors.confirmPassword && (
                      <FieldError className="mt-2 text-xs font-bold text-destructive/90 flex items-center gap-1.5">
                        <div className="h-1 w-1 bg-destructive rounded-full" />
                        {errors.confirmPassword.message}
                      </FieldError>
                    )}
                  </Field>

                  <div className="pt-2">
                    <Button
                      type="submit"
                      disabled={isPending}
                      className="w-full h-15 rounded-2xl bg-primary hover:bg-primary/90 text-primary-foreground text-base font-bold shadow-xl shadow-primary/20 transition-all duration-300 active:scale-[0.98] group relative overflow-hidden"
                    >
                      <span className="relative z-10 flex items-center justify-center gap-2">
                        {isPending ? (
                          <>
                            <Loader2 className="h-5 w-5 animate-spin" />
                            Security Updating...
                          </>
                        ) : (
                          <>
                            Update Password
                            <Save className="h-4 w-4 transition-transform group-hover:scale-110" />
                          </>
                        )}
                      </span>
                    </Button>
                  </div>
                </form>
              </motion.div>
            ) : (
              <motion.div
                key="success"
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                className="text-center space-y-8"
              >
                <div className="flex justify-center">
                  <div className="relative">
                    <div className="absolute inset-0 bg-emerald-500/20 blur-3xl rounded-full" />
                    <SuccessCheckmark show={true} />
                  </div>
                </div>
                <div className="space-y-4 relative z-10">
                  <h2 className="text-3xl font-black tracking-tight">
                    Access Restored
                  </h2>
                  <p className="text-muted-foreground font-medium text-lg leading-relaxed">
                    Your password has been successfully updated. <br />
                    You can now use your new credentials to enter.
                  </p>
                </div>
                <div className="pt-6">
                  <Button
                    asChild
                    className="h-14 px-12 rounded-2xl font-bold bg-primary hover:bg-primary/90 text-primary-foreground shadow-xl shadow-primary/20 transition-all duration-300 active:scale-95"
                  >
                    <Link to="/login">Login Now</Link>
                  </Button>
                </div>
              </motion.div>
            )}
          </AnimatePresence>
        </div>
      </div>
    </div>
  );
}
