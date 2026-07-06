import {
  CalendarIcon,
  ChevronDown,
  ChevronRight,
  Clock,
  MapPin,
  Receipt,
} from "lucide-react";
import { Button } from "./ui/button";
import { Skeleton } from "./ui/skeleton";
import { Card, CardContent, CardHeader, CardTitle } from "./ui/card";
import { TMDB_IMAGE_POSTER_URL } from "@/api/constants";
import { format } from "date-fns/format";
import { Badge } from "./ui/badge";
import { useState } from "react";
import { useBookingHistory } from "@/hooks/useProfile";
import { useNavigate } from "react-router-dom";

const BookingHistory = () => {
  const navigate = useNavigate();
  const [bookingPage, setBookingPage] = useState(1);
  const { data: bookingData, isLoading: bookingsLoading } =
    useBookingHistory(bookingPage);

  const allBookings = bookingData?.items ?? [];
  const hasMore = bookingData?.hasMore ?? false;

  return (
    <Card>
      <CardHeader>
        <CardTitle className="text-lg flex items-center gap-2">
          Booking History
        </CardTitle>
      </CardHeader>
      <CardContent>
        {bookingsLoading && bookingPage === 1 ? (
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

            {hasMore && (
              <div className="flex justify-center mt-6">
                <Button
                  variant="outline"
                  onClick={() => setBookingPage((p) => p + 1)}
                  disabled={bookingsLoading}
                  className="gap-2"
                >
                  {bookingsLoading ? (
                    "Loading..."
                  ) : (
                    <>
                      Load More <ChevronDown className="w-4 h-4" />
                    </>
                  )}
                </Button>
              </div>
            )}
          </>
        )}
      </CardContent>
    </Card>
  );
};

export default BookingHistory;
