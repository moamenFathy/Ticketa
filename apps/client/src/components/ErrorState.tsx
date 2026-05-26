import { AlertCircle, RefreshCw } from "lucide-react";
import { Button } from "./ui/button";
import { motion } from "framer-motion";

interface ErrorStateProps {
  refetch: () => void;
  title?: string;
  message?: string;
}

const ErrorState = ({
  refetch,
  title = "Something went wrong",
  message = "We couldn't load the information. Please check your internet connection and try again.",
}: ErrorStateProps) => (
  <motion.div
    initial={{ opacity: 0, y: 20 }}
    animate={{ opacity: 1, y: 0 }}
    className="flex flex-col items-center justify-center min-h-screen p-6 text-center"
  >
    <div className="bg-destructive/10 p-4 rounded-full mb-4">
      <AlertCircle className="w-10 h-10 text-destructive" />
    </div>
    <h2 className="text-2xl font-bold tracking-tight mb-2">{title}</h2>
    <p className="text-muted-foreground max-w-100 mb-6">{message}</p>
    <Button onClick={() => refetch()} className="gap-2">
      <RefreshCw className="w-4 h-4" />
      Try Again
    </Button>
  </motion.div>
);

export default ErrorState;
