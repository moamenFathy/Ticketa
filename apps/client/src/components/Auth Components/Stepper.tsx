import { motion } from "framer-motion";

const Stepper = ({ step }: { step: "register" | "verify" }) => {
  return (
    <motion.div
      variants={{ hidden: { opacity: 0 }, visible: { opacity: 1 } }}
      className="flex items-center w-full"
    >
      {/* Step 1: Account */}
      <div className="flex items-center gap-3">
        <div
          className={`h-7 w-7 rounded-xl flex items-center justify-center text-[11px] font-black transition-all duration-500 ${step === "register" ? "bg-primary text-primary-foreground shadow-[0_0_20px_rgba(var(--primary),0.25)]" : "bg-primary/15 text-primary"}`}
        >
          1
        </div>
        <span
          className={`text-[10px] font-bold uppercase tracking-[0.2em] transition-colors duration-500 ${step === "register" ? "text-foreground" : "text-primary/60"}`}
        >
          Account
        </span>
      </div>

      {/* Connecting Line */}
      <div className="flex-1 mx-4 h-px bg-zinc-200 dark:bg-white/10 relative overflow-hidden">
        <motion.div
          initial={{ width: "0%" }}
          animate={{ width: step === "verify" ? "100%" : "0%" }}
          transition={{ duration: 0.7, ease: "easeInOut" }}
          className="absolute inset-0 bg-primary shadow-[0_0_10px_rgba(var(--primary),0.3)]"
        />
      </div>

      {/* Step 2: Verify */}
      <div className="flex items-center gap-3">
        <div
          className={`h-7 w-7 rounded-xl flex items-center justify-center text-[11px] font-black transition-all duration-500 ${step === "verify" ? "bg-primary text-primary-foreground shadow-[0_0_20px_rgba(var(--primary),0.25)]" : "bg-muted/50 text-muted-foreground/30"}`}
        >
          2
        </div>
        <span
          className={`text-[10px] font-bold uppercase tracking-[0.2em] transition-colors duration-500 ${step === "verify" ? "text-foreground" : "text-muted-foreground/30"}`}
        >
          Verify
        </span>
      </div>
    </motion.div>
  );
};

export default Stepper;
