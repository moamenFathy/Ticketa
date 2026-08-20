import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketa/core/services/message_service.dart';
import 'package:ticketa/core/theme/app_colors.dart';
import 'package:ticketa/core/di/injection.dart';
import 'package:ticketa/core/widgets/custom_date_picker.dart';
import 'package:ticketa/features/auth/presentation/widgets/auth_background.dart';
import 'package:ticketa/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:ticketa/features/auth/presentation/cubit/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _dateController = TextEditingController();
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
    _fadeIn = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _dateController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showCustomDatePicker(context);
    if (picked != null) {
      final y = picked.year.toString();
      final m = picked.month.toString().padLeft(2, '0');
      final d = picked.day.toString().padLeft(2, '0');
      _dateController.text = '$y-$m-$d';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
                              _buildHeader(theme),
                              const SizedBox(height: 28),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: _buildFirstNameField(theme, isDark),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildLastNameField(theme, isDark),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              _buildInputLabel(theme, 'Email'),
                              const SizedBox(height: 8),
                              _buildEmailField(theme, isDark),
                              const SizedBox(height: 20),
                              _buildInputLabel(theme, 'Password'),
                              const SizedBox(height: 8),
                              _buildPasswordField(theme, isDark),
                              const SizedBox(height: 20),
                              _buildInputLabel(theme, 'Date of Birth'),
                              const SizedBox(height: 8),
                              _buildDateField(theme, isDark),
                              const SizedBox(height: 32),
                              _buildRegisterButton(theme),
                              const SizedBox(height: 24),
                              _buildLoginRow(theme),
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

  Widget _buildHeader(ThemeData theme) {
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
          child: const Icon(
            Icons.person_add_rounded,
            color: Colors.white,
            size: 36,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Create Account',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: theme.colorScheme.onSurface,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Join the cinema experience',
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

  Widget _buildFirstNameField(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputLabel(theme, 'First Name'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _firstNameController,
          textCapitalization: TextCapitalization.words,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
          ],
          style: TextStyle(color: theme.colorScheme.onSurface),
          decoration: _inputDecoration(
            theme,
            isDark,
            hint: 'First name',
            icon: Icons.person_outline,
          ),
          validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
        ),
      ],
    );
  }

  Widget _buildLastNameField(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputLabel(theme, 'Last Name'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _lastNameController,
          textCapitalization: TextCapitalization.words,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
          ],
          style: TextStyle(color: theme.colorScheme.onSurface),
          decoration: _inputDecoration(
            theme,
            isDark,
            hint: 'Last name',
            icon: Icons.person_outline,
          ),
          validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
        ),
      ],
    );
  }

  Widget _buildEmailField(ThemeData theme, bool isDark) {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[\x00-\x7F]')),
      ],
      style: TextStyle(color: theme.colorScheme.onSurface),
      decoration: _inputDecoration(
        theme,
        isDark,
        hint: 'your@email.com',
        icon: Icons.email_outlined,
      ),
      validator: (v) => v == null || v.isEmpty ? 'Email is required' : null,
    );
  }

  Widget _buildPasswordField(ThemeData theme, bool isDark) {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[\x00-\x7F]')),
      ],
      style: TextStyle(color: theme.colorScheme.onSurface),
      decoration: _inputDecoration(
        theme,
        isDark,
        hint: 'Minimum 6 characters',
        icon: Icons.lock_outlined,
        suffix: IconButton(
          icon: Icon(
            _obscurePassword
                ? Icons.visibility_off_rounded
                : Icons.visibility_rounded,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            size: 20,
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
      ),
      validator: (v) {
        if (v == null || v.isEmpty) return 'Password is required';
        if (v.length < 6) return 'At least 6 characters';
        return null;
      },
    );
  }

  Widget _buildDateField(ThemeData theme, bool isDark) {
    return TextFormField(
      controller: _dateController,
      readOnly: true,
      onTap: _pickDate,
      style: TextStyle(color: theme.colorScheme.onSurface),
      decoration: _inputDecoration(
        theme,
        isDark,
        hint: 'Select your date of birth',
        icon: Icons.cake_outlined,
        suffix: Icon(
          Icons.arrow_drop_down_rounded,
          color: AppColors.warmOrange.withValues(alpha: 0.6),
        ),
      ),
      validator: (v) =>
          v == null || v.isEmpty ? 'Date of birth is required' : null,
    );
  }

  Widget _buildRegisterButton(ThemeData theme) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthRegisterSuccess) {
          final email = _emailController.text.trim();
          MessageService.showSuccess(context: context, message: state.message);
          Navigator.pushReplacementNamed(
            context,
            '/confirm-email',
            arguments: email,
          );
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
              onPressed: isLoading
                  ? null
                  : () {
                      if (_formKey.currentState!.validate()) {
                        context.read<AuthCubit>().register(
                          _emailController.text.trim(),
                          _passwordController.text,
                          _dateController.text.trim(),
                          _firstNameController.text.trim(),
                          _lastNameController.text.trim(),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 0,
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded, size: 20),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoginRow(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: TextStyle(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
            fontSize: 13,
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pushReplacementNamed(context, '/login'),
          child: Text(
            'Sign In',
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

  InputDecoration _inputDecoration(
    ThemeData theme,
    bool isDark, {
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.25),
      ),
      prefixIcon: Icon(
        icon,
        size: 20,
        color: AppColors.warmOrange.withValues(alpha: 0.6),
      ),
      suffixIcon: suffix,
      filled: true,
      fillColor: isDark
          ? AppColors.darkGrey.withValues(alpha: 0.5)
          : Colors.white.withValues(alpha: 0.8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.warmOrange, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    );
  }
}
