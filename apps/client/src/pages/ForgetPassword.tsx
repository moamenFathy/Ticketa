import { Link } from "react-router-dom";
import { useForgotPassword } from "../hooks/useAuth";
import { Button } from "../components/ui/button";
import { Input } from "../components/ui/input";
import { Mail, Loader2, ChevronLeft, Send } from "lucide-react";
import type { ApiError } from "@/types/api";
import { motion, AnimatePresence } from "framer-motion";
import SuccessCheckmark from "@/components/Auth Components/SuccessCheckmark";
import ErrorBanner from "@/components/Auth Components/ErrorBanner";
import AdvantagesSection from "@/components/Auth Components/AdvantagesSection";
import z from "zod";
import { useForm, useWatch } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { Field, FieldError, FieldLabel } from "@/components/ui/field";
import BrandLogo from "@/components/Auth Components/BrandLogo";
import { iconClass, errorBorderClass } from "@/lib/utils";

const formSchema = z.object({
  email: z
    .string()
    .min(1, "Email is required")
    .email("Please enter a valid email address"),
});

type FormValues = z.infer<typeof formSchema>;

export default function ForgetPassword() {
  const form = useForm<FormValues>({
    resolver: zodResolver(formSchema),
    mode: "onBlur",
    defaultValues: { email: "" },
  });

  const { errors, touchedFields } = form.formState;
  const {
    mutate: forgotPassword,
    isPending,
    error: apiErrorFromMutation,
    isSuccess,
  } = useForgotPassword();

  const emailValue = useWatch({ control: form.control, name: "email" }) || "";

  const onSubmit = (values: FormValues) => {
    forgotPassword(values);
  };

  const apiError = apiErrorFromMutation as ApiError | null;

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
                "url('https://images.unsplash.com/photo-1536440136628-849c177e76a1?q=80&w=2025&auto=format&fit=crop')",
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
                <span className="italic-outline-adaptive">Account</span> <br />
                <span className="text-primary not-italic">Recovery</span>
              </h2>
            </motion.div>
            <motion.p
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.3, duration: 0.6 }}
              className="text-muted-foreground dark:text-zinc-400 text-lg lg:text-xl font-medium leading-relaxed"
            >
              Regain access to your premium cinematic journey. We'll help you
              get back to your favorite movies in no time.
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
              Secure Authentication
            </span>
          </motion.div>
        </div>

        <AdvantagesSection />
      </div>

      {/* Right Side: Form */}
      <div className="relative flex items-center justify-center p-6 sm:p-12 overflow-y-auto no-scrollbar">
        {/* Mobile Header */}
        <div className="absolute top-8 left-8 lg:hidden">
          <Link
            to="/login"
            className="p-2.5 rounded-2xl bg-muted/50 text-muted-foreground hover:bg-muted transition-colors inline-flex items-center justify-center"
            aria-label="Back to login"
          >
            <ChevronLeft className="h-5 w-5" />
          </Link>
        </div>

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
                      Recovery Phase
                    </span>
                  </div>
                  <h1 className="text-4xl font-black tracking-tight text-foreground sm:text-5xl">
                    Lost your <span className="text-primary">entry?</span>
                  </h1>
                  <p className="text-muted-foreground text-lg font-medium leading-relaxed max-w-[90%]">
                    Don't worry, it happens to the best of us. Enter your email
                    to regain access.
                  </p>
                </div>

                {apiError && (
                  <ErrorBanner
                    message={apiError.message || "Recovery failure"}
                  />
                )}

                <form
                  onSubmit={form.handleSubmit(onSubmit)}
                  className="space-y-6"
                >
                  <Field>
                    <FieldLabel className="text-xs font-bold uppercase tracking-wider text-muted-foreground/70">
                      Email Address
                    </FieldLabel>
                    <div className="relative group">
                      <div className="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none z-10">
                        <Mail
                          className={`h-5 w-5 transition-colors duration-300 ${iconClass(
                            !!errors.email,
                            touchedFields.email,
                          )}`}
                        />
                      </div>
                      <Input
                        type="email"
                        {...form.register("email")}
                        className={`h-14 pl-12 pr-4 bg-muted/30 backdrop-blur-sm transition-all duration-300 rounded-2xl text-base font-medium ${errorBorderClass(
                          errors.email?.message,
                          touchedFields.email,
                        )}`}
                        placeholder="john@example.com"
                      />
                      <div className="absolute inset-0 rounded-2xl transition-all duration-300 group-focus-within:ring-4 group-focus-within:ring-primary/5 pointer-events-none" />
                    </div>
                    {errors.email && (
                      <FieldError className="mt-2 text-xs font-bold text-destructive/90 flex items-center gap-1.5">
                        <div className="h-1 w-1 bg-destructive rounded-full" />
                        {errors.email.message}
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
                            Processing...
                          </>
                        ) : (
                          <>
                            Send Reset Link
                            <Send className="h-4 w-4 transition-transform group-hover:translate-x-1 group-hover:-translate-y-1" />
                          </>
                        )}
                      </span>
                    </Button>
                  </div>
                </form>

                <div className="pt-8 border-t border-border/50">
                  <Link
                    to="/login"
                    className="flex items-center justify-center gap-2 text-sm font-bold text-muted-foreground hover:text-foreground transition-colors group"
                  >
                    <ChevronLeft className="h-4 w-4 transition-transform group-hover:-translate-x-1" />
                    Back to login
                  </Link>
                </div>
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
                    Check your mail
                  </h2>
                  <p className="text-muted-foreground font-medium text-lg leading-relaxed">
                    We've sent a recovery link to <br />
                    <span className="text-foreground font-bold decoration-primary/30 decoration-2 underline-offset-4 underline">
                      {emailValue}
                    </span>
                  </p>
                </div>
                <div className="pt-6">
                  <Button
                    asChild
                    variant="outline"
                    className="h-14 px-8 rounded-2xl font-bold border-2 hover:bg-muted transition-all duration-300"
                  >
                    <Link to="/login">Return to Login</Link>
                  </Button>
                </div>
                <p className="text-xs text-muted-foreground font-medium pt-4">
                  Didn't receive the email? Check your spam folder or{" "}
                  <button
                    onClick={() => forgotPassword({ email: emailValue })}
                    className="text-primary hover:underline font-bold"
                  >
                    resend
                  </button>
                </p>
              </motion.div>
            )}
          </AnimatePresence>
        </div>
      </div>
    </div>
  );
}
