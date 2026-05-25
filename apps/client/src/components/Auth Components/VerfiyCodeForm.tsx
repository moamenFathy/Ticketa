import { motion } from "framer-motion";
import { Button } from "../ui/button";
import { ArrowRight, KeyRound, Loader2, PartyPopper } from "lucide-react";
import ErrorBanner from "./ErrorBanner";
import { InputOTP, InputOTPGroup, InputOTPSlot } from "../ui/input-otp";
import { REGEXP_ONLY_DIGITS } from "input-otp";
import { useConfirmEmail, useResendConfirmationEmail } from "@/hooks/useAuth";
import { useState, useEffect } from "react";
import type { ApiError } from "@/types/api";

const VerifyCodeForm = ({ email }: { email: string }) => {
  const { mutate: confirm, isPending, error } = useConfirmEmail();
  const { mutate: resend, isPending: isResending } =
    useResendConfirmationEmail();
  const [digits, setDigits] = useState("");
  const [shake, setShake] = useState(false);
  const [resendError, setResendError] = useState<string | null>(null);
  const [resendSuccess, setResendSuccess] = useState(false);
  const [cooldown, setCooldown] = useState(0);
  const apiError = error as ApiError | null;

  useEffect(() => {
    if (cooldown <= 0) return;
    const id = setInterval(() => setCooldown((c) => c - 1), 1000);
    return () => clearInterval(id);
  }, [cooldown]);

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

  const handleResend = () => {
    if (cooldown > 0) return;
    setResendError(null);
    setResendSuccess(false);
    resend(email, {
      onSuccess: () => {
        setResendSuccess(true);
        setCooldown(300);
        setTimeout(() => setResendSuccess(false), 4000);
      },
      onError: (err) => {
        const apiErr = err as ApiError;
        setResendError(apiErr.message || "Failed to resend code. Try again.");
      },
    });
  };

  const formatTime = (seconds: number) => {
    const m = Math.floor(seconds / 60);
    const s = seconds % 60;
    return `${m}:${s.toString().padStart(2, "0")}`;
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
          id="digits-only"
          pattern={REGEXP_ONLY_DIGITS}
          value={digits}
          onChange={(value) => setDigits(value)}
          containerClassName="group flex items-center justify-center"
        >
          <InputOTPGroup className="gap-2.5">
            <InputOTPSlot
              index={0}
              className="h-14 w-12 rounded-xl border-border/50 text-xl font-bold transition-all duration-300 group-focus-within:border-primary/40"
            />
            <InputOTPSlot
              index={1}
              className="h-14 w-12 rounded-xl border-border/50 text-xl font-bold transition-all duration-300 group-focus-within:border-primary/40"
            />
            <InputOTPSlot
              index={2}
              className="h-14 w-12 rounded-xl border-border/50 text-xl font-bold transition-all duration-300 group-focus-within:border-primary/40"
            />
            <InputOTPSlot
              index={3}
              className="h-14 w-12 rounded-xl border-border/50 text-xl font-bold transition-all duration-300 group-focus-within:border-primary/40"
            />
            <InputOTPSlot
              index={4}
              className="h-14 w-12 rounded-xl border-border/50 text-xl font-bold transition-all duration-300 group-focus-within:border-primary/40"
            />
            <InputOTPSlot
              index={5}
              className="h-14 w-12 rounded-xl border-border/50 text-xl font-bold transition-all duration-300 group-focus-within:border-primary/40"
            />
          </InputOTPGroup>
        </InputOTP>
      </motion.div>

      <ErrorBanner message={apiError?.message || resendError || null} />

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
              <PartyPopper className="h-4.5 w-4.5" />
              <span>Verify Email</span>
              <ArrowRight className="h-4.5 w-4.5 group-hover:translate-x-1 transition-transform" />
            </span>
          )}
        </Button>

          <p className="text-sm text-center text-muted-foreground/70 font-medium">
            Didn't receive it?{" "}
            <button
              type="button"
              disabled={isResending || cooldown > 0}
              onClick={handleResend}
              className="text-foreground font-black hover:text-primary transition-colors uppercase tracking-[0.08em] text-[11px] cursor-pointer disabled:opacity-40"
            >
              {isResending
                ? "Sending..."
                : cooldown > 0
                  ? `Resend in ${formatTime(cooldown)}`
                  : resendSuccess
                    ? "Code sent!"
                    : "Resend code"}
            </button>
          </p>
      </motion.div>
    </form>
  );
};

export default VerifyCodeForm;
