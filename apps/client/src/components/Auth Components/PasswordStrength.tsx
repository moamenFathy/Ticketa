import { AnimatePresence, motion } from "framer-motion";
import { CheckCircle2 } from "lucide-react";
import { useMemo, useState } from "react";

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

export default PasswordStrength;
