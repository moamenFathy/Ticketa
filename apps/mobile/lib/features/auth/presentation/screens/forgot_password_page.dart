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

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 40),
                            _buildHeader(theme, l10n),
                            const SizedBox(height: 48),
                            _buildDescription(theme, l10n),
                            const SizedBox(height: 28),
                            _buildInputLabel(theme, l10n.email),
                            const SizedBox(height: 8),
                            _buildEmailField(theme, isDark, l10n),
                            const SizedBox(height: 32),
                            _buildSendButton(theme, l10n),
                            const SizedBox(height: 20),
                            _buildBackButton(theme, l10n),
                            const SizedBox(height: 40),
                          ],
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
          child: const Icon(Icons.lock_reset_rounded, color: Colors.white, size: 36),
        ),
        const SizedBox(height: 20),
        Text(
          l10n.forgotPasswordTitle,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: theme.colorScheme.onSurface,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(ThemeData theme, AppLocalizations l10n) {
    return Text(
      l10n.forgotPasswordDesc,
      textAlign: TextAlign.center,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
        height: 1.5,
      ),
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
      onChanged: (_) => setState(() {}),
      keyboardType: TextInputType.emailAddress,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\x00-\x7F]'))],
      style: TextStyle(color: theme.colorScheme.onSurface),
      decoration: InputDecoration(
        hintText: l10n.emailHint,
        hintStyle: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.25)),
        prefixIcon: Icon(Icons.email_outlined, size: 20, color: AppColors.warmOrange.withValues(alpha: 0.6)),
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
      ),
    );
  }

  Widget _buildSendButton(ThemeData theme, AppLocalizations l10n) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthForgotPasswordSuccess) {
          MessageService.showSuccess(context: context, message: state.message);
          Navigator.pop(context);
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
              onPressed: isLoading || _emailController.text.trim().isEmpty
                  ? null
                  : () => context.read<AuthCubit>().forgotPassword(_emailController.text.trim()),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: Colors.white,
                disabledForegroundColor: Colors.white.withValues(alpha: 0.5),
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
                        Text(l10n.sendResetLink, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                        SizedBox(width: 8),
                        Icon(Icons.send_rounded, size: 20),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBackButton(ThemeData theme, AppLocalizations l10n) {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.arrow_back_rounded, size: 16, color: theme.colorScheme.onSurface.withValues(alpha: 0.45)),
          const SizedBox(width: 6),
          Text(
            l10n.backToSignIn,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
