import { AlertCircle, RefreshCw } from "lucide-react";
import { Button } from "./ui/button";

const ErrorState = ({ refetch }: { refetch: () => void }) => (
  <div className="flex flex-col items-center justify-center min-h-100 p-6 text-center">
    <div className="bg-destructive/10 p-4 rounded-full mb-4">
      <AlertCircle className="w-10 h-10 text-destructive" />
    </div>
    <h2 className="text-2xl font-bold tracking-tight mb-2">
      Something went wrong
    </h2>
    <p className="text-muted-foreground max-w-100 mb-6">
      We couldn't load the movies. Please check your internet connection and try
      again.
    </p>
    <Button onClick={() => refetch()} className="gap-2">
      <RefreshCw className="w-4 h-4" />
      Try Again
    </Button>
  </div>
);

export default ErrorState;
