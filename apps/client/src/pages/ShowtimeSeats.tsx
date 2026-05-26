import { useGetSeatsForShowtime } from "@/hooks/useShowtimes";
import { useCreateBooking } from "@/hooks/useBooking";
import { useParams, useLocation } from "react-router-dom";
import ShowtimeSeatsSkeleton from "@/components/skeletons/ShowtimeSeatsSkeleton";
import { motion } from "framer-motion";
import { useState, useMemo, useCallback } from "react";
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
import type { BookingResultDto } from "@/types/bookings";
import type { ApiError } from "@/types/api";
import { isConflictError } from "@/api/errors";
import { useAuth } from "@/hooks/useAuth";

// ─── Main Component ──────────────────────────────────────────────────────────
const ShowtimeSeats = () => {
  const { id } = useParams();
  const navigate = useNavigate();
  const location = useLocation();
  const { isLoggedIn } = useAuth();
  const {
    data: seatsData,
    isLoading,
    isError,
    refetch,
  } = useGetSeatsForShowtime(id!);

  const createBooking = useCreateBooking();

  const [selected, setSelected] = useState<Set<string>>(new Set());
  const [confirmed, setConfirmed] = useState(false);
  const [bookingResult, setBookingResult] = useState<BookingResultDto | null>(
    null,
  );
  const [bookingError, setBookingError] = useState<string | null>(null);

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
      if (!seen.has(cat)) seen.set(cat, rowLabel(Number(rowIdx) - 1));
    });

    return Array.from(seen.entries());
  }, [seatsData]);

  const selectedList = useMemo(() => Array.from(selected), [selected]);

  const handleConfirm = useCallback(() => {
    if (selectedList.length === 0) return;

    if (!isLoggedIn) {
      navigate(`/login?returnUrl=${encodeURIComponent(location.pathname)}`);
      return;
    }

    setBookingError(null);

    const seats = selectedList.map((k) => {
      const [row, seatNumber] = k.split("-").map(Number);
      return { row: row + 1, seatNumber };
    });

    createBooking.mutate(
      { showtimeId: Number(id!), seats },
      {
        onSuccess: (data) => {
          setBookingResult(data);
          setConfirmed(true);
        },
        onError: (error) => {
          const apiError = error as unknown as ApiError;
          if (isConflictError(apiError)) {
            if (apiError.conflictingSeats?.length) {
              const conflictKeys = apiError.conflictingSeats.map((s) =>
                seatKey(s.row - 1, s.seatNumber),
              );
              setSelected((prev) => {
                const next = new Set(prev);
                conflictKeys.forEach((k) => next.delete(k));
                return next;
              });
              setBookingError(
                `${conflictKeys.length} seat(s) were already booked and have been removed.`,
              );
            } else {
              setBookingError(
                apiError.message ??
                  "Some seats are no longer available. Please try again.",
              );
            }
          } else {
            setBookingError(
              apiError.message ?? "Booking failed. Please try again.",
            );
          }
        },
      },
    );
  }, [selectedList, id, createBooking, isLoggedIn, navigate, location]);

  if (isLoading) return <ShowtimeSeatsSkeleton />;

  if (isError || !seatsData) {
    return (
      <ErrorState
        refetch={refetch}
        title="Unable to load seats"
        message="We couldn't retrieve the seating plan for this showtime. Please try again later."
      />
    );
  }

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
        bookingReference={bookingResult?.bookingReference}
        totalAmount={bookingResult?.totalAmount}
        onClick={() => {
          setSelected(new Set());
          setConfirmed(false);
          setBookingResult(null);
          setBookingError(null);
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
        <div className="absolute inset-0 bg-linear-to-b from-background/80 via-background/60 to-background" />
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
            className="flex items-center gap-2 text-muted-foreground hover:text-foreground transition-colors group cursor-pointer"
          >
            <ChevronLeft className="w-4 h-4 group-hover:-translate-x-1 transition-transform" />
            <span className="text-sm font-medium">Back</span>
          </button>
        </motion.div>

        {/* ── Hero card ── */}
        <HeroSeat
          movieId={seatsData.movieId}
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
            onConfirm={handleConfirm}
            onClear={() => {
              setSelected(new Set());
              setBookingError(null);
            }}
            isBooking={createBooking.isPending}
            bookingError={bookingError}
            onDismissError={() => setBookingError(null)}
          />
        </div>
      </div>
    </div>
  );
};

export default ShowtimeSeats;
