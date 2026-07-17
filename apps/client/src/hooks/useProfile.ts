import { profileApi } from "@/api/profile.api";
import { queryKeys } from "@/api/queryKeys";
import { useAuth } from "@/hooks/useAuth";
import type { ProfileUpdateDto, ChangePasswordDto } from "@/types/profile";
import { useMutation, useQuery, useInfiniteQuery, useQueryClient } from "@tanstack/react-query";
import { toast } from "sonner";

export const useProfile = () => {
  const { isLoggedIn, isInitializing } = useAuth();

  return useQuery({
    queryKey: queryKeys.profile.get,
    queryFn: ({ signal }) => profileApi.getProfile({ signal }),
    enabled: isLoggedIn && !isInitializing,
  });
};

export const useUpdateProfile = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (dto: ProfileUpdateDto) => profileApi.updateProfile(dto),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: queryKeys.profile.get });
      toast.success("Profile updated successfully");
    },
    onError: () => {
      toast.error("Failed to update profile");
    },
  });
};

export const useChangePassword = () =>
  useMutation({
    mutationFn: (dto: ChangePasswordDto) => profileApi.changePassword(dto),
    onSuccess: () => {
      toast.success("Password changed successfully");
    },
    onError: () => {
      toast.error("Failed to change password. Check your current password.");
    },
  });

export const useBookingHistory = (pageSize: number = 10) => {
  const { isLoggedIn, isInitializing } = useAuth();

  return useInfiniteQuery({
    queryKey: queryKeys.profile.bookings,
    queryFn: ({ signal, pageParam }) => profileApi.getBookingHistory(pageParam, pageSize, { signal }),
    enabled: isLoggedIn && !isInitializing,
    getNextPageParam: (lastPage) => lastPage.hasMore ? lastPage.page + 1 : undefined,
    initialPageParam: 1,
  });
};
