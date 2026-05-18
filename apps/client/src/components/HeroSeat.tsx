import { motion } from "framer-motion";
import {
  Calendar,
  Clapperboard,
  Clock,
  MapPin,
  Sparkles,
  Ticket,
} from "lucide-react";
import { Badge } from "./ui/badge";
import { format, parseISO } from "date-fns";

interface Props {
  posterUrl: string;
  movieTitle: string;
  hallName: string;
  hallType: string;
  startAt: string;
  availableSeats: number;
}

const HeroSeat = ({
  posterUrl,
  movieTitle,
  hallName,
  hallType,
  startAt,
  availableSeats,
}: Props) => {
  const formattedDate = startAt
    ? format(parseISO(startAt), "EEE, MMM d • h:mm a")
    : "";
  return (
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
              alt={movieTitle}
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
              {movieTitle}
            </h1>
          </div>

          <div className="flex flex-wrap gap-3 text-sm text-muted-foreground">
            <span className="flex items-center gap-1.5">
              <MapPin className="w-4 h-4 text-primary/70" />
              <span className="font-medium text-foreground/80">{hallName}</span>
            </span>
            <span className="flex items-center gap-1.5">
              <Sparkles className="w-4 h-4 text-primary/70" />
              <span className="font-medium text-foreground/80">{hallType}</span>
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
            <span className="font-semibold">{availableSeats}</span>
            {/* {rows * seatsPerRow - bookedSet.size} */}
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
  );
};

export default HeroSeat;
