import { useGetSeatsForShowtime } from "@/hooks/useShowtimes";
import { useParams } from "react-router-dom";
import ShowtimeSkeleton from "@/components/skeletons/ShowtimeSkeleton";
import { Button } from "@/components/ui/button";
import { format, parseISO } from "date-fns";
import { motion, AnimatePresence } from "framer-motion";
import { useState, useMemo } from "react";
import {
  Armchair,
  ChevronLeft,
  ShoppingCart,
  Sparkles,
  Star,
  Ticket,
  X,
} from "lucide-react";
import { useNavigate } from "react-router-dom";
import ErrorState from "@/components/ErrorState";
import Confirmation from "@/components/Confirmation";
import HeroSeat from "@/components/HeroSeat";
import { TMDB_IMAGE_POSTER_URL } from "@/api/constants";
import { getCategoryStyle, rowLabel, seatKey } from "@/lib/utils";
import SeatGrid from "@/components/SeatGrid";

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

  if (isError || !seatsData) return <ErrorState refetch={refetch} />;

  const rows = seatsData.rows;
  const seatsPerRow = seatsData.seatsPerRow;
  const posterUrl = seatsData.moviePosterPath
    ? `${TMDB_IMAGE_POSTER_URL}${seatsData.moviePosterPath}`
    : "/poster-placeholder.png";

  const formattedDate = seatsData?.startsAt
    ? format(parseISO(seatsData.startsAt), "EEE, MMM d • h:mm a")
    : "";

  // ── Confirmation overlay ─────────────────────────────────────────────────
  if (confirmed) {
    return (
      <Confirmation
        movieTitle={seatsData?.movieTitle || ""}
        rowLabel={rowLabel}
        selectedList={selectedList}
        onClick={() => {
          setSelected(new Set());
          setConfirmed(false);
        }}
      />
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
        <HeroSeat
          posterUrl={posterUrl}
          movieTitle={seatsData?.movieTitle || ""}
          hallName={seatsData?.hallName || ""}
          hallType={seatsData?.hallType || ""}
          formattedDate={formattedDate}
          availableSeats={rows * seatsPerRow - bookedSet.size}
        />

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
            <SeatGrid
              bookedSet={bookedSet}
              rows={rows}
              seatsPerRow={seatsPerRow}
              selected={selected}
              toggleSeat={toggleSeat}
              seatsData={seatsData!}
            />
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
