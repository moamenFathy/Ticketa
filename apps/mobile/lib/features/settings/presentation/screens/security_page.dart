import 'package:flutter/material.dart';
import 'package:ticketa/core/theme/app_colors.dart';
import 'package:ticketa/core/utils/localization_helper.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  bool twoFactorEnabled = true;
  bool biometricLogin = false;
  bool loginAlerts = true;

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
              localeCopy(context, 'Security', 'الأمان'),
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
                const _SecurityScoreCard(),
                const SizedBox(height: 18),
                _SectionTitle(
                  title: localeCopy(context, 'Account access', 'الوصول للحساب'),
                ),
                const SizedBox(height: 12),
                _ActionTile(
                  icon: Icons.lock_reset_rounded,
                  title: localeCopy(context, 'Change password', 'تغيير كلمة السر'),
                  subtitle: localeCopy(
                    context,
                    'Last updated 3 months ago',
                    'آخر تحديث من 3 أشهر',
                  ),
                  accentColor: AppColors.warmOrange,
                  onTap: () =>
                      Navigator.of(context).pushNamed('/change-password'),
                ),
                _SwitchTile(
                  icon: Icons.verified_user_rounded,
                  title: localeCopy(
                    context,
                    'Two-factor authentication',
                    'المصادقة الثنائية',
                  ),
                  subtitle: localeCopy(
                    context,
                    'Ask for a code when signing in',
                    'اطلب كود عند تسجيل الدخول',
                  ),
                  value: twoFactorEnabled,
                  onChanged: (value) =>
                      setState(() => twoFactorEnabled = value),
                ),
                _SwitchTile(
                  icon: Icons.fingerprint_rounded,
                  title: localeCopy(
                    context,
                    'Biometric login',
                    'تسجيل الدخول بالبصمة',
                  ),
                  subtitle: localeCopy(
                    context,
                    'Use Face ID or fingerprint',
                    'استخدم Face ID أو البصمة',
                  ),
                  value: biometricLogin,
                  onChanged: (value) => setState(() => biometricLogin = value),
                ),
                _SwitchTile(
                  icon: Icons.notifications_active_rounded,
                  title: localeCopy(context, 'Login alerts', 'تنبيهات تسجيل الدخول'),
                  subtitle: localeCopy(
                    context,
                    'Notify me about new devices',
                    'نبهني عند دخول جهاز جديد',
                  ),
                  value: loginAlerts,
                  onChanged: (value) => setState(() => loginAlerts = value),
                ),
                const SizedBox(height: 22),
                _SectionTitle(
                  title: localeCopy(context, 'Active sessions', 'الجلسات النشطة'),
                ),
                const SizedBox(height: 12),
                _SessionTile(
                  icon: Icons.phone_iphone_rounded,
                  device: localeCopy(context, 'iPhone 15 Pro', 'iPhone 15 Pro'),
                  location: localeCopy(
                    context,
                    'Cairo, Egypt • Current device',
                    'القاهرة، مصر • الجهاز الحالي',
                  ),
                  isCurrent: true,
                ),
                _SessionTile(
                  icon: Icons.laptop_mac_rounded,
                  device: localeCopy(context, 'MacBook Air', 'MacBook Air'),
                  location: localeCopy(
                    context,
                    'Giza, Egypt • 2 days ago',
                    'الجيزة، مصر • منذ يومين',
                  ),
                  isCurrent: false,
                ),
                const SizedBox(height: 10),
                _DangerButton(
                  label: localeCopy(
                    context,
                    'Sign out of all devices',
                    'تسجيل الخروج من كل الأجهزة',
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _SecurityScoreCard extends StatelessWidget {
  const _SecurityScoreCard();

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
              Icons.shield_rounded,
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
                  localeCopy(context, 'Strong protection', 'حماية قوية'),
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
                    '2FA is on and login alerts are active',
                    'المصادقة الثنائية وتنبيهات الدخول مفعلة',
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

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;
  final VoidCallback? onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return _SurfaceTile(
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                _TileIcon(icon: icon, color: accentColor),
                const SizedBox(width: 12),
                Expanded(
                  child: _TileText(title: title, subtitle: subtitle),
                ),
                Icon(
                  isRtl
                      ? Icons.chevron_left_rounded
                      : Icons.chevron_right_rounded,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.24),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _SurfaceTile(
      child: Row(
        children: [
          _TileIcon(icon: icon, color: AppColors.warmOrange),
          const SizedBox(width: 12),
          Expanded(
            child: _TileText(title: title, subtitle: subtitle),
          ),
          Switch.adaptive(
            value: value,
            activeThumbColor: AppColors.warmOrange,
            activeTrackColor: AppColors.warmOrange.withValues(alpha: 0.3),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _SessionTile extends StatelessWidget {
  final IconData icon;
  final String device;
  final String location;
  final bool isCurrent;

  const _SessionTile({
    required this.icon,
    required this.device,
    required this.location,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _SurfaceTile(
      child: Row(
        children: [
          _TileIcon(
            icon: icon,
            color: isCurrent ? AppColors.success : AppColors.warmOrange,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _TileText(title: device, subtitle: location),
          ),
          if (!isCurrent)
            Text(
              localeCopy(context, 'Remove', 'إزالة'),
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            )
          else
            Icon(
              Icons.check_circle_rounded,
              color: theme.colorScheme.primary,
              size: 20,
            ),
        ],
      ),
    );
  }
}

class _DangerButton extends StatelessWidget {
  final String label;

  const _DangerButton({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.redAccent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.redAccent.withValues(alpha: 0.14)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SurfaceTile extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _SurfaceTile({
    required this.child,
    this.padding = const EdgeInsets.all(14),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: padding,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
        ),
      ),
      child: child,
    );
  }
}

class _TileIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _TileIcon({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: color, size: 21),
    );
  }
}

class _TileText extends StatelessWidget {
  final String title;
  final String subtitle;

  const _TileText({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            fontSize: 12,
            height: 1.3,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      title,
      style: TextStyle(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.62),
        fontSize: 12,
        fontWeight: FontWeight.w900,
        letterSpacing: 0,
      ),
    );
  }
}

