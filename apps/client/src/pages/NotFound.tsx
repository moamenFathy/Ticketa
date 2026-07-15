import { Link } from "react-router-dom";
import { motion } from "framer-motion";
import { Button } from "@/components/ui/button";
import { Home, Ticket } from "lucide-react";

const NotFound = () => {
  return (
    <div className="min-h-[calc(100vh-4rem)] flex items-center justify-center px-4 bg-background">
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        className="text-center max-w-lg space-y-8"
      >
        <motion.div
          initial={{ scale: 0 }}
          animate={{ scale: 1 }}
          transition={{ type: "spring", stiffness: 200, delay: 0.1 }}
          className="mx-auto w-24 h-24 rounded-3xl bg-primary/10 border-2 border-primary/20 flex items-center justify-center"
        >
          <span className="text-5xl font-black text-primary">?</span>
        </motion.div>

        <div className="space-y-3">
          <h1 className="text-8xl font-black tracking-tighter text-primary">
            404
          </h1>
          <h2 className="text-2xl font-bold tracking-tight">
            Page not found
          </h2>
          <p className="text-muted-foreground max-w-sm mx-auto leading-relaxed">
            The preview has ended. This screen doesn't exist in our cinema.
            Let's get you back to the main feature.
          </p>
        </div>

        <div className="flex flex-col sm:flex-row gap-3 justify-center pt-4">
          <Button
            asChild
            className="h-12 px-8 rounded-2xl font-bold gap-2 shadow-lg shadow-primary/20"
          >
            <Link to="/">
              <Home className="w-4 h-4" />
              Go Home
            </Link>
          </Button>
          <Button
            asChild
            variant="outline"
            className="h-12 px-8 rounded-2xl font-bold gap-2"
          >
            <Link to="/showtimes">
              <Ticket className="w-4 h-4" />
              Browse Showtimes
            </Link>
          </Button>
        </div>
      </motion.div>
    </div>
  );
};

export default NotFound;
