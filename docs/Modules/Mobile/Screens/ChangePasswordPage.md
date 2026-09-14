# Mobile Screen Deep-Dive: `ChangePasswordPage`

> **File Path:** `apps/mobile/lib/features/settings/presentation/screens/change_password_page.dart`  
> **Route Name:** `'/change-password'`  
> **State Management:** `AuthRepository` & Form Controllers  
> **Fields:** Current Password, New Password, Confirm New Password

---

## 1. Overview & Business Objectives

`ChangePasswordPage` provides secure password modification:
1. **Verification of Current Password:** Ensures the authenticated user authorizes the password change.
2. **New Password Strength Enforcement:** Validates length and character composition rules.
3. **Password Confirmation:** Compares new password and confirmation matching.
4. **API Dispatch:** Triggers `PUT /api/Profile/password` and handles error or success banners.
