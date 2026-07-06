import { motion } from "framer-motion";
import ProfileInfo from "./ProfileInfo";
import ProfileChangePassword from "./ProfileChangePassword";
import { Card, CardContent, CardHeader, CardTitle } from "./ui/card";
import { Button } from "./ui/button";
import { PopoverContent, PopoverTrigger } from "@radix-ui/react-popover";
import { format } from "date-fns/format";
import { Popover } from "./ui/popover";
import { Label } from "./ui/label";
import { Input } from "./ui/input";
import { useState } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { useUpdateProfile } from "@/hooks/useProfile";
import z from "zod";
import { cn } from "@/lib/utils";
import type { ProfileDto } from "@/types/profile";
import { CalendarIcon } from "lucide-react";
import { Calendar } from "./ui/calendar";

const profileSchema = z.object({
  firstName: z.string().min(1, "First name is required").max(50),
  lastName: z.string().min(1, "Last name is required").max(50),
  dateOfBirth: z.string().min(1, "Date of birth is required"),
  theme: z.string(),
});

type ProfileFormData = z.infer<typeof profileSchema>;

const ProfileManagement = ({ profile }: { profile: ProfileDto }) => {
  const updateProfile = useUpdateProfile();
  const [dobOpen, setDobOpen] = useState(false); // data of birth popover state

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

  const onProfileSubmit = (data: ProfileFormData) => {
    updateProfile.mutate(data);
  };

  return (
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
          <ProfileChangePassword />
        </motion.div>
      </div>

      <ProfileInfo {...profile} />
    </div>
  );
};

export default ProfileManagement;
