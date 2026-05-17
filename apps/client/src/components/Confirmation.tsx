import { motion } from "framer-motion";
import { Button } from "./ui/button";
import { CheckCircle2, ChevronLeft } from "lucide-react";
import { useNavigate } from "react-router-dom";

interface Props {
  selectedList: string[];
  movieTitle: string;
  rowLabel: (row: number) => string;
  onClick: () => void;
}

const Confirmation = ({
  selectedList,
  movieTitle,
  rowLabel,
  onClick,
}: Props) => {
  const navigate = useNavigate();
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
            <span className="text-foreground font-semibold">{movieTitle}</span>
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
          <Button className="rounded-full" onClick={onClick}>
            Book More
          </Button>
        </div>
      </motion.div>
    </div>
  );
};

export default Confirmation;
