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

class ConfirmEmailPage extends StatefulWidget {
  const ConfirmEmailPage({super.key});

  @override
  State<ConfirmEmailPage> createState() => _ConfirmEmailPageState();
}

class _ConfirmEmailPageState extends State<ConfirmEmailPage> with SingleTickerProviderStateMixin {
  final _codeController = TextEditingController();
  String? _email;
  bool _codeValid = false;
  late AnimationController _animController;
  late Animation<double> _slideUp;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _codeController.addListener(() {
      setState(() => _codeValid = _codeController.text.trim().length == 6);
    });
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _email ??= ModalRoute.of(context)?.settings.arguments as String?;
  }

  @override
  void dispose() {
    _codeController.dispose();
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
                            const SizedBox(height: 40),
                            _buildEmailChip(theme, isDark),
                            const SizedBox(height: 32),
                            _buildInputLabel(theme, l10n.confirmationCode),
                            const SizedBox(height: 8),
                            _buildCodeField(theme, isDark, l10n),
                            const SizedBox(height: 32),
                            _buildConfirmButton(theme, l10n),
                            const SizedBox(height: 16),
                            _buildResendButton(theme, l10n),
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
          child: const Icon(Icons.mark_email_unread_rounded, color: Colors.white, size: 36),
        ),
        const SizedBox(height: 20),
        Text(
          l10n.verifyEmail,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: theme.colorScheme.onSurface,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.enterConfirmationCode,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailChip(ThemeData theme, bool isDark) {
    if (_email == null) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.warmOrange.withValues(alpha: isDark ? 0.12 : 0.08),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.warmOrange.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.email_rounded, size: 16, color: AppColors.warmOrange),
          const SizedBox(width: 8),
          Text(
            _email!,
            style: TextStyle(
              color: AppColors.warmOrange,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
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

  Widget _buildCodeField(ThemeData theme, bool isDark, AppLocalizations l10n) {
    return TextFormField(
      controller: _codeController,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      maxLength: 6,
      style: TextStyle(
        color: theme.colorScheme.onSurface,
        fontSize: 24,
        fontWeight: FontWeight.w900,
        letterSpacing: 12,
      ),
      decoration: InputDecoration(
        counterText: '',
        hintText: l10n.codeHint,
        hintStyle: TextStyle(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.15),
          fontSize: 24,
          fontWeight: FontWeight.w900,
          letterSpacing: 12,
        ),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      ),
    );
  }

  Widget _buildConfirmButton(ThemeData theme, AppLocalizations l10n) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthEmailConfirmed) {
          MessageService.showSuccess(context: context, message: state.message);
          Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
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
              onPressed: isLoading || _email == null || !_codeValid
                  ? null
                  : () => context.read<AuthCubit>().confirmEmail(_email!, _codeController.text.trim()),
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
                        Text(l10n.confirm, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                        SizedBox(width: 8),
                        Icon(Icons.check_circle_outline_rounded, size: 20),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildResendButton(ThemeData theme, AppLocalizations l10n) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return Column(
          children: [
            TextButton(
              onPressed: isLoading || _email == null
                  ? null
                  : () => context.read<AuthCubit>().resendConfirmation(_email!),
              child: Text(
                l10n.resendConfirmation,
                style: TextStyle(
                  color: AppColors.warmOrange,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
            BlocListener<AuthCubit, AuthState>(
              listenWhen: (_, state) => state is AuthResendSuccess,
              listener: (context, state) {
                final s = state as AuthResendSuccess;
                MessageService.showSuccess(context: context, message: s.message);
              },
              child: const SizedBox.shrink(),
            ),
          ],
        );
      },
    );
  }
}
