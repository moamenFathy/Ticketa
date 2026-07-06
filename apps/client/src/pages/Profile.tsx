import { useAuth } from "@/hooks/useAuth";
import {
  useProfile,
  useUpdateProfile,
  useChangePassword,
  useBookingHistory,
} from "@/hooks/useProfile";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";
import { Skeleton } from "@/components/ui/skeleton";
import { Badge } from "@/components/ui/badge";
import ErrorState from "@/components/ErrorState";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import {
  CalendarIcon,
  ChevronDown,
  ChevronRight,
  Clock,
  MapPin,
  Receipt,
} from "lucide-react";
import { format } from "date-fns";
import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { TMDB_IMAGE_POSTER_URL } from "@/api/constants";
import { Calendar } from "@/components/ui/calendar";
import {
  Popover,
  PopoverContent,
  PopoverTrigger,
} from "@/components/ui/popover";
import { cn } from "@/lib/utils";
import { motion } from "framer-motion";

const profileSchema = z.object({
  firstName: z.string().min(1, "First name is required").max(50),
  lastName: z.string().min(1, "Last name is required").max(50),
  dateOfBirth: z.string().min(1, "Date of birth is required"),
  theme: z.string(),
});

const passwordSchema = z
  .object({
    currentPassword: z.string().min(1, "Current password is required"),
    newPassword: z.string().min(8, "Password must be at least 8 characters"),
    confirmNewPassword: z.string().min(1, "Please confirm your password"),
  })
  .refine((data) => data.newPassword === data.confirmNewPassword, {
    message: "Passwords do not match.",
    path: ["confirmNewPassword"],
  });

type ProfileFormData = z.infer<typeof profileSchema>;
type PasswordFormData = z.infer<typeof passwordSchema>;

const Profile = () => {
  const { isLoggedIn, isInitializing } = useAuth();
  const navigate = useNavigate();
  const { data: profile, isLoading, isError, refetch } = useProfile();
  const updateProfile = useUpdateProfile();
  const changePassword = useChangePassword();
  const [bookingPage, setBookingPage] = useState(1);
  const { data: bookingData, isLoading: bookingsLoading } =
    useBookingHistory(bookingPage);
  const [showPasswordForm, setShowPasswordForm] = useState(false);
  const [dobOpen, setDobOpen] = useState(false);

  const profileForm = useForm<ProfileFormData>({
    resolver: zodResolver(profileSchema),
    values: profile
      ? {
          firstName: profile.firstName,
          lastName: profile.lastName,
          dateOfBirth: profile.dateOfBirth,
          theme: profile.theme,
        }
      : undefined,
  });

  const passwordForm = useForm<PasswordFormData>({
    resolver: zodResolver(passwordSchema),
  });

  const onProfileSubmit = (data: ProfileFormData) => {
    updateProfile.mutate(data);
  };

  const onPasswordSubmit = (data: PasswordFormData) => {
    changePassword.mutate(data, {
      onSuccess: () => {
        passwordForm.reset();
        setShowPasswordForm(false);
      },
    });
  };

  if (isInitializing) return null;
  if (!isLoggedIn) {
    navigate("/login?returnUrl=/profile", { replace: true });
    return null;
  }

  if (isLoading) {
    return (
      <div className="container mx-auto px-4 py-8 max-w-4xl space-y-8">
        <Skeleton className="h-8 w-48" />
        <Card>
          <CardContent className="p-6 space-y-4">
            <Skeleton className="h-10 w-full" />
            <Skeleton className="h-10 w-full" />
            <Skeleton className="h-10 w-1/2" />
          </CardContent>
        </Card>
      </div>
    );
  }

  if (isError || !profile) {
    return (
      <ErrorState
        refetch={refetch}
        title="Unable to load profile"
        message="We couldn't load your profile. Please try again."
      />
    );
  }

  const allBookings = bookingData?.items ?? [];
  const hasMore = bookingData?.hasMore ?? false;

  return (
    <div className="container mx-auto px-4 py-8 max-w-4xl space-y-8">
      <div>
        <h1 className="text-3xl font-black tracking-tight">My Profile</h1>
        <p className="text-muted-foreground mt-1">
          Manage your account details and view your booking history.
        </p>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <div className="lg:col-span-2 space-y-6">
          <motion.div
            initial={{ opacity: 0, y: 16 }}
            animate={{ opacity: 1, y: 0 }}
          >
            <Card>
              <CardHeader>
                <CardTitle className="text-lg flex items-center gap-2">
                  Personal Information
                </CardTitle>
              </CardHeader>
              <CardContent>
                <form
                  onSubmit={profileForm.handleSubmit(onProfileSubmit)}
                  className="space-y-4"
                >
                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <div className="space-y-2">
                      <Label htmlFor="firstName">First Name</Label>
                      <Input
                        id="firstName"
                        {...profileForm.register("firstName")}
                      />
                      {profileForm.formState.errors.firstName && (
                        <p className="text-sm text-destructive">
                          {profileForm.formState.errors.firstName.message}
                        </p>
                      )}
                    </div>
                    <div className="space-y-2">
                      <Label htmlFor="lastName">Last Name</Label>
                      <Input
                        id="lastName"
                        {...profileForm.register("lastName")}
                      />
                      {profileForm.formState.errors.lastName && (
                        <p className="text-sm text-destructive">
                          {profileForm.formState.errors.lastName.message}
                        </p>
                      )}
                    </div>
                  </div>

                  <div className="space-y-2">
                    <Label>Email</Label>
                    <Input
                      value={profile.email}
                      disabled
                      className="opacity-60"
                    />
                    <p className="text-xs text-muted-foreground">
                      Email cannot be changed.
                    </p>
                  </div>

                  <div className="space-y-2">
                    <Label>Date of Birth</Label>
                    <Popover open={dobOpen} onOpenChange={setDobOpen}>
                      <PopoverTrigger asChild>
                        <Button
                          variant="outline"
                          className={cn(
                            "w-full justify-start text-left font-normal",
                            !profileForm.watch("dateOfBirth") &&
                              "text-muted-foreground",
                          )}
                        >
                          <CalendarIcon className="mr-2 h-4 w-4" />
                          {profileForm.watch("dateOfBirth")
                            ? format(
                                new Date(profileForm.watch("dateOfBirth")),
                                "PPP",
                              )
                            : "Pick a date"}
                        </Button>
                      </PopoverTrigger>
                      <PopoverContent className="w-auto p-0" align="start">
                        <Calendar
                          mode="single"
                          selected={
                            profileForm.watch("dateOfBirth")
                              ? new Date(profileForm.watch("dateOfBirth"))
                              : undefined
                          }
                          onSelect={(date) => {
                            if (date) {
                              profileForm.setValue(
                                "dateOfBirth",
                                format(date, "yyyy-MM-dd"),
                              );
                              setDobOpen(false);
                            }
                          }}
                          captionLayout="dropdown"
                        />
                      </PopoverContent>
                    </Popover>
                    {profileForm.formState.errors.dateOfBirth && (
                      <p className="text-sm text-destructive">
                        {profileForm.formState.errors.dateOfBirth.message}
                      </p>
                    )}
                  </div>

                  <div className="flex items-center gap-3 pt-2">
                    <Button type="submit" disabled={updateProfile.isPending}>
                      {updateProfile.isPending ? "Saving..." : "Save Changes"}
                    </Button>
                    {updateProfile.isSuccess && (
                      <span className="text-sm text-green-600 font-medium">
                        Saved!
                      </span>
                    )}
                  </div>
                </form>
              </CardContent>
            </Card>
          </motion.div>

          <motion.div
            initial={{ opacity: 0, y: 16 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.1 }}
          >
            <Card>
              <CardHeader>
                <CardTitle className="text-lg flex items-center gap-2">
                  Password
                </CardTitle>
              </CardHeader>
              <CardContent>
                {showPasswordForm ? (
                  <form
                    onSubmit={passwordForm.handleSubmit(onPasswordSubmit)}
                    className="space-y-4"
                  >
                    <div className="space-y-2">
                      <Label htmlFor="currentPassword">Current Password</Label>
                      <Input
                        id="currentPassword"
                        type="password"
                        {...passwordForm.register("currentPassword")}
                      />
                      {passwordForm.formState.errors.currentPassword && (
                        <p className="text-sm text-destructive">
                          {
                            passwordForm.formState.errors.currentPassword
                              .message
                          }
                        </p>
                      )}
                    </div>
                    <div className="space-y-2">
                      <Label htmlFor="newPassword">New Password</Label>
                      <Input
                        id="newPassword"
                        type="password"
                        {...passwordForm.register("newPassword")}
                      />
                      {passwordForm.formState.errors.newPassword && (
                        <p className="text-sm text-destructive">
                          {passwordForm.formState.errors.newPassword.message}
                        </p>
                      )}
                    </div>
                    <div className="space-y-2">
                      <Label htmlFor="confirmNewPassword">
                        Confirm New Password
                      </Label>
                      <Input
                        id="confirmNewPassword"
                        type="password"
                        {...passwordForm.register("confirmNewPassword")}
                      />
                      {passwordForm.formState.errors.confirmNewPassword && (
                        <p className="text-sm text-destructive">
                          {
                            passwordForm.formState.errors.confirmNewPassword
                              .message
                          }
                        </p>
                      )}
                    </div>
                    {changePassword.isError && (
                      <p className="text-sm text-destructive">
                        Failed to change password. Check your current password.
                      </p>
                    )}
                    <div className="flex gap-3 pt-2">
                      <Button type="submit" disabled={changePassword.isPending}>
                        {changePassword.isPending
                          ? "Changing..."
                          : "Change Password"}
                      </Button>
                      <Button
                        type="button"
                        variant="ghost"
                        onClick={() => {
                          setShowPasswordForm(false);
                          passwordForm.reset();
                        }}
                      >
                        Cancel
                      </Button>
                    </div>
                  </form>
                ) : (
                  <Button
                    variant="outline"
                    onClick={() => setShowPasswordForm(true)}
                  >
                    Change Password
                  </Button>
                )}
              </CardContent>
            </Card>
          </motion.div>
        </div>

        <div className="space-y-4">
          <Card>
            <CardHeader>
              <CardTitle className="text-lg">Account</CardTitle>
            </CardHeader>
            <CardContent className="space-y-3">
              <div>
                <Label className="text-xs text-muted-foreground">Name</Label>
                <p className="font-semibold">
                  {profile.firstName} {profile.lastName}
                </p>
              </div>
              <div>
                <Label className="text-xs text-muted-foreground">Email</Label>
                <p className="font-semibold truncate">{profile.email}</p>
              </div>
              <div>
                <Label className="text-xs text-muted-foreground">
                  Date of Birth
                </Label>
                <p className="font-semibold">{profile.dateOfBirth}</p>
              </div>
            </CardContent>
          </Card>
        </div>
      </div>

      <motion.div
        initial={{ opacity: 0, y: 16 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.2 }}
      >
        <Card>
          <CardHeader>
            <CardTitle className="text-lg flex items-center gap-2">
              Booking History
            </CardTitle>
          </CardHeader>
          <CardContent>
            {bookingsLoading && bookingPage === 1 ? (
              <div className="space-y-3">
                {Array.from({ length: 3 }).map((_, i) => (
                  <Skeleton key={i} className="h-20 w-full rounded-xl" />
                ))}
              </div>
            ) : allBookings.length === 0 ? (
              <div className="text-center py-12">
                <Receipt className="w-12 h-12 mx-auto text-muted-foreground/40 mb-3" />
                <p className="text-muted-foreground font-medium">
                  No bookings yet
                </p>
                <Button
                  variant="link"
                  onClick={() => navigate("/showtimes")}
                  className="mt-1"
                >
                  Browse movies
                </Button>
              </div>
            ) : (
              <>
                <div className="space-y-3">
                  {allBookings.map((booking) => (
                    <div
                      key={booking.bookingReference}
                      className="flex items-center gap-4 p-4 rounded-xl border bg-card/50 hover:bg-accent/50 transition-colors cursor-pointer group"
                      onClick={() =>
                        navigate(`/bookings/${booking.bookingReference}`)
                      }
                    >
                      {booking.moviePosterPath ? (
                        <img
                          src={`${TMDB_IMAGE_POSTER_URL}${booking.moviePosterPath}`}
                          alt={booking.movieTitle}
                          className="w-14 h-20 rounded-lg object-cover shadow-md"
                        />
                      ) : (
                        <div className="w-14 h-20 rounded-lg bg-muted flex items-center justify-center">
                          <Receipt className="w-5 h-5 text-muted-foreground" />
                        </div>
                      )}
                      <div className="flex-1 min-w-0">
                        <p className="font-bold truncate">
                          {booking.movieTitle}
                        </p>
                        <div className="flex items-center gap-3 text-xs text-muted-foreground mt-1">
                          <span className="flex items-center gap-1">
                            <CalendarIcon className="w-3 h-3" />
                            {format(
                              new Date(booking.showtimeStartsAt),
                              "MMM d",
                            )}
                          </span>
                          <span className="flex items-center gap-1">
                            <Clock className="w-3 h-3" />
                            {format(
                              new Date(booking.showtimeStartsAt),
                              "h:mm a",
                            )}
                          </span>
                          <span className="flex items-center gap-1">
                            <MapPin className="w-3 h-3" />
                            {booking.seatCount} seat
                            {booking.seatCount > 1 ? "s" : ""}
                          </span>
                        </div>
                        <div className="flex items-center gap-2 mt-1.5">
                          <Badge
                            variant={
                              booking.status === "Confirmed"
                                ? "default"
                                : "secondary"
                            }
                            className="text-[10px]"
                          >
                            {booking.status}
                          </Badge>
                          <span className="text-sm font-bold text-primary">
                            ${booking.totalAmount.toFixed(2)}
                          </span>
                        </div>
                      </div>
                      <ChevronRight className="w-5 h-5 text-muted-foreground group-hover:translate-x-0.5 transition-transform flex-shrink-0" />
                    </div>
                  ))}
                </div>

                {hasMore && (
                  <div className="flex justify-center mt-6">
                    <Button
                      variant="outline"
                      onClick={() => setBookingPage((p) => p + 1)}
                      disabled={bookingsLoading}
                      className="gap-2"
                    >
                      {bookingsLoading ? (
                        "Loading..."
                      ) : (
                        <>
                          Load More <ChevronDown className="w-4 h-4" />
                        </>
                      )}
                    </Button>
                  </div>
                )}
              </>
            )}
          </CardContent>
        </Card>
      </motion.div>
    </div>
  );
};

export default Profile;
