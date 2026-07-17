import {
  CalendarIcon,
  ChevronRight,
  Clock,
  Loader2,
  MapPin,
  Receipt,
} from "lucide-react";
import { Button } from "./ui/button";
import { Skeleton } from "./ui/skeleton";
import { Card, CardContent, CardHeader, CardTitle } from "./ui/card";
import { TMDB_IMAGE_POSTER_URL } from "@/api/constants";
import { format } from "date-fns/format";
import { Badge } from "./ui/badge";
import { useEffect, useRef } from "react";
import { useBookingHistory } from "@/hooks/useProfile";
import { useNavigate } from "react-router-dom";

const BookingHistory = () => {
  const navigate = useNavigate();
  const {
    data: bookingData,
    isLoading: bookingsLoading,
    fetchNextPage: fetchNextBookingPage,
    hasNextPage: hasNextBookingPage,
    isFetchingNextPage: isFetchingNextBookingPage,
  } = useBookingHistory(10);

  const allBookings = bookingData?.pages.flatMap(p => p.items) ?? [];
  const sentinelRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const sentinel = sentinelRef.current;
    if (!sentinel) return;
    const observer = new IntersectionObserver(
      (entries) => {
        if (entries[0].isIntersecting && hasNextBookingPage && !isFetchingNextBookingPage) {
          fetchNextBookingPage();
        }
      },
      { rootMargin: "400px" },
    );
    observer.observe(sentinel);
    return () => observer.disconnect();
  }, [hasNextBookingPage, isFetchingNextBookingPage, fetchNextBookingPage]);

  return (
    <Card>
      <CardHeader>
        <CardTitle className="text-lg flex items-center gap-2">
          Booking History
        </CardTitle>
      </CardHeader>
      <CardContent>
        {bookingsLoading ? (
          <div className="space-y-3">
            {Array.from({ length: 3 }).map((_, i) => (
              <Skeleton key={i} className="h-20 w-full rounded-xl" />
            ))}
          </div>
        ) : allBookings.length === 0 ? (
          <div className="text-center py-12">
            <Receipt className="w-12 h-12 mx-auto text-muted-foreground/40 mb-3" />
            <p className="text-muted-foreground font-medium">No bookings yet</p>
            <Button
              variant="link"
              onClick={() => navigate("/showtimes")}
              className="mt-1"
            >
              Browse movies
            </Button>
          </div>
        ) : (
          <>
            <div className="space-y-3">
              {allBookings.map((booking) => (
                <div
                  key={booking.bookingReference}
                  className="flex items-center gap-4 p-4 rounded-xl border bg-card/50 hover:bg-accent/50 transition-colors cursor-pointer group"
                  onClick={() =>
                    navigate(`/bookings/${booking.bookingReference}`)
                  }
                >
                  {booking.moviePosterPath ? (
                    <img
                      src={`${TMDB_IMAGE_POSTER_URL}${booking.moviePosterPath}`}
                      alt={booking.movieTitle}
                      className="w-14 h-20 rounded-lg object-cover shadow-md"
                    />
                  ) : (
                    <div className="w-14 h-20 rounded-lg bg-muted flex items-center justify-center">
                      <Receipt className="w-5 h-5 text-muted-foreground" />
                    </div>
                  )}
                  <div className="flex-1 min-w-0">
                    <p className="font-bold truncate">{booking.movieTitle}</p>
                    <div className="flex items-center gap-3 text-xs text-muted-foreground mt-1">
                      <span className="flex items-center gap-1">
                        <CalendarIcon className="w-3 h-3" />
                        {format(new Date(booking.showtimeStartsAt), "MMM d")}
                      </span>
                      <span className="flex items-center gap-1">
                        <Clock className="w-3 h-3" />
                        {format(new Date(booking.showtimeStartsAt), "h:mm a")}
                      </span>
                      <span className="flex items-center gap-1">
                        <MapPin className="w-3 h-3" />
                        {booking.seatCount} seat
                        {booking.seatCount > 1 ? "s" : ""}
                      </span>
                    </div>
                    <div className="flex items-center gap-2 mt-1.5">
                      <Badge
                        variant={
                          booking.status === "Confirmed"
                            ? "default"
                            : "secondary"
                        }
                        className="text-[10px]"
                      >
                        {booking.status}
                      </Badge>
                      <span className="text-sm font-bold text-primary">
                        ${booking.totalAmount.toFixed(2)}
                      </span>
                    </div>
                  </div>
                  <ChevronRight className="w-5 h-5 text-muted-foreground group-hover:translate-x-0.5 transition-transform flex-shrink-0" />
                </div>
              ))}
            </div>

            <div ref={sentinelRef} className="flex justify-center py-6">
              {isFetchingNextBookingPage ? (
                <Loader2 className="w-6 h-6 animate-spin text-muted-foreground" />
              ) : !hasNextBookingPage ? (
                <p className="text-sm text-muted-foreground">
                  You've reached the end
                </p>
              ) : null}
            </div>
          </>
        )}
      </CardContent>
    </Card>
  );
};

export default BookingHistory;
