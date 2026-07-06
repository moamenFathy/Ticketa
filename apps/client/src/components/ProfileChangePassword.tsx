import { useState } from "react";
import { Button } from "./ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "./ui/card";
import { Input } from "./ui/input";
import { Label } from "./ui/label";
import { zodResolver } from "@hookform/resolvers/zod";
import { useForm } from "react-hook-form";
import { useChangePassword } from "@/hooks/useProfile";
import z from "zod";

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

type PasswordFormData = z.infer<typeof passwordSchema>;

const ProfileChangePassword = () => {
  const changePassword = useChangePassword();

  const passwordForm = useForm<PasswordFormData>({
    resolver: zodResolver(passwordSchema),
  });

  const onPasswordSubmit = (data: PasswordFormData) => {
    changePassword.mutate(data, {
      onSuccess: () => {
        passwordForm.reset();
        setShowPasswordForm(false);
      },
    });
  };

  const [showPasswordForm, setShowPasswordForm] = useState(false);

  return (
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
                  {passwordForm.formState.errors.currentPassword.message}
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
              <Label htmlFor="confirmNewPassword">Confirm New Password</Label>
              <Input
                id="confirmNewPassword"
                type="password"
                {...passwordForm.register("confirmNewPassword")}
              />
              {passwordForm.formState.errors.confirmNewPassword && (
                <p className="text-sm text-destructive">
                  {passwordForm.formState.errors.confirmNewPassword.message}
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
                {changePassword.isPending ? "Changing..." : "Change Password"}
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
          <Button variant="outline" onClick={() => setShowPasswordForm(true)}>
            Change Password
          </Button>
        )}
      </CardContent>
    </Card>
  );
};

export default ProfileChangePassword;
