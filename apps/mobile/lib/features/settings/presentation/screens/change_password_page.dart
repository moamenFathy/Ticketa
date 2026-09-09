import 'package:flutter/material.dart';
import 'package:ticketa/core/di/injection.dart';
import 'package:ticketa/core/services/message_service.dart';
import 'package:ticketa/core/theme/app_colors.dart';
import 'package:ticketa/core/utils/localization_helper.dart';
import 'package:ticketa/features/auth/data/auth_repository.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _hideCurrent = true;
  bool _hideNew = true;
  bool _hideConfirm = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSubmitting = true);
    try {
      await getIt<AuthRepository>().changePassword(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
        confirmNewPassword: _confirmPasswordController.text,
      );
      if (!mounted) return;
      MessageService.showSuccess(
        context: context,
        message: localeCopy(
          context,
          'Password updated successfully',
          'تم تحديث كلمة السر بنجاح',
        ),
      );
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
      setState(() {});
    } catch (e) {
      if (!mounted) return;
      final message = e.toString().replaceFirst('Exception: ', '');
      MessageService.showError(
        context: context,
        message: message.isEmpty
            ? localeCopy(
                context,
                'Failed to update password',
                'فشل تحديث كلمة السر',
              )
            : message,
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: theme.scaffoldBackgroundColor.withValues(alpha: 0.95),
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.black.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Localizations.localeOf(context).languageCode == 'ar'
                      ? Icons.arrow_forward_ios_rounded
                      : Icons.arrow_back_ios_new_rounded,
                  size: 16,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
            title: Text(
              localeCopy(context, 'Change Password', 'تغيير كلمة السر'),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: -0.3,
              ),
            ),
            centerTitle: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    const _SecurityHeroCard(),
                    const SizedBox(height: 24),
                    _SectionTitle(
                      title: localeCopy(
                        context,
                        'Password Credentials',
                        'بيانات كلمة السر',
                      ),
                      subtitle: localeCopy(
                        context,
                        'Ensure your new password meets security guidelines',
                        'تأكد من مطابقة كلمة السر الجديدة لمعايير الأمان',
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Current Password
                    _CinemaPasswordField(
                      controller: _currentPasswordController,
                      label: localeCopy(
                        context,
                        'Current password',
                        'كلمة السر الحالية',
                      ),
                      hint: localeCopy(
                        context,
                        'Enter current password',
                        'أدخل كلمة السر الحالية',
                      ),
                      hidden: _hideCurrent,
                      onToggle: () =>
                          setState(() => _hideCurrent = !_hideCurrent),
                      validator: (v) => _requiredPassword(context, v),
                    ),
                    const SizedBox(height: 14),

                    // New Password
                    _CinemaPasswordField(
                      controller: _newPasswordController,
                      label: localeCopy(
                        context,
                        'New password',
                        'كلمة السر الجديدة',
                      ),
                      hint: localeCopy(
                        context,
                        'Enter at least 8 characters',
                        'أدخل 8 خانات على الأقل',
                      ),
                      hidden: _hideNew,
                      onToggle: () => setState(() => _hideNew = !_hideNew),
                      onChanged: (_) => setState(() {}),
                      validator: (value) {
                        final base = _requiredPassword(context, value);
                        if (base != null) return base;
                        if (value!.length < 8) {
                          return localeCopy(
                            context,
                            'Use at least 8 characters',
                            'استخدم 8 أحرف على الأقل',
                          );
                        }
                        return null;
                      },
                    ),

                    // Live Strength meter
                    AnimatedSize(
                      duration: const Duration(milliseconds: 250),
                      child: _newPasswordController.text.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(top: 8, bottom: 6),
                              child: _CinemaPasswordStrength(
                                password: _newPasswordController.text,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 14),

                    // Confirm Password
                    _CinemaPasswordField(
                      controller: _confirmPasswordController,
                      label: localeCopy(
                        context,
                        'Confirm new password',
                        'تأكيد كلمة السر الجديدة',
                      ),
                      hint: localeCopy(
                        context,
                        'Re-enter new password',
                        'أعد إدخال كلمة السر الجديدة',
                      ),
                      hidden: _hideConfirm,
                      onToggle: () =>
                          setState(() => _hideConfirm = !_hideConfirm),
                      validator: (value) {
                        final base = _requiredPassword(context, value);
                        if (base != null) return base;
                        if (value != _newPasswordController.text) {
                          return localeCopy(
                            context,
                            'Passwords do not match',
                            'كلمات السر غير متطابقة',
                          );
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 32),

                    // Update CTA Button
                    _CinemaActionButton(
                      label: _isSubmitting
                          ? localeCopy(
                              context,
                              'Updating...',
                              'جارٍ التحديث...',
                            )
                          : localeCopy(
                              context,
                              'Update Password',
                              'تحديث كلمة السر',
                            ),
                      loading: _isSubmitting,
                      onTap: _submit,
                    ),

                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? _requiredPassword(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return localeCopy(context, 'Password is required', 'كلمة السر مطلوبة');
    }
    return null;
  }
}

class _SecurityHeroCard extends StatelessWidget {
  const _SecurityHeroCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF141416) : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.06),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.warmOrange,
                  AppColors.lighterOrange,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.warmOrange.withValues(alpha: 0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localeCopy(
                    context,
                    'Account Protection',
                    'حماية الحساب',
                  ),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  localeCopy(
                    context,
                    'Create a unique password to safeguard your cinema bookings.',
                    'اختر كلمة سر فريدة لحماية حجوزاتك ومعلوماتك.',
                  ),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionTitle({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.key_rounded,
              size: 18,
              color: AppColors.warmOrange,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _CinemaPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool hidden;
  final VoidCallback onToggle;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  const _CinemaPasswordField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.hidden,
    required this.onToggle,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6, left: 4, right: 4),
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
              fontSize: 12.5,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          obscureText: hidden,
          onChanged: onChanged,
          validator: validator,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w700,
            fontSize: 14.5,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.35),
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: Icon(
              Icons.lock_outline_rounded,
              size: 20,
              color: AppColors.warmOrange.withValues(alpha: 0.85),
            ),
            suffixIcon: IconButton(
              onPressed: onToggle,
              icon: Icon(
                hidden ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                size: 20,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            filled: true,
            fillColor: isDark ? const Color(0xFF161619) : theme.colorScheme.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.08),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.08),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(
                color: AppColors.warmOrange,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(
                color: theme.colorScheme.error,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(
                color: theme.colorScheme.error,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CinemaPasswordStrength extends StatelessWidget {
  final String password;

  const _CinemaPasswordStrength({required this.password});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final score = _scorePassword(password);
    final label = [
      localeCopy(context, 'Too short', 'قصيرة جدًا'),
      localeCopy(context, 'Weak', 'ضعيفة'),
      localeCopy(context, 'Good', 'جيدة'),
      localeCopy(context, 'Strong', 'قوية وممتازة'),
    ][score];

    final color = switch (score) {
      1 => Colors.redAccent,
      2 => AppColors.warmOrange,
      3 => AppColors.success,
      _ => theme.colorScheme.onSurface.withValues(alpha: 0.35),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161619) : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  localeCopy(context, 'Password Strength', 'قوة كلمة السر'),
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(4, (index) {
              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: 4.5,
                  margin: EdgeInsetsDirectional.only(end: index == 3 ? 0 : 6),
                  decoration: BoxDecoration(
                    color: index <= score
                        ? color
                        : theme.colorScheme.onSurface.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  int _scorePassword(String password) {
    if (password.isEmpty) return 0;
    if (password.length < 8) return 1;
    var score = 2;
    if (RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[0-9]').hasMatch(password)) {
      score = 3;
    }
    return score;
  }
}

class _CinemaActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool loading;

  const _CinemaActionButton({
    required this.label,
    required this.onTap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [
            AppColors.warmOrange,
            AppColors.lighterOrange,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.warmOrange.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: loading ? null : onTap,
          borderRadius: BorderRadius.circular(20),
          child: Center(
            child: loading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.lock_reset_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
