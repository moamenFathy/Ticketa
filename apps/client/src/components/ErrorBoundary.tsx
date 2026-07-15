import { Component } from "react";
import { Button } from "./ui/button";
import { AlertTriangle } from "lucide-react";

interface Props {
  children: React.ReactNode;
}

interface State {
  hasError: boolean;
  error: Error | null;
}

export class ErrorBoundary extends Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = { hasError: false, error: null };
  }

  static getDerivedStateFromError(error: Error): State {
    return { hasError: true, error };
  }

  render() {
    if (this.state.hasError) {
      return (
        <div className="min-h-screen flex items-center justify-center px-4 bg-background">
          <div className="text-center max-w-md space-y-6">
            <div className="mx-auto w-20 h-20 rounded-3xl bg-destructive/10 flex items-center justify-center">
              <AlertTriangle className="w-10 h-10 text-destructive" />
            </div>
            <h1 className="text-3xl font-black tracking-tight">Something went wrong</h1>
            <p className="text-muted-foreground">
              {this.state.error?.message || "An unexpected error occurred."}
            </p>
            <Button
              onClick={() => {
                this.setState({ hasError: false, error: null });
                window.location.href = "/";
              }}
              className="rounded-2xl px-8 h-12 font-bold"
            >
              Go Home
            </Button>
          </div>
        </div>
      );
    }

    return this.props.children;
  }
}
