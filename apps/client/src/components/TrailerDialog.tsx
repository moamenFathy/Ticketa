import { motion } from "framer-motion";
import { Button } from "./ui/button";

interface Props {
  trailerKey: string;
  setIsVideoVisible: (visible: boolean) => void;
}

const TrailerDialog = ({ trailerKey, setIsVideoVisible }: Props) => {
  return (
    <motion.div
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0 }}
      className="fixed inset-0 z-[100] bg-black/95 backdrop-blur-2xl flex items-center justify-center p-4 lg:p-20"
      onClick={() => setIsVideoVisible(false)}
    >
      <motion.div
        initial={{ scale: 0.9, opacity: 0 }}
        animate={{ scale: 1, opacity: 1 }}
        exit={{ scale: 0.9, opacity: 0 }}
        className="relative w-full max-w-6xl aspect-video rounded-[2rem] overflow-hidden shadow-2xl border border-white/10"
        onClick={(e) => e.stopPropagation()}
      >
        <iframe
          className="w-full h-full"
          src={`https://www.youtube.com/embed/${trailerKey}?autoplay=1`}
          title="Movie Trailer"
          allow="autoplay; encrypted-media"
          frameBorder="0"
        />
        <Button
          onClick={() => setIsVideoVisible(false)}
          className="absolute top-10 right-6 w-12 h-12 rounded-full bg-white/10 hover:bg-white/20 border border-white/10 backdrop-blur-xl p-0 text-white"
        >
          ✕
        </Button>
      </motion.div>
    </motion.div>
  );
};

export default TrailerDialog;
