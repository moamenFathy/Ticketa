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

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            title: Text(
              localeCopy(context, 'Change password', 'تغيير كلمة السر'),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 0,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const _PasswordHero(),
                const SizedBox(height: 18),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _PasswordField(
                        controller: _currentPasswordController,
                        label: localeCopy(
                          context,
                          'Current password',
                          'كلمة السر الحالية',
                        ),
                        hidden: _hideCurrent,
                        onToggle: () =>
                            setState(() => _hideCurrent = !_hideCurrent),
                        validator: (value) => _requiredPassword(context, value),
                      ),
                      _PasswordField(
                        controller: _newPasswordController,
                        label: localeCopy(
                          context,
                          'New password',
                          'كلمة السر الجديدة',
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
                      _PasswordStrength(password: _newPasswordController.text),
                      const SizedBox(height: 12),
                      _PasswordField(
                        controller: _confirmPasswordController,
                        label: localeCopy(
                          context,
                          'Confirm new password',
                          'تأكيد كلمة السر الجديدة',
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
                      const SizedBox(height: 18),
                      _SaveButton(
                        label: _isSubmitting
                            ? localeCopy(
                                context,
                                'Updating...',
                                'جارٍ التحديث...',
                              )
                            : localeCopy(
                                context,
                                'Update password',
                                'تحديث كلمة السر',
                              ),
                        onTap: _submit,
                        isLoading: _isSubmitting,
                      ),
                    ],
                  ),
                ),
              ]),
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

class _PasswordHero extends StatelessWidget {
  const _PasswordHero();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.warmOrange,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.warmOrange.withValues(alpha: 0.24),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.lock_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localeCopy(
                    context,
                    'Keep your account secure',
                    'حافظ على أمان حسابك',
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  localeCopy(
                    context,
                    'Choose a strong password you do not use elsewhere.',
                    'اختر كلمة سر قوية وغير مستخدمة في مكان آخر.',
                  ),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.76),
                    fontWeight: FontWeight.w700,
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

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool hidden;
  final VoidCallback onToggle;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  const _PasswordField({
    required this.controller,
    required this.label,
    required this.hidden,
    required this.onToggle,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        obscureText: hidden,
        onChanged: onChanged,
        validator: validator,
        style: TextStyle(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w800,
        ),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.lock_outline_rounded),
          suffixIcon: IconButton(
            onPressed: onToggle,
            icon: Icon(
              hidden ? Icons.visibility_rounded : Icons.visibility_off_rounded,
            ),
          ),
          filled: true,
          fillColor: theme.colorScheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: AppColors.warmOrange),
          ),
        ),
      ),
    );
  }
}

class _PasswordStrength extends StatelessWidget {
  final String password;

  const _PasswordStrength({required this.password});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final score = _scorePassword(password);
    final label = [
      localeCopy(context, 'Too short', 'قصيرة جدًا'),
      localeCopy(context, 'Weak', 'ضعيفة'),
      localeCopy(context, 'Good', 'جيدة'),
      localeCopy(context, 'Strong', 'قوية'),
    ][score];

    final color = switch (score) {
      1 => Colors.redAccent,
      2 => AppColors.warmOrange,
      3 => AppColors.success,
      _ => theme.colorScheme.onSurface.withValues(alpha: 0.35),
    };

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  localeCopy(context, 'Password strength', 'قوة كلمة السر'),
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w900,
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
          const SizedBox(height: 10),
          Row(
            children: List.generate(4, (index) {
              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: 5,
                  margin: EdgeInsetsDirectional.only(end: index == 3 ? 0 : 6),
                  decoration: BoxDecoration(
                    color: index < score
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

class _SaveButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isLoading;

  const _SaveButton({
    required this.label,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.warmOrange,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(label, style: const TextStyle(fontWeight: FontWeight.w900)),
      ),
    );
  }
}
