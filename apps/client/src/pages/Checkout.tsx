import { useLocation, useNavigate } from "react-router-dom";
import { loadStripe } from "@stripe/stripe-js";
import { Elements } from "@stripe/react-stripe-js";
import CheckoutForm from "@/components/CheckoutForm";
import { useEffect, useState } from "react";
import { motion } from "framer-motion";
import { ChevronLeft } from "lucide-react";
import { Button } from "@/components/ui/button";
import Confirmation from "@/components/Confirmation";
import { rowLabel } from "@/lib/utils";
import { useQueryClient } from "@tanstack/react-query";
import { queryKeys } from "@/api/queryKeys";

const stripePromise = loadStripe(import.meta.env.VITE_STRIPE_PUBLIC_KEY, {
  developerTools: {
    assistant: {
      enabled: false,
    },
  },
});

const Checkout = () => {
  const location = useLocation();
  const navigate = useNavigate();
  const state = location.state as {
    clientSecret: string;
    paymentIntentId: string;
    totalAmount: number;
    selectedList: string[];
    movieTitle: string;
    showtimeId: string;
  };

  const [confirmed, setConfirmed] = useState(false);
  const [bookingReference, setBookingReference] = useState("");
  const queryClient = useQueryClient();

  useEffect(() => {
    if (!state?.clientSecret) {
      navigate("/");
    }
  }, [state, navigate]);

  if (!state?.clientSecret) return null;

  const appearance = {
    theme: "night" as const,
    labels: "floating" as const,
    variables: {
      colorPrimary: "oklch(67.2% 0.191 39deg)",
      colorBackground: "#0a0a0a",
      colorText: "#ffffff",
      colorDanger: "#ef4444",
      fontFamily: "Inter, system-ui, sans-serif",
      spacingUnit: "4px",
      borderRadius: "8px",
    },
  };

  const options = {
    clientSecret: state.clientSecret,
    appearance,
    wallets: {
      applePay: "auto",
      googlePay: "auto",
    },
  };

  if (confirmed) {
    return (
      <Confirmation
        movieTitle={state.movieTitle}
        rowLabel={rowLabel}
        selectedList={state.selectedList}
        bookingReference={bookingReference}
        totalAmount={state.totalAmount}
        onClick={() => navigate("/")}
      />
    );
  }

  return (
    <div className="min-h-screen bg-background text-foreground py-12">
      <div className="container max-w-2xl mx-auto px-4">
        <Button
          variant="ghost"
          className="mb-8 group"
          onClick={() => navigate(-1)}
        >
          <ChevronLeft className="mr-2 h-4 w-4 transition-transform group-hover:-translate-x-1" />
          Back to seats
        </Button>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          className="bg-card border border-border rounded-3xl p-8 shadow-2xl"
        >
          <div className="mb-8">
            <h1 className="text-3xl font-black mb-2">Checkout</h1>
            <p className="text-muted-foreground">
              Complete your booking for{" "}
              <span className="text-foreground font-semibold">
                {state.movieTitle}
              </span>
            </p>
          </div>

          <div className="bg-muted/30 rounded-2xl p-6 mb-8 flex justify-between items-center">
            <div>
              <p className="text-sm text-muted-foreground mb-1">Total Amount</p>
              <p className="text-3xl font-bold">
                ${state.totalAmount.toFixed(2)}
              </p>
            </div>
            <div className="text-right">
              <p className="text-sm text-muted-foreground mb-1">Seats</p>
              <p className="text-lg font-medium">{state.selectedList.length}</p>
            </div>
          </div>

          <Elements stripe={stripePromise} options={options}>
            <CheckoutForm
              paymentIntentId={state.paymentIntentId}
              onSuccess={(ref) => {
                queryClient.invalidateQueries({
                  queryKey: queryKeys.showtimes.getSeatsForShowtime(
                    state.showtimeId,
                  ),
                });
                setBookingReference(ref);
                setConfirmed(true);
              }}
            />
          </Elements>
        </motion.div>
      </div>
    </div>
  );
};

export default Checkout;
