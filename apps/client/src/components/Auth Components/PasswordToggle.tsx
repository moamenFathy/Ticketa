import { AnimatePresence, motion } from "framer-motion";
import { Eye, EyeOff } from "lucide-react";

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
          <EyeOff className="h-4.5 w-4.5" />
        </motion.div>
      ) : (
        <motion.div
          key="on"
          initial={{ opacity: 0, scale: 0.8 }}
          animate={{ opacity: 1, scale: 1 }}
          exit={{ opacity: 0, scale: 0.8 }}
        >
          <Eye className="h-4.5 w-4.5" />
        </motion.div>
      )}
    </AnimatePresence>
  </button>
);

export default PasswordToggle;
