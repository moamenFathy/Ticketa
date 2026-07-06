import { useAuth } from "@/hooks/useAuth";
import { useProfile } from "@/hooks/useProfile";
import { Card, CardContent } from "@/components/ui/card";
import { Skeleton } from "@/components/ui/skeleton";
import ErrorState from "@/components/ErrorState";
import { motion } from "framer-motion";
import BookingHistory from "@/components/BookingHistory";
import { useNavigate } from "react-router-dom";
import ProfileManagement from "@/components/ProfileManagement";

const Profile = () => {
  const { isLoggedIn, isInitializing } = useAuth();
  const navigate = useNavigate();
  const { data: profile, isLoading, isError, refetch } = useProfile();

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

  return (
    <div className="container mx-auto px-4 py-8 max-w-4xl space-y-8">
      <div>
        <h1 className="text-3xl font-black tracking-tight">My Profile</h1>
        <p className="text-muted-foreground mt-1">
          Manage your account details and view your booking history.
        </p>
      </div>

      <ProfileManagement profile={profile} />

      <motion.div
        initial={{ opacity: 0, y: 16 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.2 }}
      >
        <BookingHistory />
      </motion.div>
    </div>
  );
};

export default Profile;
