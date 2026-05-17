import { useGetSeatsForShowtime } from "@/hooks/useShowtimes";
import { useParams } from "react-router-dom";
import ShowtimeSkeleton from "@/components/skeletons/ShowtimeSkeleton";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { format, parseISO } from "date-fns";
import { motion, AnimatePresence } from "framer-motion";
import { useState, useMemo } from "react";
import {
  Armchair,
  Calendar,
  ChevronLeft,
  Clock,
  Clapperboard,
  MapPin,
  ShoppingCart,
  Sparkles,
  Star,
  Ticket,
  X,
  CheckCircle2,
} from "lucide-react";
import { useNavigate } from "react-router-dom";
import ErrorState from "@/components/ErrorState";

// ─── Category colour palette ────────────────────────────────────────────────
const CATEGORY_COLORS: Record<
  string,
  { bg: string; border: string; text: string; glow: string; label: string }
> = {
  Standard: {
    bg: "bg-blue-500/20 hover:bg-blue-500/50",
    border: "border-blue-500/40 hover:border-blue-400",
    text: "text-blue-300",
    glow: "shadow-blue-500/30",
    label: "Standard",
  },
  Premium: {
    bg: "bg-violet-500/20 hover:bg-violet-500/50",
    border: "border-violet-500/40 hover:border-violet-400",
    text: "text-violet-300",
    glow: "shadow-violet-500/30",
    label: "Premium",
  },
  VIP: {
    bg: "bg-amber-500/20 hover:bg-amber-500/50",
    border: "border-amber-500/40 hover:border-amber-400",
    text: "text-amber-300",
    glow: "shadow-amber-500/30",
    label: "VIP",
  },
  Gold: {
    bg: "bg-yellow-500/20 hover:bg-yellow-500/50",
    border: "border-yellow-500/40 hover:border-yellow-400",
    text: "text-yellow-300",
    glow: "shadow-yellow-500/30",
    label: "Gold",
  },
  IMAX: {
    bg: "bg-cyan-500/20 hover:bg-cyan-500/50",
    border: "border-cyan-500/40 hover:border-cyan-400",
    text: "text-cyan-300",
    glow: "shadow-cyan-500/30",
    label: "IMAX",
  },
  Default: {
    bg: "bg-slate-500/20 hover:bg-slate-500/50",
    border: "border-slate-500/40 hover:border-slate-400",
    text: "text-slate-300",
    glow: "shadow-slate-500/30",
    label: "Standard",
  },
};

function getCategoryStyle(category: string) {
  return CATEGORY_COLORS[category] ?? CATEGORY_COLORS["Default"];
}

// ─── Seat Key helper ─────────────────────────────────────────────────────────
function seatKey(row: number, seat: number) {
  return `${row}-${seat}`;
}

// ─── Row label helper (A, B, C …) ───────────────────────────────────────────
function rowLabel(rowIndex: number) {
  return String.fromCharCode(65 + rowIndex);
}

// ─── Main Component ──────────────────────────────────────────────────────────
const ShowtimeSeats = () => {
  const { id } = useParams();
  const navigate = useNavigate();
  const {
    data: seatsData,
    isLoading,
    isError,
    refetch,
  } = useGetSeatsForShowtime(id!);

  const [selected, setSelected] = useState<Set<string>>(new Set());
  const [confirmed, setConfirmed] = useState(false);

  // Build a Set of booked seat keys for O(1) lookup
  // Backend sends 1-based row indices, our grid uses 0-based
  const bookedSet = useMemo(() => {
    const s = new Set<string>();
    seatsData?.bookedSeats?.forEach((b) =>
      s.add(seatKey(b.row - 1, b.seatNumber)),
    );
    return s;
  }, [seatsData]);

  const toggleSeat = (key: string) => {
    setSelected((prev) => {
      const next = new Set(prev);
      if (next.has(key)) {
        next.delete(key);
      } else {
        if (next.size >= 10) return prev; // max 10
        next.add(key);
      }
      return next;
    });
  };

  // Derive unique categories in display order
  const categories = useMemo(() => {
    if (!seatsData) return [];
    const seen = new Map<string, string>(); // category -> first row label
    Object.entries(seatsData.rowCategoryMap).forEach(([rowIdx, cat]) => {
      if (!seen.has(cat)) seen.set(cat, rowLabel(Number(rowIdx)));
    });
    return Array.from(seen.entries());
  }, [seatsData]);

  const selectedList = useMemo(() => Array.from(selected), [selected]);

  if (isLoading) return <ShowtimeSkeleton />;

  if (isError) return <ErrorState refetch={refetch} />;

  const rows = seatsData!.rows;
  const seatsPerRow = seatsData!.seatsPerRow;
  const posterUrl = seatsData?.moviePosterPath
    ? `https://image.tmdb.org/t/p/w500${seatsData.moviePosterPath}`
    : "/poster-placeholder.png";

  const formattedDate = seatsData?.startsAt
    ? format(parseISO(seatsData.startsAt), "EEE, MMM d • h:mm a")
    : "";

  // ── Confirmation overlay ─────────────────────────────────────────────────
  if (confirmed) {
    return (
      <div className="min-h-screen flex items-center justify-center px-4">
        <motion.div
          initial={{ scale: 0.8, opacity: 0 }}
          animate={{ scale: 1, opacity: 1 }}
          transition={{ type: "spring", duration: 0.6 }}
          className="text-center max-w-sm space-y-6"
        >
          <motion.div
            initial={{ scale: 0 }}
            animate={{ scale: 1 }}
            transition={{ delay: 0.2, type: "spring", stiffness: 200 }}
            className="w-24 h-24 rounded-full bg-primary/10 border-2 border-primary/40 flex items-center justify-center mx-auto"
            style={{ boxShadow: "0 0 60px oklch(67.2% 0.191 39deg / 30%)" }}
          >
            <CheckCircle2 className="w-12 h-12 text-primary" />
          </motion.div>
          <div>
            <h2 className="text-3xl font-black tracking-tight">
              Booking Confirmed!
            </h2>
            <p className="text-muted-foreground mt-2">
              {selectedList.length} seat{selectedList.length !== 1 ? "s" : ""}{" "}
              secured for{" "}
              <span className="text-foreground font-semibold">
                {seatsData?.movieTitle}
              </span>
            </p>
          </div>
          <div className="flex flex-wrap gap-2 justify-center">
            {selectedList.map((k) => {
              const [r, s] = k.split("-").map(Number);
              return (
                <span
                  key={k}
                  className="px-3 py-1 rounded-full bg-primary/15 border border-primary/30 text-primary text-sm font-semibold"
                >
                  {rowLabel(r)}
                  {s}
                </span>
              );
            })}
          </div>
          <div className="flex gap-3 justify-center">
            <Button
              variant="outline"
              className="rounded-full"
              onClick={() => navigate(-1)}
            >
              <ChevronLeft className="w-4 h-4 mr-1" /> Back to showtimes
            </Button>
            <Button
              className="rounded-full"
              onClick={() => {
                setSelected(new Set());
                setConfirmed(false);
              }}
            >
              Book More
            </Button>
          </div>
        </motion.div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-background text-foreground overflow-x-hidden">
      {/* ── Cinematic blurred backdrop ── */}
      <div className="fixed inset-0 -z-10 pointer-events-none overflow-hidden">
        <img
          src={posterUrl}
          alt=""
          className="absolute inset-0 w-full h-full object-cover opacity-[0.04] blur-3xl scale-110"
        />
        <div className="absolute inset-0 bg-gradient-to-b from-background/80 via-background/60 to-background" />
      </div>

      <div className="container mx-auto px-4 py-8 max-w-6xl">
        {/* ── Back ── */}
        <motion.div
          initial={{ opacity: 0, x: -16 }}
          animate={{ opacity: 1, x: 0 }}
          className="mb-6"
        >
          <button
            onClick={() => navigate(-1)}
            className="flex items-center gap-2 text-muted-foreground hover:text-foreground transition-colors group"
          >
            <ChevronLeft className="w-4 h-4 group-hover:-translate-x-1 transition-transform" />
            <span className="text-sm font-medium">Back</span>
          </button>
        </motion.div>

        {/* ── Hero card ── */}
        <motion.div
          initial={{ opacity: 0, y: 24 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5 }}
          className="relative rounded-3xl overflow-hidden border border-white/8 bg-card/60 backdrop-blur-md shadow-2xl mb-8"
        >
          {/* Ambient glow */}
          <div
            className="absolute -top-20 -left-20 w-80 h-80 rounded-full blur-3xl opacity-20 pointer-events-none"
            style={{ background: "oklch(67.2% 0.191 39deg)" }}
          />

          <div className="relative z-10 p-6 md:p-8 flex flex-col md:flex-row gap-6 items-start md:items-center">
            {/* Poster */}
            <div className="flex-shrink-0">
              <div className="w-28 md:w-36 aspect-[2/3] rounded-2xl overflow-hidden shadow-2xl border border-white/10 relative">
                <img
                  src={posterUrl}
                  alt={seatsData?.movieTitle}
                  className="w-full h-full object-cover"
                />
                <div className="absolute inset-0 ring-1 ring-inset ring-white/10 rounded-2xl" />
              </div>
            </div>

            {/* Info */}
            <div className="flex-1 min-w-0 space-y-3">
              <div>
                <Badge
                  variant="outline"
                  className="text-primary border-primary/30 bg-primary/10 uppercase tracking-widest text-[10px] px-3 mb-2"
                >
                  <Clapperboard className="w-3 h-3 mr-1" />
                  Now Showing
                </Badge>
                <h1 className="text-2xl md:text-4xl font-black tracking-tight leading-tight">
                  {seatsData?.movieTitle}
                </h1>
              </div>

              <div className="flex flex-wrap gap-3 text-sm text-muted-foreground">
                <span className="flex items-center gap-1.5">
                  <MapPin className="w-4 h-4 text-primary/70" />
                  <span className="font-medium text-foreground/80">
                    {seatsData?.hallName}
                  </span>
                </span>
                <span className="flex items-center gap-1.5">
                  <Sparkles className="w-4 h-4 text-primary/70" />
                  <span className="font-medium text-foreground/80">
                    {seatsData?.hallType}
                  </span>
                </span>
                <span className="flex items-center gap-1.5">
                  <Calendar className="w-4 h-4 text-primary/70" />
                  <span className="font-medium text-foreground/80">
                    {formattedDate}
                  </span>
                </span>
              </div>
            </div>

            {/* Stats chips */}
            <div className="flex md:flex-col gap-2 flex-shrink-0">
              <div className="flex items-center gap-2 px-4 py-2 rounded-xl bg-white/5 border border-white/8 text-sm">
                <Ticket className="w-4 h-4 text-primary" />
                <span className="font-semibold">
                  {rows * seatsPerRow - bookedSet.size}
                </span>
                <span className="text-muted-foreground text-xs">available</span>
              </div>
              <div className="flex items-center gap-2 px-4 py-2 rounded-xl bg-white/5 border border-white/8 text-sm">
                <Clock className="w-4 h-4 text-primary" />
                <span className="font-semibold text-muted-foreground text-xs">
                  Select up to 10
                </span>
              </div>
            </div>
          </div>
        </motion.div>

        {/* ── Main grid: map + sidebar ── */}
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6 items-start">
          {/* ── Seat map ── */}
          <motion.div
            initial={{ opacity: 0, y: 32 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.15, duration: 0.5 }}
            className="lg:col-span-2 rounded-3xl border border-white/8 bg-card/50 backdrop-blur-md shadow-xl overflow-hidden"
          >
            {/* Screen */}
            <div className="px-8 pt-8 pb-4 flex flex-col items-center gap-2">
              <div
                className="w-full max-w-xl h-2 rounded-full"
                style={{
                  background:
                    "linear-gradient(90deg, transparent, oklch(67.2% 0.191 39deg / 60%), transparent)",
                  boxShadow: "0 4px 30px oklch(67.2% 0.191 39deg / 25%)",
                }}
              />
              <span className="text-[11px] uppercase tracking-[0.25em] text-muted-foreground font-medium mt-1">
                Screen
              </span>
            </div>

            {/* Seat grid */}
            <div className="px-4 md:px-8 pb-8 pt-2 overflow-x-auto">
              <div className="flex flex-col gap-1.5 min-w-max mx-auto w-fit">
                {Array.from({ length: rows }, (_, rowIdx) => {
                  const category =
                    seatsData!.rowCategoryMap[rowIdx + 1] ?? "Default";
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
                  const renderSeatCell = (
                    seatIdx: number,
                    invisible: boolean,
                  ) => {
                    const seatNum = seatIdx + 1;
                    const key = seatKey(rowIdx, seatNum);

                    // Invisible spacer (keeps alignment)
                    if (invisible) {
                      return (
                        <div
                          key={`sp-${key}`}
                          className="w-7 h-7 flex-shrink-0"
                        />
                      );
                    }

                    const isBooked = bookedSet.has(key);
                    const isSelected = selected.has(key);

                    if (isBooked) {
                      return (
                        <div
                          key={key}
                          title="Booked"
                          className="w-7 h-7 rounded-md bg-white/4 border border-white/8 flex items-center justify-center cursor-not-allowed"
                        >
                          <Armchair className="w-3.5 h-3.5 text-white/15" />
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
                            boxShadow:
                              "0 0 12px oklch(67.2% 0.191 39deg / 50%)",
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
                        <Armchair
                          className={`w-3.5 h-3.5 ${style.text} opacity-80`}
                        />
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
                        {Array.from(
                          { length: seatsPerRow - aisleAt },
                          (_, i) => {
                            const absIdx = aisleAt + i;
                            const rightCount = seatsPerRow - aisleAt;
                            return renderSeatCell(
                              absIdx,
                              i >= rightCount - skip,
                            );
                          },
                        )}
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

            {/* Legend */}
            <div className="border-t border-white/6 px-6 py-4 flex flex-wrap gap-x-6 gap-y-3">
              {/* Available per category */}
              {categories.map(([cat]) => {
                const style = getCategoryStyle(cat);
                return (
                  <div key={cat} className="flex items-center gap-2 text-xs">
                    <div
                      className={`w-5 h-5 rounded-sm border ${style.bg} ${style.border} flex items-center justify-center`}
                    >
                      <Armchair className={`w-3 h-3 ${style.text}`} />
                    </div>
                    <span className="text-muted-foreground">{cat}</span>
                  </div>
                );
              })}
              {/* Selected */}
              <div className="flex items-center gap-2 text-xs">
                <div
                  className="w-5 h-5 rounded-sm border flex items-center justify-center"
                  style={{
                    background: "oklch(67.2% 0.191 39deg / 80%)",
                    borderColor: "oklch(67.2% 0.191 39deg)",
                  }}
                >
                  <Armchair className="w-3 h-3 text-white" />
                </div>
                <span className="text-muted-foreground">Selected</span>
              </div>
              {/* Booked */}
              <div className="flex items-center gap-2 text-xs">
                <div className="w-5 h-5 rounded-sm border border-white/8 bg-white/4 flex items-center justify-center">
                  <Armchair className="w-3 h-3 text-white/15" />
                </div>
                <span className="text-muted-foreground">Booked</span>
              </div>
            </div>
          </motion.div>

          {/* ── Order Summary sidebar ── */}
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
                        const cat = seatsData!.rowCategoryMap[r] ?? "Default";
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
                            onClick={() => toggleSeat(k)}
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
                  <span className="font-medium text-foreground">
                    {seatsData?.hallName}
                  </span>
                </div>
                <div className="flex justify-between text-muted-foreground">
                  <span>Date</span>
                  <span className="font-medium text-foreground">
                    {seatsData?.startsAt
                      ? format(parseISO(seatsData.startsAt), "MMM d, yyyy")
                      : "—"}
                  </span>
                </div>
              </div>

              {/* CTA */}
              <div className="px-5 pb-5 pt-3">
                <motion.div whileTap={{ scale: 0.97 }}>
                  <Button
                    className="w-full rounded-2xl h-12 font-bold text-base relative overflow-hidden group"
                    disabled={selectedList.length === 0}
                    onClick={() => setConfirmed(true)}
                    style={
                      selectedList.length > 0
                        ? {
                            boxShadow:
                              "0 8px 32px oklch(67.2% 0.191 39deg / 35%)",
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
                    onClick={() => setSelected(new Set())}
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
        </div>
      </div>
    </div>
  );
};

export default ShowtimeSeats;
