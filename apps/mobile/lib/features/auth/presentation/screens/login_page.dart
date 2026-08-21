import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketa/core/services/message_service.dart';
import 'package:ticketa/core/theme/app_colors.dart';
import 'package:ticketa/core/di/injection.dart';
import 'package:ticketa/features/auth/presentation/widgets/auth_background.dart';
import 'package:ticketa/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:ticketa/features/auth/presentation/cubit/auth_state.dart';
import 'package:ticketa/l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  late AnimationController _animController;
  late Animation<double> _slideUp;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _slideUp = Tween<double>(begin: 40, end: 0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => getIt<AuthCubit>(),
      child: Scaffold(
        body: AuthBackground(
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: AnimatedBuilder(
                  animation: _animController,
                  builder: (context, _) {
                    return Opacity(
                      opacity: _fadeIn.value,
                      child: Transform.translate(
                        offset: Offset(0, _slideUp.value),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 40),
                              _buildHeader(theme, l10n),
                              const SizedBox(height: 48),
                              _buildInputLabel(theme, l10n.email),
                              const SizedBox(height: 8),
                              _buildEmailField(theme, isDark, l10n),
                              const SizedBox(height: 20),
                              _buildInputLabel(theme, l10n.password),
                              const SizedBox(height: 8),
                              _buildPasswordField(theme, isDark, l10n),
                              const SizedBox(height: 12),
                              _buildForgotPassword(theme, l10n),
                              const SizedBox(height: 32),
                              _buildSignInButton(theme, l10n),
                              const SizedBox(height: 24),
                              _buildDividerWithText(theme, isDark, l10n),
                              const SizedBox(height: 24),
                              _buildGuestButton(theme, l10n),
                              const SizedBox(height: 16),
                              _buildRegisterRow(theme, l10n),
                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, AppLocalizations l10n) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.warmOrange, AppColors.lighterOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.warmOrange.withValues(alpha: 0.3),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(Icons.local_movies_rounded, color: Colors.white, size: 36),
        ),
        const SizedBox(height: 20),
        Text(
          l10n.welcomeBack,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: theme.colorScheme.onSurface,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.signInToContinue,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
          ),
        ),
      ],
    );
  }

  Widget _buildInputLabel(ThemeData theme, String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
        ),
      ),
    );
  }

  Widget _buildEmailField(ThemeData theme, bool isDark, AppLocalizations l10n) {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\x00-\x7F]'))],
      style: TextStyle(color: theme.colorScheme.onSurface),
      decoration: _inputDecoration(
        theme, isDark,
        hint: l10n.enterEmail,
        icon: Icons.email_outlined,
      ),
      validator: (v) => v == null || v.isEmpty ? l10n.emailRequired : null,
    );
  }

  Widget _buildPasswordField(ThemeData theme, bool isDark, AppLocalizations l10n) {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\x00-\x7F]'))],
      style: TextStyle(color: theme.colorScheme.onSurface),
      decoration: _inputDecoration(
        theme, isDark,
        hint: l10n.enterPassword,
        icon: Icons.lock_outlined,
        suffix: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            size: 20,
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
      ),
      validator: (v) => v == null || v.isEmpty ? l10n.passwordRequired : null,
    );
  }

  Widget _buildForgotPassword(ThemeData theme, AppLocalizations l10n) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => Navigator.pushNamed(context, '/forgot-password'),
        style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
        child: Text(
          l10n.forgotPassword,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.warmOrange,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildSignInButton(ThemeData theme, AppLocalizations l10n) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoginSuccess) {
          Navigator.pushReplacementNamed(context, '/main');
        } else if (state is AuthEmailConfirmRequired) {
          Navigator.pushReplacementNamed(context, '/confirm-email', arguments: state.email);
        } else if (state is AuthError) {
          MessageService.showError(context: context, message: state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return SizedBox(
          width: double.infinity,
          height: 56,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const LinearGradient(
                colors: [AppColors.warmOrange, AppColors.lighterOrange],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.warmOrange.withValues(alpha: 0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: isLoading ? null : () {
                if (_formKey.currentState!.validate()) {
                  context.read<AuthCubit>().login(
                    _emailController.text.trim(),
                    _passwordController.text,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                elevation: 0,
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 22, width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(l10n.signIn, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 20),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDividerWithText(ThemeData theme, bool isDark, AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(child: Divider(color: theme.colorScheme.onSurface.withValues(alpha: 0.08))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(l10n.or, style: TextStyle(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1,
          )),
        ),
        Expanded(child: Divider(color: theme.colorScheme.onSurface.withValues(alpha: 0.08))),
      ],
    );
  }

  Widget _buildGuestButton(ThemeData theme, AppLocalizations l10n) {
    return Builder(
      builder: (context) => SizedBox(
        width: double.infinity,
        height: 52,
        child: OutlinedButton.icon(
          onPressed: () => context.read<AuthCubit>().loginAsGuest(),
          icon: Icon(Icons.person_outline_rounded, size: 18, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
          label: Text(
            l10n.continueAsGuest,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: theme.colorScheme.onSurface.withValues(alpha: 0.12)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterRow(ThemeData theme, AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.dontHaveAccount,
          style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.45), fontSize: 13),
        ),
        GestureDetector(
          onTap: () => Navigator.pushReplacementNamed(context, '/register'),
          child: Text(
            l10n.register,
            style: TextStyle(
              color: AppColors.warmOrange,
              fontWeight: FontWeight.w900,
              fontSize: 13,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.warmOrange.withValues(alpha: 0.3),
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(ThemeData theme, bool isDark, {
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.25)),
      prefixIcon: Icon(icon, size: 20, color: AppColors.warmOrange.withValues(alpha: 0.6)),
      suffixIcon: suffix,
      filled: true,
      fillColor: isDark
          ? AppColors.darkGrey.withValues(alpha: 0.5)
          : Colors.white.withValues(alpha: 0.8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: theme.colorScheme.onSurface.withValues(alpha: 0.06)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: theme.colorScheme.onSurface.withValues(alpha: 0.06)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.warmOrange, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    );
  }
}
