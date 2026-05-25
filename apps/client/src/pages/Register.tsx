import { useState, useMemo, useContext } from "react";
import { Link } from "react-router-dom";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import {
  useRegister,
  useConfirmEmail,
  useResendConfirmationEmail,
} from "../hooks/useAuth";
import { Button } from "../components/ui/button";
import { Input } from "../components/ui/input";
import {
  FieldSet,
  FieldGroup,
  Field,
  FieldLabel,
  FieldError,
} from "../components/ui/field";
import {
  InputOTP,
  InputOTPGroup,
  InputOTPSlot,
} from "../components/ui/input-otp";
import { OTPInputContext } from "input-otp";
import { cn } from "@/lib/utils";
import {
  Mail,
  Lock,
  CalendarDays,
  ChevronLeft,
  Loader2,
  ArrowRight,
  Zap,
  Tag,
  Crown,
  CheckCircle2,
  Sparkles,
  KeyRound,
  PartyPopper,
  Eye,
  EyeOff,
  ShieldCheck,
} from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";
import logo from "../assets/logo-Photoroom.png";
import type { ApiError } from "@/types/api";

// ─── Schema ───────────────────────────────────────────────────────────────────

const formSchema = z
  .object({
    email: z
      .string()
      .min(1, "Email is required")
      .email("Invalid email address"),
    dateOfBirth: z
      .string()
      .min(1, "Date of birth is required")
      .regex(/^\d{4}-\d{2}-\d{2}$/, "Use format YYYY-MM-DD")
      .refine(
        (val) => {
          const date = new Date(val);
          if (isNaN(date.getTime())) return false;
          const age = new Date().getFullYear() - date.getFullYear();
          return age >= 5 && age <= 150;
        },
        { message: "You must be at least 5 years old" },
      ),
    password: z
      .string()
      .min(1, "Password is required")
      .min(8, "Password must be at least 8 characters"),
    confirmPassword: z.string().min(1, "Please confirm your password"),
  })
  .refine((data) => data.password === data.confirmPassword, {
    message: "Passwords do not match",
    path: ["confirmPassword"],
  });

type FormValues = z.infer<typeof formSchema>;

// ─── Password strength ────────────────────────────────────────────────────────

interface StrengthRule {
  label: string;
  test: (pw: string) => boolean;
}

const STRENGTH_RULES: StrengthRule[] = [
  { label: "8+ characters", test: (pw) => pw.length >= 8 },
  { label: "Uppercase letter", test: (pw) => /[A-Z]/.test(pw) },
  { label: "Lowercase letter", test: (pw) => /[a-z]/.test(pw) },
  { label: "Number", test: (pw) => /\d/.test(pw) },
  { label: "Special character", test: (pw) => /[^A-Za-z0-9]/.test(pw) },
];

function getStrength(password: string): {
  label: string;
  color: string;
  bars: number;
} {
  if (!password) return { label: "", color: "", bars: 0 };
  const passed = STRENGTH_RULES.filter((r) => r.test(password)).length;
  if (passed <= 1) return { label: "Weak", color: "bg-red-500", bars: 1 };
  if (passed <= 2) return { label: "Fair", color: "bg-orange-500", bars: 2 };
  if (passed <= 3) return { label: "Good", color: "bg-yellow-500", bars: 3 };
  if (passed <= 4) return { label: "Strong", color: "bg-lime-500", bars: 4 };
  return { label: "Very Strong", color: "bg-emerald-500", bars: 5 };
}

const PasswordStrength = ({ password }: { password: string }) => {
  const [showRules, setShowRules] = useState(false);
  const strength = useMemo(() => getStrength(password), [password]);

  return (
    <AnimatePresence>
      {password.length > 0 && (
        <motion.div
          initial={{ opacity: 0, height: 0 }}
          animate={{ opacity: 1, height: "auto" }}
          exit={{ opacity: 0, height: 0 }}
          className="overflow-hidden"
        >
          <div className="pt-2 pb-1 space-y-2">
            <div className="flex gap-1">
              {[1, 2, 3, 4, 5].map((bar) => (
                <div key={bar} className="h-1 flex-1 rounded-full bg-border/30">
                  <motion.div
                    initial={{ scaleX: 0 }}
                    animate={{ scaleX: bar <= strength.bars ? 1 : 0 }}
                    transition={{
                      duration: 0.4,
                      delay: bar * 0.08,
                      ease: "easeOut",
                    }}
                    className={`h-full rounded-full origin-left ${bar <= strength.bars ? strength.color : ""}`}
                  />
                </div>
              ))}
            </div>
            <div className="flex items-center justify-between">
              {strength.label && (
                <span
                  className={`text-[11px] font-bold uppercase tracking-wider ${strength.color.replace("bg-", "text-")}`}
                >
                  {strength.label}
                </span>
              )}
              <button
                type="button"
                onClick={() => setShowRules(!showRules)}
                className="text-[10px] font-medium text-muted-foreground/50 hover:text-muted-foreground transition-colors uppercase tracking-wider"
              >
                {showRules ? "Hide" : "Requirements"}
              </button>
            </div>
            <AnimatePresence>
              {showRules && (
                <motion.div
                  initial={{ opacity: 0, height: 0 }}
                  animate={{ opacity: 1, height: "auto" }}
                  exit={{ opacity: 0, height: 0 }}
                  className="space-y-1 overflow-hidden"
                >
                  {STRENGTH_RULES.map((rule) => {
                    const passed = rule.test(password);
                    return (
                      <div
                        key={rule.label}
                        className={`flex items-center gap-2 text-xs font-medium transition-colors duration-300 ${
                          passed
                            ? "text-emerald-500"
                            : "text-muted-foreground/50"
                        }`}
                      >
                        {passed ? (
                          <CheckCircle2 className="h-3 w-3" />
                        ) : (
                          <div className="h-3 w-3 rounded-full border-2 border-current" />
                        )}
                        {rule.label}
                      </div>
                    );
                  })}
                </motion.div>
              )}
            </AnimatePresence>
          </div>
        </motion.div>
      )}
    </AnimatePresence>
  );
};

// ─── Error banner ─────────────────────────────────────────────────────────────

const ErrorBanner = ({ message }: { message: string | null }) => (
  <AnimatePresence mode="wait">
    {message && (
      <motion.div
        initial={{ opacity: 0, y: -8, height: 0 }}
        animate={{ opacity: 1, y: 0, height: "auto" }}
        exit={{ opacity: 0, y: -8, height: 0 }}
        className="overflow-hidden"
      >
        <div className="p-3.5 rounded-2xl bg-destructive/8 border border-destructive/15 flex items-center gap-3">
          <div className="h-2 w-2 rounded-full bg-destructive animate-pulse shrink-0" />
          <p className="text-destructive text-xs font-medium leading-relaxed">
            {message}
          </p>
        </div>
      </motion.div>
    )}
  </AnimatePresence>
);

// ─── Shared field helpers ─────────────────────────────────────────────────────

const SuccessCheckmark = ({ show }: { show: boolean }) => (
  <AnimatePresence>
    {show && (
      <motion.div
        initial={{ scale: 0 }}
        animate={{ scale: 1 }}
        exit={{ scale: 0 }}
        transition={{ type: "spring", stiffness: 400, damping: 20 }}
        className="absolute right-4 top-1/2 -translate-y-1/2 z-10"
      >
        <div className="h-5 w-5 rounded-full bg-emerald-500/15 flex items-center justify-center">
          <CheckCircle2 className="h-3.5 w-3.5 text-emerald-500" />
        </div>
      </motion.div>
    )}
  </AnimatePresence>
);

const PasswordToggle = ({
  show,
  onToggle,
}: {
  show: boolean;
  onToggle: () => void;
}) => (
  <button
    type="button"
    onClick={onToggle}
    tabIndex={-1}
    className="absolute right-4 top-1/2 -translate-y-1/2 text-muted-foreground/40 hover:text-foreground/70 transition-colors z-10 cursor-pointer"
    aria-label={show ? "Hide password" : "Show password"}
  >
    <AnimatePresence mode="wait">
      {show ? (
        <motion.div
          key="off"
          initial={{ opacity: 0, scale: 0.8 }}
          animate={{ opacity: 1, scale: 1 }}
          exit={{ opacity: 0, scale: 0.8 }}
        >
          <EyeOff className="h-[18px] w-[18px]" />
        </motion.div>
      ) : (
        <motion.div
          key="on"
          initial={{ opacity: 0, scale: 0.8 }}
          animate={{ opacity: 1, scale: 1 }}
          exit={{ opacity: 0, scale: 0.8 }}
        >
          <Eye className="h-[18px] w-[18px]" />
        </motion.div>
      )}
    </AnimatePresence>
  </button>
);

// ─── Step 1: Registration Form ────────────────────────────────────────────────

const iconClass = (error?: string, isTouched?: boolean) => {
  if (error && isTouched) return "text-destructive";
  if (isTouched && !error) return "text-emerald-500";
  return "text-muted-foreground/30";
};

const errorBorderClass = (error?: string, isTouched?: boolean) => {
  if (error && isTouched)
    return "border-destructive/60 focus:border-destructive focus:ring-4 focus:ring-destructive/10";
  return "border-border/50 hover:border-border focus:border-primary/60 focus:ring-4 focus:ring-primary/8";
};

const RegisterForm = ({
  onSuccess,
}: {
  onSuccess: (email: string) => void;
}) => {
  const { mutate: register, isPending, error } = useRegister();
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);

  const form = useForm<FormValues>({
    resolver: zodResolver(formSchema),
    mode: "onBlur",
    defaultValues: {
      email: "",
      dateOfBirth: "",
      password: "",
      confirmPassword: "",
    },
  });

  const watchedPassword = form.watch("password");
  const { errors, touchedFields } = form.formState;
  const apiError = error as ApiError | null;

  const onSubmit = (values: FormValues) => {
    register(
      {
        email: values.email,
        password: values.password,
        dateOfBirth: values.dateOfBirth,
      },
      { onSuccess: () => onSuccess(values.email) },
    );
  };

  const fieldVariants = {
    hidden: { opacity: 0, y: 16 },
    visible: (i: number) => ({
      opacity: 1,
      y: 0,
      transition: { delay: i * 0.08, duration: 0.4, ease: "easeOut" },
    }),
  };

  return (
    <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
      <motion.div
        initial="hidden"
        animate="visible"
        variants={{ hidden: {}, visible: {} }}
        className="space-y-4"
      >
        <FieldSet>
          <FieldGroup>
            {/* Email */}
            <motion.div custom={0} variants={fieldVariants}>
              <Field
                data-invalid={!!errors.email}
                data-disabled={isPending || undefined}
              >
                <FieldLabel
                  htmlFor="email"
                  className="text-[11px] font-bold text-muted-foreground/60 uppercase tracking-[0.15em]"
                >
                  Email Address
                </FieldLabel>
                <div className="relative">
                  <Mail
                    className={`absolute left-4 top-1/2 -translate-y-1/2 h-[18px] w-[18px] z-10 transition-colors ${iconClass(errors.email?.message, touchedFields.email)}`}
                  />
                  <Input
                    id="email"
                    placeholder="you@example.com"
                    autoComplete="email"
                    autoFocus
                    disabled={isPending}
                    className={`h-14 pl-12 pr-4 rounded-2xl text-sm shadow-xs transition-all duration-300 ${errorBorderClass(errors.email?.message, touchedFields.email)}`}
                    {...form.register("email")}
                  />
                  <SuccessCheckmark
                    show={
                      !!touchedFields.email &&
                      !errors.email &&
                      form.watch("email").length > 0
                    }
                  />
                </div>
                <FieldError
                  errors={errors.email ? [errors.email] : undefined}
                />
              </Field>
            </motion.div>

            {/* Date of Birth */}
            <motion.div custom={1} variants={fieldVariants}>
              <Field
                data-invalid={!!errors.dateOfBirth}
                data-disabled={isPending || undefined}
              >
                <FieldLabel
                  htmlFor="dateOfBirth"
                  className="text-[11px] font-bold text-muted-foreground/60 uppercase tracking-[0.15em]"
                >
                  Date of Birth
                </FieldLabel>
                <div className="relative">
                  <CalendarDays
                    className={`absolute left-4 top-1/2 -translate-y-1/2 h-[18px] w-[18px] z-10 transition-colors ${iconClass(errors.dateOfBirth?.message, touchedFields.dateOfBirth)}`}
                  />
                  <Input
                    id="dateOfBirth"
                    type="date"
                    placeholder="YYYY-MM-DD"
                    autoComplete="bday"
                    disabled={isPending}
                    className={`h-14 pl-12 pr-4 rounded-2xl text-sm shadow-xs transition-all duration-300 ${errorBorderClass(errors.dateOfBirth?.message, touchedFields.dateOfBirth)}`}
                    {...form.register("dateOfBirth")}
                  />
                  <SuccessCheckmark
                    show={
                      !!touchedFields.dateOfBirth &&
                      !errors.dateOfBirth &&
                      form.watch("dateOfBirth").length > 0
                    }
                  />
                </div>
                <FieldError
                  errors={errors.dateOfBirth ? [errors.dateOfBirth] : undefined}
                />
              </Field>
            </motion.div>

            {/* Password */}
            <motion.div custom={2} variants={fieldVariants}>
              <Field
                data-invalid={!!errors.password}
                data-disabled={isPending || undefined}
              >
                <div className="flex items-center justify-between">
                  <FieldLabel
                    htmlFor="password"
                    className="text-[11px] font-bold text-muted-foreground/60 uppercase tracking-[0.15em]"
                  >
                    Password
                  </FieldLabel>
                  <span className="text-[10px] font-medium text-muted-foreground/50">
                    Min 8 characters
                  </span>
                </div>
                <div className="relative">
                  <Lock
                    className={`absolute left-4 top-1/2 -translate-y-1/2 h-[18px] w-[18px] z-10 transition-colors ${iconClass(errors.password?.message, touchedFields.password)}`}
                  />
                  <Input
                    id="password"
                    type={showPassword ? "text" : "password"}
                    placeholder="Create a strong password"
                    autoComplete="new-password"
                    disabled={isPending}
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
                <PasswordStrength password={watchedPassword} />
              </Field>
            </motion.div>

            {/* Confirm Password */}
            <motion.div custom={3} variants={fieldVariants}>
              <Field
                data-invalid={!!errors.confirmPassword}
                data-disabled={isPending || undefined}
              >
                <FieldLabel
                  htmlFor="confirmPassword"
                  className="text-[11px] font-bold text-muted-foreground/60 uppercase tracking-[0.15em]"
                >
                  Confirm Password
                </FieldLabel>
                <div className="relative">
                  <Lock
                    className={`absolute left-4 top-1/2 -translate-y-1/2 h-[18px] w-[18px] z-10 transition-colors ${iconClass(errors.confirmPassword?.message, touchedFields.confirmPassword)}`}
                  />
                  <Input
                    id="confirmPassword"
                    type={showConfirmPassword ? "text" : "password"}
                    placeholder="Re-enter your password"
                    autoComplete="new-password"
                    disabled={isPending}
                    className={`h-14 pl-12 pr-12 rounded-2xl text-sm shadow-xs transition-all duration-300 ${errorBorderClass(errors.confirmPassword?.message, touchedFields.confirmPassword)}`}
                    {...form.register("confirmPassword")}
                  />
                  <PasswordToggle
                    show={showConfirmPassword}
                    onToggle={() =>
                      setShowConfirmPassword(!showConfirmPassword)
                    }
                  />
                </div>
                <FieldError
                  errors={
                    errors.confirmPassword
                      ? [errors.confirmPassword]
                      : undefined
                  }
                />
              </Field>
            </motion.div>
          </FieldGroup>
        </FieldSet>
      </motion.div>

      <ErrorBanner message={apiError?.message || null} />

      <motion.div
        initial={{ opacity: 0, y: 16 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.35, duration: 0.4 }}
        className="pt-1 space-y-4"
      >
        <Button
          type="submit"
          className="w-full h-13 bg-primary hover:bg-primary/90 text-primary-foreground font-black text-base rounded-2xl active:scale-[0.98] shadow-[0_8px_28px_rgba(var(--primary),0.25)] hover:shadow-[0_12px_36px_rgba(var(--primary),0.35)] overflow-hidden relative group transition-all duration-300"
          disabled={isPending}
        >
          <div className="absolute inset-0 bg-linear-to-r from-transparent via-white/15 to-transparent -translate-x-full group-hover:translate-x-full transition-transform duration-1000" />
          {isPending ? (
            <span className="flex items-center justify-center gap-2.5">
              <Loader2 className="h-5 w-5 animate-spin" />
              <span>Creating account...</span>
            </span>
          ) : (
            <span className="flex items-center justify-center gap-2.5">
              <Sparkles className="h-[18px] w-[18px]" />
              <span>Create Account</span>
              <ArrowRight className="h-[18px] w-[18px] group-hover:translate-x-1 transition-transform" />
            </span>
          )}
        </Button>

        <p className="text-sm text-center text-muted-foreground/70 font-medium">
          Already have an account?{" "}
          <Link
            to="/login"
            className="text-foreground font-black hover:text-primary transition-colors uppercase tracking-[0.08em] text-[11px]"
          >
            Sign In
          </Link>
        </p>
      </motion.div>
    </form>
  );
};

// ─── Step 2: 6-Digit Code Verification ───────────────────────────────────────

const OtpSlot = ({ index, shake }: { index: number; shake: boolean }) => {
  const ctx = useContext(OTPInputContext);
  const { char, isActive } = ctx?.slots[index] ?? {};
  const isFilled = !!char;

  return (
    <InputOTPSlot
      index={index}
      className={cn(
        "w-14 h-16 text-2xl font-bold rounded-xl border-2 transition-all duration-200",
        "first:rounded-xl last:rounded-xl first:border-l-2 last:border-r-2",
        isFilled
          ? "bg-primary/10 border-primary/60 text-foreground shadow-[0_0_24px_rgba(var(--primary),0.12)]"
          : "bg-white/60 dark:bg-white/[0.07] border-border/50 dark:border-white/20 text-foreground hover:border-primary/40 dark:hover:border-primary/50",
        isActive && "border-primary ring-4 ring-primary/12",
        shake && "border-destructive/60",
      )}
    />
  );
};

const VerifyCodeForm = ({ email }: { email: string }) => {
  const { mutate: confirm, isPending, error } = useConfirmEmail();
  const { mutate: resend, isPending: isResending } =
    useResendConfirmationEmail();
  const [digits, setDigits] = useState("");
  const [shake, setShake] = useState(false);
  const apiError = error as ApiError | null;

  const triggerShake = () => {
    setShake(true);
    setTimeout(() => setShake(false), 500);
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (digits.length < 6) {
      triggerShake();
      return;
    }
    confirm(
      { email, code: digits },
      {
        onError: () => {
          triggerShake();
          setDigits("");
        },
      },
    );
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-6">
      <motion.div
        initial={{ opacity: 0, scale: 0.92 }}
        animate={{ opacity: 1, scale: 1 }}
        transition={{ type: "spring", stiffness: 180, damping: 18 }}
        className="text-center space-y-3"
      >
        <div className="mx-auto h-14 w-14 rounded-2xl bg-primary/8 border border-primary/15 flex items-center justify-center">
          <KeyRound className="h-7 w-7 text-primary" />
        </div>
        <div className="space-y-1">
          <p className="text-muted-foreground text-sm font-medium">
            We sent a 6-digit code to
          </p>
          <p className="text-foreground font-bold text-base">{email}</p>
        </div>
      </motion.div>

      <motion.div
        animate={shake ? { x: [-6, 6, -4, 4, -2, 2, 0] } : {}}
        transition={shake ? { duration: 0.5 } : {}}
        className="flex justify-center"
      >
        <InputOTP
          maxLength={6}
          value={digits}
          onChange={(val) => setDigits(val)}
          disabled={isPending}
          containerClassName="gap-2.5"
        >
          <InputOTPGroup>
            {Array.from({ length: 6 }).map((_, i) => (
              <OtpSlot key={i} index={i} shake={shake} />
            ))}
          </InputOTPGroup>
        </InputOTP>
      </motion.div>

      <ErrorBanner message={apiError?.message || null} />

      <motion.div
        initial={{ opacity: 0, y: 16 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.25, duration: 0.4 }}
        className="space-y-3"
      >
        <Button
          type="submit"
          className="w-full h-13 bg-primary hover:bg-primary/90 text-primary-foreground font-black text-base rounded-2xl active:scale-[0.98] shadow-[0_8px_28px_rgba(var(--primary),0.25)] hover:shadow-[0_12px_36px_rgba(var(--primary),0.35)] overflow-hidden relative group transition-all duration-300"
          disabled={isPending || digits.length < 6}
        >
          <div className="absolute inset-0 bg-linear-to-r from-transparent via-white/15 to-transparent -translate-x-full group-hover:translate-x-full transition-transform duration-1000" />
          {isPending ? (
            <span className="flex items-center justify-center gap-2.5">
              <Loader2 className="h-5 w-5 animate-spin" />
              <span>Verifying...</span>
            </span>
          ) : (
            <span className="flex items-center justify-center gap-2.5">
              <PartyPopper className="h-[18px] w-[18px]" />
              <span>Verify Email</span>
              <ArrowRight className="h-[18px] w-[18px] group-hover:translate-x-1 transition-transform" />
            </span>
          )}
        </Button>

        <p className="text-sm text-center text-muted-foreground/70 font-medium">
          Didn't receive it?{" "}
          <button
            type="button"
            disabled={isResending}
            onClick={() => resend(email)}
            className="text-foreground font-black hover:text-primary transition-colors uppercase tracking-[0.08em] text-[11px] cursor-pointer disabled:opacity-40"
          >
            {isResending ? "Sending..." : "Resend code"}
          </button>
        </p>
      </motion.div>
    </form>
  );
};

// ─── Background decoration ────────────────────────────────────────────────────

const bgOrbs = [
  {
    size: 400,
    x: "10%",
    y: "-10%",
    color: "rgba(var(--primary),0.06)",
    delay: 0,
  },
  {
    size: 300,
    x: "70%",
    y: "20%",
    color: "rgba(var(--primary),0.04)",
    delay: 3,
  },
  {
    size: 250,
    x: "50%",
    y: "60%",
    color: "rgba(var(--primary),0.05)",
    delay: 6,
  },
  { size: 350, x: "20%", y: "70%", color: "rgba(168,85,247,0.03)", delay: 9 },
];

// ─── Main Page ────────────────────────────────────────────────────────────────

const Register = () => {
  const [step, setStep] = useState<"register" | "verify">("register");
  const [email, setEmail] = useState("");

  const handleRegistered = (email: string) => {
    setEmail(email);
    setStep("verify");
  };

  return (
    <div className="h-[calc(100vh-4rem)] grid lg:grid-cols-2 bg-background selection:bg-primary/20 overflow-hidden">
      {/* Left Side: Cinematic Branding */}
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
                "url('https://images.unsplash.com/photo-1536440136628-849c177e76a1?q=80&w=1925&auto=format&fit=crop')",
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
                <span className="italic-outline-adaptive">Join</span> <br />
                <span className="text-primary not-italic">The Club</span>
              </h2>
            </motion.div>
            <motion.p
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.3, duration: 0.6 }}
              className="text-muted-foreground dark:text-zinc-400 text-lg lg:text-xl font-medium leading-relaxed"
            >
              Create your account to unlock premium seating, early access to
              blockbusters, and members-only rewards.
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
              Join The Premium Standard
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
              <div className="h-9 w-9 rounded-xl bg-foreground/5 dark:bg-white/5 border border-foreground/10 dark:border-white/10 flex items-center justify-center group-hover/item:bg-primary/15 group-hover/item:border-primary/25 transition-all duration-300">
                <item.icon className="h-4 w-4 text-muted-foreground dark:text-zinc-500 group-hover/item:text-primary transition-colors" />
              </div>
              <span className="text-muted-foreground dark:text-zinc-500 text-[9px] font-black uppercase tracking-widest group-hover/item:text-foreground dark:group-hover/item:text-zinc-300 transition-colors">
                {item.label}
              </span>
            </div>
          ))}
        </motion.div>
      </div>

      {/* Right Side: Form */}
      <div className="relative flex flex-col justify-center items-center p-6 lg:p-10 overflow-y-auto lg:overflow-hidden bg-zinc-50/40 dark:bg-background">
        <div className="absolute inset-0 overflow-hidden pointer-events-none">
          {bgOrbs.map((orb, i) => (
            <motion.div
              key={i}
              className="absolute rounded-full"
              style={{
                width: orb.size,
                height: orb.size,
                left: orb.x,
                top: orb.y,
                background: `radial-gradient(circle, ${orb.color} 0%, transparent 70%)`,
              }}
              animate={{ x: [0, 30, -20, 0], y: [0, -30, 20, 0] }}
              transition={{
                duration: 20 + i * 3,
                repeat: Infinity,
                ease: "easeInOut",
                delay: orb.delay,
              }}
            />
          ))}
        </div>

        <div className="absolute top-6 left-8 lg:hidden z-10">
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
            visible: { opacity: 1, transition: { staggerChildren: 0.08 } },
          }}
          className="w-full max-w-md space-y-7 relative z-10"
        >
          {/* Header */}
          <motion.div
            variants={{
              hidden: { opacity: 0, y: 16 },
              visible: { opacity: 1, y: 0 },
            }}
            className="space-y-2"
          >
            {step === "verify" ? (
              <button
                type="button"
                onClick={() => setStep("register")}
                className="inline-flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground transition-colors mb-3 group/back font-medium cursor-pointer"
              >
                <ChevronLeft className="h-4 w-4 group-hover/back:-translate-x-1 transition-transform" />
                Back to registration
              </button>
            ) : (
              <Link
                to="/"
                className="inline-flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground transition-colors mb-3 group/back font-medium"
              >
                <ChevronLeft className="h-4 w-4 group-hover/back:-translate-x-1 transition-transform" />
                Back to home
              </Link>
            )}
            <h1 className="text-5xl lg:text-6xl font-black tracking-tighter uppercase italic leading-none">
              <span className="text-foreground pr-3">
                {step === "register" ? "Join" : "Verify"}
              </span>
              <span className="text-primary">
                {step === "register" ? "Us" : "Now"}
              </span>
            </h1>
            <p className="text-muted-foreground/70 font-medium text-sm">
              {step === "register"
                ? "Create your premium account"
                : "Enter the 6-digit code sent to your email"}
            </p>
          </motion.div>

          {/* Step indicator */}
          <motion.div
            variants={{ hidden: { opacity: 0 }, visible: { opacity: 1 } }}
            className="flex items-center gap-3"
          >
            {(["register", "verify"] as const).map((s, i) => (
              <div key={s} className="flex items-center gap-3 flex-1">
                <motion.div
                  animate={{ scale: step === s ? 1 : 0.95 }}
                  className={`flex items-center gap-2.5 transition-all duration-500 ${step === s ? "text-foreground" : s === "register" ? "text-primary/60" : "text-muted-foreground/30"}`}
                >
                  <div
                    className={`h-7 w-7 rounded-xl flex items-center justify-center text-[11px] font-black transition-all duration-500 ${step === s ? "bg-primary text-primary-foreground shadow-[0_0_20px_rgba(var(--primary),0.25)]" : s === "register" ? "bg-primary/15 text-primary" : "bg-muted/50 text-muted-foreground/30"}`}
                  >
                    {i + 1}
                  </div>
                  <span className="text-[10px] font-bold uppercase tracking-[0.2em] hidden sm:block">
                    {s === "register" ? "Account" : "Verify"}
                  </span>
                </motion.div>
                {i === 0 && (
                  <div
                    className={`flex-1 h-[2px] rounded-full transition-all duration-700 ${step === "verify" ? "bg-primary" : "bg-border/40"}`}
                  />
                )}
              </div>
            ))}
          </motion.div>

          {/* Glassmorphism card */}
          <motion.div
            variants={{
              hidden: { opacity: 0, y: 16 },
              visible: { opacity: 1, y: 0 },
            }}
            className="relative"
          >
            <div className="absolute inset-0 rounded-3xl bg-gradient-to-b from-primary/[0.03] to-transparent pointer-events-none" />
            <div className="relative rounded-3xl p-7 sm:p-8 bg-white/70 dark:bg-white/[0.03] border border-border/40 dark:border-white/[0.06] shadow-[0_8px_32px_rgba(0,0,0,0.04)] dark:shadow-[0_8px_32px_rgba(0,0,0,0.2)] backdrop-blur-xl">
              <div className="absolute inset-0 rounded-3xl pointer-events-none bg-gradient-to-b from-primary/[0.02] to-transparent dark:from-white/[0.02]" />
              <div className="relative z-10">
                {step === "register" ? (
                  <motion.div
                    key="register"
                    initial={{ opacity: 0 }}
                    animate={{ opacity: 1 }}
                    transition={{ duration: 0.2 }}
                  >
                    <RegisterForm onSuccess={handleRegistered} />
                  </motion.div>
                ) : (
                  <motion.div
                    key="verify"
                    initial={{ opacity: 0 }}
                    animate={{ opacity: 1 }}
                    transition={{ duration: 0.2 }}
                  >
                    <VerifyCodeForm email={email} />
                  </motion.div>
                )}
              </div>
            </div>
          </motion.div>

          <motion.p
            variants={{ hidden: { opacity: 0 }, visible: { opacity: 1 } }}
            className="text-center text-[11px] text-muted-foreground/40 font-medium flex items-center justify-center gap-1.5"
          >
            <ShieldCheck className="h-3 w-3" />
            Your information is encrypted and secure
          </motion.p>
        </motion.div>
      </div>
    </div>
  );
};

export default Register;
