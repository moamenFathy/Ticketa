export type ApiError = {
  code: string;
  message: string;
  status?: number;
  details?: unknown;
  conflictingSeats?: { row: number; seatNumber: number }[];
};

export type PagedResultDto<T> = {
  items: T[];
  page: number;
  pageSize: number;
  totalCount: number;
  hasMore: boolean;
};