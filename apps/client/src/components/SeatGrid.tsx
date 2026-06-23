import { getCategoryStyle, rowLabel, seatKey } from "@/lib/utils";
import type { ShowtimeSeats } from "@/types/showtimes";
import { motion } from "framer-motion";
import { Armchair } from "lucide-react";

interface Props {
  seatsData: ShowtimeSeats;
  rows: number;
  seatsPerRow: number;
  bookedSet: Set<string>;
  selected: Set<string>;
  toggleSeat: (key: string) => void;
}

const SeatGrid = ({
  seatsData,
  rows,
  seatsPerRow,
  bookedSet,
  selected,
  toggleSeat,
}: Props) => {
  return (
    <div className="px-4 md:px-8 pb-8 pt-2 overflow-x-auto responsive-seats">
      <div className="flex flex-col gap-1.5 min-w-max mx-auto w-fit">
        {Array.from({ length: rows }, (_, rowIdx) => {
          const category = seatsData!.rowCategoryMap[rowIdx + 1] ?? "Default";
          const style = getCategoryStyle(category);
          const aisleAt = Math.ceil(seatsPerRow / 2);

          // Stadium bowl shape: first/last rows narrower
          const getSkip = (ri: number, total: number): number => {
            if (ri === 0) return 3; // first row
            if (ri === total - 1) return 2; // last row
            if (ri === 1 || ri === total - 2) return 0; // second rows full
            return 0; // middle rows full
          };
          const skip = getSkip(rowIdx, rows);

          // Render a single seat cell
          const renderSeatCell = (seatIdx: number, invisible: boolean) => {
            const seatNum = seatIdx + 1;
            const key = seatKey(rowIdx, seatNum);

            // Invisible spacer (keeps alignment)
            if (invisible) {
              return (
                <div key={`sp-${key}`} className="w-7 h-7 flex-shrink-0" />
              );
            }

            const isBooked = bookedSet.has(key);
            const isSelected = selected.has(key);

            if (isBooked) {
              return (
                <div
                  key={key}
                  title="Booked"
                  className="w-7 h-7 rounded-md bg-muted/30 border border-muted/50 flex items-center justify-center cursor-not-allowed"
                >
                  <Armchair className="w-3.5 h-3.5 text-muted-foreground/40" />
                </div>
              );
            }

            if (isSelected) {
              return (
                <motion.button
                  key={key}
                  onClick={() => toggleSeat(key)}
                  layoutId={key}
                  whileTap={{ scale: 0.85 }}
                  className="w-7 h-7 rounded-md border flex items-center justify-center cursor-pointer relative overflow-hidden"
                  style={{
                    background: "oklch(67.2% 0.191 39deg / 80%)",
                    borderColor: "oklch(67.2% 0.191 39deg)",
                    boxShadow: "0 0 12px oklch(67.2% 0.191 39deg / 50%)",
                  }}
                  title={`${rowLabel(rowIdx)}${seatNum} – selected`}
                >
                  <Armchair className="w-3.5 h-3.5 text-white" />
                </motion.button>
              );
            }

            return (
              <motion.button
                key={key}
                onClick={() => toggleSeat(key)}
                whileHover={{ scale: 1.15, y: -1 }}
                whileTap={{ scale: 0.88 }}
                className={`w-7 h-7 rounded-md border flex items-center justify-center cursor-pointer transition-all duration-150 ${style.bg} ${style.border}`}
                title={`${rowLabel(rowIdx)}${seatNum} – ${category}`}
              >
                <Armchair className={`w-3.5 h-3.5 ${style.text} opacity-80`} />
              </motion.button>
            );
          };

          return (
            <motion.div
              key={rowIdx}
              initial={{ opacity: 0, x: -10 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: 0.02 * rowIdx, duration: 0.3 }}
              className="flex items-center gap-1.5"
            >
              {/* Left row label */}
              <span
                className={`w-6 text-center text-xs font-bold ${style.text} flex-shrink-0`}
              >
                {rowLabel(rowIdx)}
              </span>

              {/* Left seat block */}
              <div className="flex gap-1">
                {Array.from({ length: aisleAt }, (_, i) =>
                  renderSeatCell(i, i < skip),
                )}
              </div>

              {/* Center aisle */}
              <div className="w-5 flex-shrink-0" />

              {/* Right seat block */}
              <div className="flex gap-1">
                {Array.from({ length: seatsPerRow - aisleAt }, (_, i) => {
                  const absIdx = aisleAt + i;
                  const rightCount = seatsPerRow - aisleAt;
                  return renderSeatCell(absIdx, i >= rightCount - skip);
                })}
              </div>

              {/* Right row label */}
              <span
                className={`w-6 text-center text-xs font-bold ${style.text} flex-shrink-0`}
              >
                {rowLabel(rowIdx)}
              </span>
            </motion.div>
          );
        })}
      </div>
    </div>
  );
};

export default SeatGrid;
