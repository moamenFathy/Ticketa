import 'package:flutter/material.dart';
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
        _dateController.text = profile['dateOfBirth'] as String? ?? '';
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

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
              localeCopy(context, 'Edit profile', 'تعديل الملف الشخصي'),
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
                _ProfilePhotoCard(
                  name:
                      '${_firstNameController.text} ${_lastNameController.text}'
                          .trim(),
                ),
                const SizedBox(height: 18),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _ProfileField(
                              controller: _firstNameController,
                              label: localeCopy(
                                context,
                                'First name',
                                'الاسم الأول',
                              ),
                              icon: Icons.person_outline_rounded,
                              validator: (value) => _required(context, value),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _ProfileField(
                              controller: _lastNameController,
                              label: localeCopy(
                                context,
                                'Last name',
                                'اسم العائلة',
                              ),
                              icon: Icons.person_outline_rounded,
                              validator: (value) => _required(context, value),
                            ),
                          ),
                        ],
                      ),
                      _ProfileField(
                        controller: _emailController,
                        label: localeCopy(
                          context,
                          'Email address',
                          'البريد الإلكتروني',
                        ),
                        icon: Icons.mail_outline_rounded,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          final base = _required(context, value);
                          if (base != null) return base;
                          if (!value!.contains('@')) {
                            return localeCopy(
                              context,
                              'Enter a valid email',
                              'ادخل بريد إلكتروني صحيح',
                            );
                          }
                          return null;
                        },
                      ),
                      _ProfileField(
                        controller: _dateController,
                        label: localeCopy(
                          context,
                          'Date of birth',
                          'تاريخ الميلاد',
                        ),
                        icon: Icons.cake_outlined,
                        readOnly: true,
                        onTap: _pickDate,
                        validator: (value) => _required(context, value),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                _SaveButton(
                  label: localeCopy(context, 'Save changes', 'حفظ التغييرات'),
                  loading: _isSaving,
                  onTap: _saveProfile,
                ),
              ]),
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

class _ProfilePhotoCard extends StatelessWidget {
  final String name;

  const _ProfilePhotoCard({required this.name});

  static String _initials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '';
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

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppColors.warmOrange, Colors.orangeAccent],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.warmOrange.withValues(alpha: 0.24),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 46,
                  backgroundColor: theme.scaffoldBackgroundColor,
                  child: Text(
                    _initials(name),
                    style: TextStyle(
                      color: AppColors.warmOrange,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            name,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final bool readOnly;
  final VoidCallback? onTap;

  const _ProfileField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.validator,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        readOnly: readOnly,
        onTap: onTap,
        style: TextStyle(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w800,
        ),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
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

class _SaveButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool loading;

  const _SaveButton({
    required this.label,
    required this.onTap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: loading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.warmOrange,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Text(label, style: const TextStyle(fontWeight: FontWeight.w900)),
      ),
    );
  }
}
