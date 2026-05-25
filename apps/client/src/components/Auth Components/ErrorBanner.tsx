import { AnimatePresence, motion } from "framer-motion";

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

export default ErrorBanner;
