import { useState } from "react";
import { Link } from "react-router-dom";
import { ChevronLeft, ShieldCheck } from "lucide-react";
import { motion } from "framer-motion";
import RegisterForm from "@/components/Auth Components/RegisterForm";
import VerifyCodeForm from "@/components/Auth Components/VerifyCodeForm";
import AdvantagesSection from "@/components/Auth Components/AdvantagesSection";
import Stepper from "@/components/Auth Components/Stepper";
import BrandLogo from "@/components/Auth Components/BrandLogo";

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

        <BrandLogo />

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
        <AdvantagesSection />
      </div>

      {/* Right Side: Form */}
      <div className="relative flex flex-col items-center p-6 lg:p-10 overflow-y-auto bg-zinc-50/40 dark:bg-background h-full">
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
          <div className="space-y-4 mb-2">
            {step === "verify" ? (
              <button
                type="button"
                onClick={() => setStep("register")}
                className="inline-flex items-center gap-1.5 text-sm text-muted-foreground dark:text-zinc-400 hover:text-foreground dark:hover:text-white transition-colors group/back font-medium cursor-pointer"
              >
                <ChevronLeft className="h-4 w-4 group-hover/back:-translate-x-1 transition-transform" />
                Back to registration
              </button>
            ) : (
              <Link
                to="/"
                className="inline-flex items-center gap-1.5 text-sm text-muted-foreground dark:text-zinc-400 hover:text-foreground dark:hover:text-white transition-colors group/back font-medium"
              >
                <ChevronLeft className="h-4 w-4 group-hover/back:-translate-x-1 transition-transform" />
                Back to home
              </Link>
            )}
            <div className="space-y-1">
              <h1 className="text-4xl lg:text-5xl font-black tracking-tight uppercase italic leading-tight">
                <span className="text-foreground dark:text-white pr-3">
                  {step === "register" ? "Join" : "Verify"}
                </span>
                <span className="text-primary">
                  {step === "register" ? "Us" : "Now"}
                </span>
              </h1>
              <p className="text-muted-foreground/70 dark:text-zinc-500 font-medium text-sm">
                {step === "register"
                  ? "Create your account"
                  : "Enter the 6-digit code sent to your email"}
              </p>
            </div>
          </div>

          <Stepper step={step} />

          {/* Glassmorphism card */}
          <motion.div
            variants={{
              hidden: { opacity: 0, y: 16 },
              visible: { opacity: 1, y: 0 },
            }}
            className="relative"
          >
            <div className="absolute inset-0 rounded-3xl bg-linear-to-b from-primary/3 to-transparent pointer-events-none" />
            <div className="relative rounded-3xl p-7 sm:p-8 bg-white/70 dark:bg-white/3 border border-border/40 dark:border-white/6 shadow-[0_8px_32px_rgba(0,0,0,0.04)] dark:shadow-[0_8px_32px_rgba(0,0,0,0.2)] backdrop-blur-xl">
              <div className="absolute inset-0 rounded-3xl pointer-events-none bg-linear-to-b from-primary/2 to-transparent dark:from-white/2" />
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
