import type { BookingCreateDto, BookingConfirmationState } from "@/types/bookings";
import type { ConfirmPaymentDto, PaymentIntentResultDto } from "@/types/payment";
import client from "./client";

export async function createIntent(dto: BookingCreateDto) {
  return client.post<PaymentIntentResultDto>("payments/create-intent", dto).then((r) => r.data);
}

export async function confirmPayment(dto: ConfirmPaymentDto) {
  return client.post<BookingConfirmationState>("payments/confirm-payment", dto).then((r) => r.data);
}