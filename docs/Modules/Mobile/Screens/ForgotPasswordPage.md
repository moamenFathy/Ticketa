# Mobile Screen Deep-Dive: `ForgotPasswordPage`

> **File Path:** `apps/mobile/lib/features/auth/presentation/screens/forgot_password_page.dart`  
> **Route Name:** `'/forgot-password'`  
> **State Management:** `AuthCubit` (`flutter_bloc`)  

---

## 1. Overview & Business Objectives

`ForgotPasswordPage` allows users who cannot access their account to initiate a password reset:
1. **Email Submission:** User enters their registered email address.
2. **API Dispatch:** Triggers `POST /api/Auth/forget-password`.
3. **Success Feedback:** Shows feedback confirming reset instructions have been emailed.
4. **Return to Login:** Simple navigation back to `LoginPage`.
