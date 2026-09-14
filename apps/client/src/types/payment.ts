export type PaymentIntentResultDto = {
  clientSecret: string;
  paymentIntentId: string;
  totalAmount: number;
}

export type ConfirmPaymentDto = {
  paymentIntentId: string;
}

export type PaymentPageState = {
  clientSecret: string;
  paymentIntentId: string;
  totalAmount: number;
}