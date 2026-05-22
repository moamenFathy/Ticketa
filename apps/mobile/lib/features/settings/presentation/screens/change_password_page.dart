import 'package:flutter/material.dart';
import 'package:ticketa/core/theme/app_colors.dart';

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

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
              _copy(context, 'Change password', 'تغيير كلمة السر'),
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
                        label: _copy(
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
                        label: _copy(
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
                            return _copy(
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
                        label: _copy(
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
                            return _copy(
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
                        label: _copy(
                          context,
                          'Update password',
                          'تحديث كلمة السر',
                        ),
                        onTap: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  _copy(
                                    context,
                                    'Password updated successfully',
                                    'تم تحديث كلمة السر بنجاح',
                                  ),
                                ),
                              ),
                            );
                          }
                        },
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
      return _copy(context, 'Password is required', 'كلمة السر مطلوبة');
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
                  _copy(
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
                  _copy(
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
      _copy(context, 'Too short', 'قصيرة جدًا'),
      _copy(context, 'Weak', 'ضعيفة'),
      _copy(context, 'Good', 'جيدة'),
      _copy(context, 'Strong', 'قوية'),
    ][score];

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
                  _copy(context, 'Password strength', 'قوة كلمة السر'),
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.warmOrange,
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
                child: Container(
                  height: 5,
                  margin: EdgeInsetsDirectional.only(end: index == 3 ? 0 : 6),
                  decoration: BoxDecoration(
                    color: index <= score
                        ? AppColors.warmOrange
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
    if (password.length < 8) return 0;
    var score = 1;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]|[^A-Za-z]').hasMatch(password)) score++;
    return score.clamp(0, 3);
  }
}

class _SaveButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SaveButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.warmOrange,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w900)),
      ),
    );
  }
}

String _copy(BuildContext context, String en, String ar) {
  return Localizations.localeOf(context).languageCode == 'ar' ? ar : en;
}
