import 'package:flutter/material.dart';
import 'package:ticketa/core/theme/app_colors.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Mohamed Ahmed');
  final _emailController = TextEditingController(text: 'mohamed@ticketa.com');
  final _phoneController = TextEditingController(text: '+20 100 123 4567');
  final _cityController = TextEditingController(text: 'Cairo');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
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
              _copy(context, 'Edit profile', 'تعديل الملف الشخصي'),
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
                _ProfilePhotoCard(onChangePhoto: () {}),
                const SizedBox(height: 18),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _ProfileField(
                        controller: _nameController,
                        label: _copy(context, 'Full name', 'الاسم بالكامل'),
                        icon: Icons.person_outline_rounded,
                        validator: (value) => _required(context, value),
                      ),
                      _ProfileField(
                        controller: _emailController,
                        label: _copy(
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
                            return _copy(
                              context,
                              'Enter a valid email',
                              'ادخل بريد إلكتروني صحيح',
                            );
                          }
                          return null;
                        },
                      ),
                      _ProfileField(
                        controller: _phoneController,
                        label: _copy(context, 'Phone number', 'رقم الهاتف'),
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        validator: (value) => _required(context, value),
                      ),
                      _ProfileField(
                        controller: _cityController,
                        label: _copy(context, 'City', 'المدينة'),
                        icon: Icons.location_city_rounded,
                        validator: (value) => _required(context, value),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                _InfoCard(),
                const SizedBox(height: 18),
                _SaveButton(
                  label: _copy(context, 'Save changes', 'حفظ التغييرات'),
                  onTap: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            _copy(
                              context,
                              'Profile updated successfully',
                              'تم تحديث الملف الشخصي بنجاح',
                            ),
                          ),
                        ),
                      );
                    }
                  },
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
      return _copy(context, 'This field is required', 'هذا الحقل مطلوب');
    }
    return null;
  }
}

class _ProfilePhotoCard extends StatelessWidget {
  final VoidCallback onChangePhoto;

  const _ProfilePhotoCard({required this.onChangePhoto});

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
                  child: Icon(
                    Icons.person_rounded,
                    size: 48,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.35),
                  ),
                ),
              ),
              PositionedDirectional(
                end: -2,
                bottom: 0,
                child: Material(
                  color: AppColors.warmOrange,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: onChangePhoto,
                    child: const SizedBox(
                      width: 34,
                      height: 34,
                      child: Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            _copy(context, 'Mohamed Ahmed', 'محمد أحمد'),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _copy(context, 'Ticketa loyalty member', 'عضو نقاط تيكيتا'),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.52),
              fontWeight: FontWeight.w700,
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

  const _ProfileField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.validator,
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

class _InfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.warmOrange.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.warmOrange.withValues(alpha: 0.14)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: AppColors.warmOrange),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _copy(
                context,
                'Your email is used for ticket receipts and account recovery.',
                'يُستخدم البريد الإلكتروني لإيصالات التذاكر واسترجاع الحساب.',
              ),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.62),
                fontWeight: FontWeight.w700,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
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
