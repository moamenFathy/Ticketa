import { useParams } from "react-router-dom";
import { useGetBooking } from "@/hooks/useBooking";
import ErrorState from "@/components/ErrorState";
import { Skeleton } from "@/components/ui/skeleton";
import { Card } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Armchair, Calendar, Clock, MapPin, Receipt } from "lucide-react";
import { TMDB_IMAGE_POSTER_URL } from "@/api/constants";
import { format } from "date-fns";

const Scan = () => {
  const { reference } = useParams<{ reference: string }>();
  const {
    data: booking,
    isLoading,
    isError,
    refetch,
  } = useGetBooking(reference || "");

  if (isLoading) {
    return (
      <div className="min-h-[80vh] flex items-center justify-center p-6">
        <Card className="w-full max-w-md p-8 space-y-6">
          <Skeleton className="h-64 w-full rounded-xl" />
          <Skeleton className="h-8 w-3/4" />
          <div className="space-y-3 pt-4">
            <Skeleton className="h-4 w-full" />
            <Skeleton className="h-4 w-2/3" />
          </div>
        </Card>
      </div>
    );
  }

  if (isError || !booking) {
    return (
      <ErrorState
        refetch={refetch}
        title="Booking Not Found"
        message="The booking reference you scanned is invalid or no longer exists."
      />
    );
  }

  return (
    <div className="min-h-[80vh] flex flex-col items-center justify-center p-6 space-y-8">
      <h1 className="text-3xl font-black tracking-tight text-center">
        Your Ticket
      </h1>

      <div className="relative w-full max-w-md">
        {/* Decorative circles for ticket aesthetic */}
        <div className="absolute top-1/2 -left-4 w-8 h-8 rounded-full bg-background border border-border -translate-y-1/2 z-10" />
        <div className="absolute top-1/2 -right-4 w-8 h-8 rounded-full bg-background border border-border -translate-y-1/2 z-10" />

        <Card className="overflow-hidden border-2 shadow-2xl">
          <div className="relative aspect-[16/9] w-full">
            <img
              src={`${TMDB_IMAGE_POSTER_URL}${booking.moviePosterPath}`}
              alt={booking.movieTitle}
              className="w-full h-full object-cover"
            />
            <div className="absolute inset-0 bg-linear-to-r from-black/90 to-transparent" />
            <div className="absolute bottom-4 left-6 right-6">
              <h2 className="text-2xl font-black text-white">
                {booking.movieTitle}
              </h2>
              <Badge
                variant="secondary"
                className="mt-2 text-[10px] font-bold uppercase tracking-wider"
              >
                {booking.hallType}
              </Badge>
            </div>
          </div>

          <div className="p-6 space-y-6 bg-card">
            <div className="grid grid-cols-2 gap-y-4 gap-x-6">
              <div className="space-y-1">
                <label className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground flex items-center gap-1.5">
                  <Calendar className="w-3 h-3" /> Date
                </label>
                <p className="font-bold text-sm">
                  {format(new Date(booking.startsAt), "EEE, MMM d")}
                </p>
              </div>
              <div className="space-y-1">
                <label className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground flex items-center gap-1.5">
                  <Clock className="w-3 h-3" /> Time
                </label>
                <p className="font-bold text-sm">
                  {format(new Date(booking.startsAt), "h:mm a")}
                </p>
              </div>
              <div className="space-y-1">
                <label className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground flex items-center gap-1.5">
                  <MapPin className="w-3 h-3" /> Location
                </label>
                <p className="font-bold text-sm">{booking.hallName}</p>
              </div>
              <div className="space-y-1">
                <label className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground flex items-center gap-1.5">
                  <Receipt className="w-3 h-3" /> Total
                </label>
                <p className="font-bold text-sm text-primary">
                  ${booking.totalAmount.toFixed(2)}
                </p>
              </div>
            </div>

            <div className="pt-4 border-t border-dashed border-muted flex items-start gap-4">
              <div className="bg-primary/10 p-2.5 rounded-xl">
                <Armchair className="w-5 h-5 text-primary" />
              </div>
              <div className="space-y-1">
                <label className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground">
                  Selected Seats ({booking.seats.length})
                </label>
                <div className="flex flex-wrap gap-1.5 mt-1">
                  {booking.seats.map((seat, index) => (
                    <Badge
                      key={index}
                      variant="outline"
                      className="font-mono text-xs font-bold border-primary/30 text-primary"
                    >
                      {String.fromCharCode(65 + seat.row)}
                      {seat.seatNumber}
                    </Badge>
                  ))}
                </div>
              </div>
            </div>

            <div className="pt-2 text-center">
              <p className="text-[10px] font-mono text-muted-foreground mt-2">
                REF: {booking.bookingReference}
              </p>
            </div>
          </div>
        </Card>
      </div>
    </div>
  );
};

export default Scan;
