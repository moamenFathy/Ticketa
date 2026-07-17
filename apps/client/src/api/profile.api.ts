import type { ProfileDto, ProfileUpdateDto, ChangePasswordDto, BookingHistoryItemDto } from "@/types/profile";
import type { PagedResultDto } from "@/types/api";
import api from "./client";

export const profileApi = {
  getProfile: ({ signal }: { signal?: AbortSignal }) =>
    api.get<ProfileDto>("profile", { signal }).then((res) => res.data),

  updateProfile: (dto: ProfileUpdateDto) =>
    api.put("profile", dto),

  changePassword: (dto: ChangePasswordDto) =>
    api.put("profile/password", dto),

  getBookingHistory: (page: number, pageSize: number, { signal }: { signal?: AbortSignal }) =>
    api.get<PagedResultDto<BookingHistoryItemDto>>("profile/bookings", {
      params: { page, pageSize },
      signal,
    }).then((res) =>  res.data)
};
