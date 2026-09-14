import { confirmPayment, createIntent } from "@/api/payments.api"
import { useMutation } from "@tanstack/react-query"

export const useCreatePaymentIntent = () => {
  return useMutation({
    mutationFn: createIntent
  })
}

export const useConfirmPayment= () => {
  return useMutation({
    mutationFn: confirmPayment
  })
}