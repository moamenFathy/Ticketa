import { AnimatePresence, motion } from "framer-motion";
import { CheckCircle2 } from "lucide-react";

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

export default SuccessCheckmark;
