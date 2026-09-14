import { Card, CardContent, CardHeader, CardTitle } from "./ui/card";
import { Label } from "./ui/label";

interface ProfileInfoProps {
  firstName: string;
  lastName: string;
  email: string;
  dateOfBirth: string;
}

const ProfileInfo = ({
  firstName,
  lastName,
  email,
  dateOfBirth,
}: ProfileInfoProps) => {
  return (
    <div className="space-y-4">
      <Card>
        <CardHeader>
          <CardTitle className="text-lg">Account</CardTitle>
        </CardHeader>
        <CardContent className="space-y-3">
          <div>
            <Label className="text-xs text-muted-foreground">Name</Label>
            <p className="font-semibold">
              {firstName} {lastName}
            </p>
          </div>
          <div>
            <Label className="text-xs text-muted-foreground">Email</Label>
            <p className="font-semibold truncate">{email}</p>
          </div>
          <div>
            <Label className="text-xs text-muted-foreground">
              Date of Birth
            </Label>
            <p className="font-semibold">{dateOfBirth}</p>
          </div>
        </CardContent>
      </Card>
    </div>
  );
};

export default ProfileInfo;
