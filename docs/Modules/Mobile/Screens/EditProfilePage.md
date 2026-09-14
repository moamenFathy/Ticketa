# Mobile Screen Deep-Dive: `EditProfilePage`

> **File Path:** `apps/mobile/lib/features/settings/presentation/screens/edit_profile_page.dart`  
> **Route Name:** `'/edit-profile'`  
> **State Management:** `AuthRepository` & Form Controllers  
> **Fields:** First Name, Last Name, Date of Birth Picker

---

## 1. Overview & Business Objectives

`EditProfilePage` enables users to modify their personal details:
1. **Profile Data Pre-filling:** Loads existing user data from `/api/Profile` or `SharedPreferences`.
2. **First & Last Name Modification:** Input text fields with client-side validation.
3. **Date of Birth Selector:** Reusable `CustomDatePicker` modal.
4. **Save Changes Execution:** Triggers `PUT /api/Profile` and emits success notifications.
