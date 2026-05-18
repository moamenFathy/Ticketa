import { useGetSeatsForShowtime } from "@/hooks/useShowtimes";
import { useParams } from "react-router-dom";
import ShowtimeSkeleton from "@/components/skeletons/ShowtimeSkeleton";
import { motion } from "framer-motion";
import { useState, useMemo } from "react";
import { ChevronLeft } from "lucide-react";
import { useNavigate } from "react-router-dom";
import ErrorState from "@/components/ErrorState";
import Confirmation from "@/components/Confirmation";
import HeroSeat from "@/components/HeroSeat";
import { TMDB_IMAGE_POSTER_URL } from "@/api/constants";
import { rowLabel, seatKey } from "@/lib/utils";
import SeatGrid from "@/components/SeatGrid";
import Legend from "@/components/Legend";
import OrderSummarySidebar from "@/components/OrderSummarySidebar";

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

  // ── Confirmation overlay ─────────────────────────────────────────────────
  if (confirmed) {
    return (
      <Confirmation
        movieTitle={seatsData.movieTitle}
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
          movieTitle={seatsData.movieTitle}
          hallName={seatsData.hallName}
          hallType={seatsData.hallType}
          startAt={seatsData.startsAt}
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
              seatsData={seatsData}
            />
            {/* Legend */}
            <Legend categories={categories} />
          </motion.div>

          {/* ── Order Summary sidebar ── */}
          <OrderSummarySidebar
            hallName={seatsData.hallName}
            startsAt={seatsData.startsAt}
            selectedList={selectedList}
            rowCategoryMap={seatsData.rowCategoryMap}
            onToggleSeat={toggleSeat}
            onConfirm={() => setConfirmed(true)}
            onClear={() => setSelected(new Set())}
          />
        </div>
      </div>
    </div>
  );
};

export default ShowtimeSeats;
