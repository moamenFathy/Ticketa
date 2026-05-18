import { AnimatePresence, motion } from "framer-motion";
import { ShoppingCart, Sparkles, Star, Ticket, X } from "lucide-react";
import { Button } from "./ui/button";
import { getCategoryStyle, rowLabel } from "@/lib/utils";
import { format, parseISO } from "date-fns";

interface Props {
  selectedList: string[];
  rowCategoryMap: Record<number, string>;
  hallName: string;
  startsAt: string;
  onToggleSeat: (key: string) => void;
  onConfirm: () => void;
  onClear: () => void;
}

const OrderSummarySidebar = ({
  selectedList,
  rowCategoryMap,
  hallName,
  startsAt,
  onToggleSeat,
  onConfirm,
  onClear,
}: Props) => {
  return (
    <motion.div
      initial={{ opacity: 0, x: 24 }}
      animate={{ opacity: 1, x: 0 }}
      transition={{ delay: 0.25, duration: 0.5 }}
      className="lg:col-span-1 sticky top-6 space-y-4"
    >
      <div className="rounded-3xl border border-white/8 bg-card/60 backdrop-blur-md shadow-xl overflow-hidden">
        {/* Header */}
        <div className="px-5 py-4 border-b border-white/6 flex items-center gap-2">
          <ShoppingCart className="w-5 h-5 text-primary" />
          <h2 className="font-bold text-base">Your Selection</h2>
          {selectedList.length > 0 && (
            <span className="ml-auto bg-primary/15 border border-primary/30 text-primary text-xs font-bold px-2 py-0.5 rounded-full">
              {selectedList.length}
            </span>
          )}
        </div>

        {/* Seat chips */}
        <div className="px-5 py-4 min-h-[100px]">
          <AnimatePresence mode="popLayout">
            {selectedList.length === 0 ? (
              <motion.p
                key="empty"
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                exit={{ opacity: 0 }}
                className="text-muted-foreground text-sm text-center py-4"
              >
                No seats selected yet
              </motion.p>
            ) : (
              <motion.div key="list" className="flex flex-wrap gap-2">
                {selectedList.map((k) => {
                  const [r, s] = k.split("-").map(Number);
                  const cat = rowCategoryMap[r] ?? "Default";
                  const style = getCategoryStyle(cat);
                  return (
                    <motion.button
                      key={k}
                      layout
                      initial={{ scale: 0, opacity: 0 }}
                      animate={{ scale: 1, opacity: 1 }}
                      exit={{ scale: 0, opacity: 0 }}
                      transition={{
                        type: "spring",
                        stiffness: 300,
                        damping: 20,
                      }}
                      onClick={() => onToggleSeat(k)}
                      className={`flex items-center gap-1.5 px-3 py-1 rounded-full border text-xs font-semibold transition-all group ${style.text} ${style.border} ${style.bg}`}
                    >
                      <Star className="w-3 h-3" />
                      {rowLabel(r)}
                      {s}
                      <X className="w-3 h-3 opacity-50 group-hover:opacity-100 transition-opacity" />
                    </motion.button>
                  );
                })}
              </motion.div>
            )}
          </AnimatePresence>
        </div>

        {/* Summary rows */}
        <div className="px-5 py-3 border-t border-white/6 space-y-2 text-sm">
          <div className="flex justify-between text-muted-foreground">
            <span>Seats</span>
            <span className="font-medium text-foreground">
              {selectedList.length} / 10
            </span>
          </div>
          <div className="flex justify-between text-muted-foreground">
            <span>Hall</span>
            <span className="font-medium text-foreground">{hallName}</span>
          </div>
          <div className="flex justify-between text-muted-foreground">
            <span>Date</span>
            <span className="font-medium text-foreground">
              {startsAt ? format(parseISO(startsAt), "MMM d, yyyy") : "—"}
            </span>
          </div>
        </div>

        {/* CTA */}
        <div className="px-5 pb-5 pt-3">
          <motion.div whileTap={{ scale: 0.97 }}>
            <Button
              className="w-full rounded-2xl h-12 font-bold text-base relative overflow-hidden group"
              disabled={selectedList.length === 0}
              onClick={onConfirm}
              style={
                selectedList.length > 0
                  ? {
                      boxShadow: "0 8px 32px oklch(67.2% 0.191 39deg / 35%)",
                    }
                  : undefined
              }
            >
              <span className="relative z-10 flex items-center justify-center gap-2">
                <Ticket className="w-5 h-5" />
                {selectedList.length === 0
                  ? "Select Seats"
                  : `Confirm ${selectedList.length} Seat${selectedList.length !== 1 ? "s" : ""}`}
              </span>
              {/* Shimmer on hover */}
              <span className="absolute inset-0 -translate-x-full group-hover:translate-x-full transition-transform duration-700 bg-gradient-to-r from-transparent via-white/15 to-transparent" />
            </Button>
          </motion.div>

          {selectedList.length > 0 && (
            <motion.button
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              onClick={onClear}
              className="w-full mt-2 text-xs text-muted-foreground hover:text-foreground transition-colors py-1"
            >
              Clear all
            </motion.button>
          )}
        </div>
      </div>

      {/* Tip card */}
      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ delay: 0.5 }}
        className="rounded-2xl border border-white/6 bg-white/3 px-5 py-4 text-xs text-muted-foreground space-y-1.5"
      >
        <p className="flex items-center gap-1.5 font-semibold text-foreground/70">
          <Sparkles className="w-3.5 h-3.5 text-primary/70" /> Tips
        </p>
        <p>Click a seat to select it. Click again to deselect.</p>
        <p>
          You can select up to <strong>10 seats</strong> per booking.
        </p>
        <p>Greyed-out seats are already booked.</p>
      </motion.div>
    </motion.div>
  );
};

export default OrderSummarySidebar;
