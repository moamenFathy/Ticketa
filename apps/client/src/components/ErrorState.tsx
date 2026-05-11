import { Clapperboard, RefreshCw } from "lucide-react";
import { Button } from "./ui/button";

const ErrorState = ({ refetch }: { refetch: () => void }) => (
  <div className="flex flex-col items-center justify-center min-h-screen p-6 text-center bg-white dark:bg-[#080a0f] text-black dark:text-white">
    <div className="bg-red-500/10 p-8 rounded-full mb-8 shadow-2xl shadow-red-500/20">
      <Clapperboard className="w-16 h-16 text-red-500" />
    </div>
    <h2 className="text-4xl font-black tracking-tight mb-4 italic">
      Film Reel Interrupted
    </h2>
    <p className="text-black/40 dark:text-white/40 max-w-md mb-10 font-medium text-lg leading-relaxed">
      We couldn't retrieve the cinematic data for this title. Check your
      connection to the projector.
    </p>
    <Button
      onClick={() => refetch()}
      className="gap-3 h-14 px-10 rounded-2xl font-black text-lg bg-primary hover:bg-primary/90 shadow-lg shadow-primary/20 text-white"
    >
      <RefreshCw className="w-5 h-5" />
      Retry Projection
    </Button>
  </div>
);

export default ErrorState;
