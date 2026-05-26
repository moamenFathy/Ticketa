import { motion } from "framer-motion";
import { Clock } from "lucide-react";
import { Badge } from "./ui/badge";
import { format } from "date-fns";
import type { Showtime } from "@/types/showtimes";

interface Props {
  showtime: Showtime;
  index: number;
}

const ShowtimesCards = ({ showtime, index }: Props) => {
  return (
    <motion.div
      key={showtime.id}
      initial={{ opacity: 0, y: 10 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ delay: index * 0.05 }}
    >
      <button className="w-full group cursor-pointer">
        <div className="flex items-center justify-between p-4 rounded-2xl bg-accent/50 group-hover:bg-primary transition-all duration-300 border border-white/5 group-hover:border-primary">
          <div className="flex items-center gap-4">
            <div className="bg-background group-hover:bg-white/20 p-3 rounded-xl transition-colors">
              <Clock className="w-5 h-5 text-primary group-hover:text-white" />
            </div>
            <div className="text-left">
              <p className="text-xl font-black group-hover:text-white">
                {format(new Date(showtime.startTime), "p")}
              </p>
              <div className="flex items-center gap-2 mt-1">
                <Badge
                  variant="outline"
                  className="text-[10px] text-primary border-primary/30 group-hover:text-white group-hover:border-white/30 uppercase tracking-widest px-2 py-0"
                >
                  {showtime.hallName}
                </Badge>
                <p className="text-xs text-muted-foreground group-hover:text-white/70">
                  Starts at {format(new Date(showtime.startTime), "p")}
                </p>
              </div>
            </div>
          </div>
          <div className="text-right">
            <p className="text-[10px] uppercase font-bold tracking-tighter text-muted-foreground group-hover:text-white/50">
              Starts from
            </p>
            <p className="text-lg font-bold group-hover:text-white">
              {showtime.price} $
            </p>
            <span className="text-[10px] uppercase font-black tracking-widest text-primary group-hover:text-white/80">
              Book Now
            </span>
          </div>
        </div>
      </button>
    </motion.div>
  );
};

export default ShowtimesCards;
