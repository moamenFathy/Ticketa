import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ticketa/core/di/injection.dart';
import 'package:ticketa/core/services/message_service.dart';
import 'package:ticketa/core/theme/app_colors.dart';
import 'package:ticketa/core/utils/localization_helper.dart';
import 'package:ticketa/core/widgets/custom_date_picker.dart';
import 'package:ticketa/features/auth/data/auth_repository.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dateController = TextEditingController();
  bool _isLoading = true;
  bool _isSaving = false;
  String _theme = 'light';
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final repository = getIt<AuthRepository>();
    try {
      final profile = await repository.getProfile();
      if (!mounted) return;
      setState(() {
        _firstNameController.text = profile['firstName'] as String? ?? '';
        _lastNameController.text = profile['lastName'] as String? ?? '';
        _emailController.text = profile['email'] as String? ?? '';
        final rawDate = profile['dateOfBirth'] as String? ?? '';
        _dateController.text = rawDate;
        if (rawDate.isNotEmpty) {
          try {
            _selectedDate = DateTime.tryParse(rawDate);
          } catch (_) {}
        }
        _theme = profile['theme'] as String? ?? 'light';
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  String _formatDisplayDate(BuildContext context, String rawDate) {
    if (rawDate.isEmpty) return '';
    try {
      final dt = DateTime.parse(rawDate);
      final isAr = Localizations.localeOf(context).languageCode == 'ar';
      return DateFormat('dd MMMM yyyy', isAr ? 'ar' : 'en').format(dt);
    } catch (_) {
      return rawDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.warmOrange),
        ),
      );
    }

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
              localeCopy(context, 'Edit Profile', 'تعديل الملف الشخصي'),
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
                    // Hero Avatar Card
                    ListenableBuilder(
                      listenable: Listenable.merge([
                        _firstNameController,
                        _lastNameController,
                      ]),
                      builder: (context, _) {
                        final fullName =
                            '${_firstNameController.text} ${_lastNameController.text}'
                                .trim();
                        return _HeroProfileCard(
                          name: fullName.isEmpty
                              ? localeCopy(context, 'Cinema Lover', 'محب السينما')
                              : fullName,
                          email: _emailController.text,
                        );
                      },
                    ),

                    const SizedBox(height: 24),
                    _SectionHeader(
                      icon: Icons.person_rounded,
                      title: localeCopy(
                        context,
                        'Personal Information',
                        'المعلومات الشخصية',
                      ),
                      subtitle: localeCopy(
                        context,
                        'Keep your cinema identity up to date',
                        'حافظ على تحديث بياناتك الشخصية',
                      ),
                    ),
                    const SizedBox(height: 12),

                    // First & Last Name row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _PremiumField(
                            controller: _firstNameController,
                            label: localeCopy(context, 'First name', 'الاسم الأول'),
                            hint: localeCopy(context, 'e.g. John', 'مثال: محمد'),
                            icon: Icons.badge_outlined,
                            validator: (v) => _required(context, v),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _PremiumField(
                            controller: _lastNameController,
                            label: localeCopy(context, 'Last name', 'اسم العائلة'),
                            hint: localeCopy(context, 'e.g. Doe', 'مثال: أحمد'),
                            icon: Icons.badge_outlined,
                            validator: (v) => _required(context, v),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Date of Birth field
                    _PremiumDateField(
                      label: localeCopy(context, 'Date of birth', 'تاريخ الميلاد'),
                      hint: localeCopy(
                        context,
                        'Select your birth date',
                        'اختر تاريخ ميلادك',
                      ),
                      displayValue: _formatDisplayDate(
                        context,
                        _dateController.text,
                      ),
                      onTap: _pickDate,
                    ),

                    const SizedBox(height: 28),
                    _SectionHeader(
                      icon: Icons.security_rounded,
                      title: localeCopy(
                        context,
                        'Account & Security',
                        'الحساب والأمان',
                      ),
                      subtitle: localeCopy(
                        context,
                        'Your primary Ticketa credentials',
                        'بيانات حسابك الأساسية في تيكتا',
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Read-only email card
                    _ProtectedEmailCard(
                      email: _emailController.text,
                    ),

                    const SizedBox(height: 32),

                    // Save Button
                    _CinemaSaveButton(
                      label: localeCopy(
                        context,
                        'Save Changes',
                        'حفظ التغييرات',
                      ),
                      loading: _isSaving,
                      onTap: _saveProfile,
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

  String? _required(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return localeCopy(context, 'This field is required', 'هذا الحقل مطلوب');
    }
    return null;
  }

  Future<void> _pickDate() async {
    final picked = await showCustomDatePicker(context);
    if (picked != null) {
      _selectedDate = picked;
      final y = picked.year.toString();
      final m = picked.month.toString().padLeft(2, '0');
      final d = picked.day.toString().padLeft(2, '0');
      setState(() => _dateController.text = '$y-$m-$d');
    }
  }

  Future<void> _saveProfile() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSaving = true);
    try {
      await getIt<AuthRepository>().updateProfile(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        dateOfBirth: _dateController.text.trim(),
        theme: _theme,
      );
      if (!mounted) return;
      MessageService.showSuccess(
        context: context,
        message: localeCopy(
          context,
          'Profile updated successfully',
          'تم تحديث الملف الشخصي بنجاح',
        ),
      );
    } catch (e) {
      if (!mounted) return;
      MessageService.showError(
        context: context,
        message: localeCopy(
          context,
          'Failed to update profile',
          'فشل تحديث الملف الشخصي',
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}

class _HeroProfileCard extends StatelessWidget {
  final String name;
  final String email;

  const _HeroProfileCard({
    required this.name,
    required this.email,
  });

  static String _initials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return 'T';
    if (parts.length >= 2) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return parts[0].length >= 2
        ? parts[0].substring(0, 2).toUpperCase()
        : parts[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF141416)
            : theme.colorScheme.surface,
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
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [
                  AppColors.warmOrange,
                  AppColors.lighterOrange,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.warmOrange.withValues(alpha: 0.35),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 46,
              backgroundColor: isDark
                  ? const Color(0xFF1E1E22)
                  : Colors.white,
              child: Text(
                _initials(name),
                style: const TextStyle(
                  color: AppColors.warmOrange,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
              fontSize: 19,
              letterSpacing: -0.2,
            ),
          ),
          if (email.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              email,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SectionHeader({
    required this.icon,
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
            Icon(
              icon,
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

class _PremiumField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final FormFieldValidator<String>? validator;

  const _PremiumField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
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
              icon,
              size: 20,
              color: AppColors.warmOrange.withValues(alpha: 0.85),
            ),
            filled: true,
            fillColor: isDark
                ? const Color(0xFF161619)
                : theme.colorScheme.surface,
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

class _PremiumDateField extends StatelessWidget {
  final String label;
  final String hint;
  final String displayValue;
  final VoidCallback onTap;

  const _PremiumDateField({
    required this.label,
    required this.hint,
    required this.displayValue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final hasValue = displayValue.isNotEmpty;

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
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF161619)
                  : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.08),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_month_rounded,
                  size: 20,
                  color: AppColors.warmOrange.withValues(alpha: 0.85),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    hasValue ? displayValue : hint,
                    style: TextStyle(
                      color: hasValue
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.onSurface.withValues(alpha: 0.35),
                      fontWeight: hasValue ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 14.5,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down_rounded,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  size: 26,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ProtectedEmailCard extends StatelessWidget {
  final String email;

  const _ProtectedEmailCard({required this.email});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF161619)
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.black.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.mail_rounded,
                  size: 18,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localeCopy(
                        context,
                        'Email Address',
                        'البريد الإلكتروني',
                      ),
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      email.isEmpty ? '—' : email,
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              localeCopy(
                context,
                'Primary email is locked for security and ticket recovery.',
                'البريد الإلكتروني مقفل لأسباب تتعلق بالأمان واسترجاع التذاكر.',
              ),
              style: TextStyle(
                fontSize: 11,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CinemaSaveButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool loading;

  const _CinemaSaveButton({
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
                        Icons.check_circle_rounded,
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
