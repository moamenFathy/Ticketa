import { useState } from "react";
import {
  useStripe,
  useElements,
  PaymentElement,
} from "@stripe/react-stripe-js";
import { Button } from "./ui/button";
import { useConfirmPayment } from "@/hooks/usePayment";
import type { BookingConfirmationState } from "@/types/bookings";
import { toast } from "sonner";
import { Loader2 } from "lucide-react";

interface Props {
  paymentIntentId: string;
  onSuccess: (bookingReference: string) => void;
}

const CheckoutForm = ({ paymentIntentId, onSuccess }: Props) => {
  const stripe = useStripe();
  const elements = useElements();
  const confirmPayment = useConfirmPayment();
  const [isProcessing, setIsProcessing] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    if (!stripe || !elements) return;

    setIsProcessing(true);

    const { error, paymentIntent } = await stripe.confirmPayment({
      elements,
      redirect: "if_required",
    });

    if (error) {
      toast.error(
        error.message ||
          "Sorry the seat has already been booked. Please try again.",
      );
      setIsProcessing(false);
      return;
    }

    if (paymentIntent.status === "succeeded") {
      confirmPayment.mutate(
        { paymentIntentId },
        {
          onSuccess: (data: BookingConfirmationState) => {
            onSuccess(data.bookingReference);
          },
          onError: () => {
            toast.error(
              "Payment confirmed but booking failed. Please contact support.",
            );
          },
          onSettled: () => {
            setIsProcessing(false);
          },
        },
      );
    }
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-6">
      <PaymentElement />
      <Button
        type="submit"
        disabled={isProcessing || !stripe || !elements}
        className="w-full h-12 text-lg font-bold"
      >
        {isProcessing ? (
          <>
            <Loader2 className="mr-2 h-5 w-5 animate-spin" />
            Processing...
          </>
        ) : (
          "Pay Now"
        )}
      </Button>
    </form>
  );
};

export default CheckoutForm;
