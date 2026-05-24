import 'package:flutter/material.dart';
import 'package:ticketa/core/theme/app_colors.dart';
import 'package:ticketa/core/utils/localization_helper.dart';

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({super.key});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  bool personalizedOffers = true;
  bool activityHistory = true;
  bool locationAccess = false;

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
              localeCopy(context, 'Privacy', 'الخصوصية'),
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
                const _PrivacyHero(),
                const SizedBox(height: 18),
                _SectionTitle(
                  title: localeCopy(context, 'Data controls', 'التحكم في البيانات'),
                ),
                const SizedBox(height: 12),
                _SwitchTile(
                  icon: Icons.local_offer_rounded,
                  title: localeCopy(context, 'Personalized offers', 'عروض مخصصة'),
                  subtitle: localeCopy(
                    context,
                    'Use booking history to improve deals',
                    'استخدم سجل الحجز لتحسين العروض',
                  ),
                  value: personalizedOffers,
                  onChanged: (value) =>
                      setState(() => personalizedOffers = value),
                ),
                _SwitchTile(
                  icon: Icons.history_rounded,
                  title: localeCopy(context, 'Activity history', 'سجل النشاط'),
                  subtitle: localeCopy(
                    context,
                    'Keep recent movies and searches',
                    'احتفظ بآخر الأفلام وعمليات البحث',
                  ),
                  value: activityHistory,
                  onChanged: (value) => setState(() => activityHistory = value),
                ),
                _SwitchTile(
                  icon: Icons.location_on_rounded,
                  title: localeCopy(context, 'Location access', 'الوصول للموقع'),
                  subtitle: localeCopy(
                    context,
                    'Find nearby cinemas and offers',
                    'اعثر على سينمات وعروض قريبة',
                  ),
                  value: locationAccess,
                  onChanged: (value) => setState(() => locationAccess = value),
                ),
                const SizedBox(height: 22),
                _SectionTitle(title: localeCopy(context, 'Your data', 'بياناتك')),
                const SizedBox(height: 12),
                _ActionTile(
                  icon: Icons.download_rounded,
                  title: localeCopy(context, 'Download my data', 'تحميل بياناتي'),
                  subtitle: localeCopy(
                    context,
                    'Get a copy of your profile and bookings',
                    'احصل على نسخة من ملفك وحجوزاتك',
                  ),
                ),
                _ActionTile(
                  icon: Icons.delete_outline_rounded,
                  title: localeCopy(
                    context,
                    'Delete account data',
                    'حذف بيانات الحساب',
                  ),
                  subtitle: localeCopy(
                    context,
                    'Request permanent deletion',
                    'طلب حذف نهائي للبيانات',
                  ),
                  danger: true,
                ),
                const SizedBox(height: 22),
                _SectionTitle(title: localeCopy(context, 'Legal', 'القوانين')),
                const SizedBox(height: 12),
                _PolicyCard(
                  title: localeCopy(context, 'Privacy policy', 'سياسة الخصوصية'),
                  subtitle: localeCopy(
                    context,
                    'How Ticketa collects and protects your data',
                    'كيف تجمع تيكيتا بياناتك وتحميها',
                  ),
                  icon: Icons.privacy_tip_rounded,
                ),
                _PolicyCard(
                  title: localeCopy(context, 'Terms of service', 'شروط الاستخدام'),
                  subtitle: localeCopy(
                    context,
                    'Booking, refunds, and app usage rules',
                    'قواعد الحجز والاسترداد واستخدام التطبيق',
                  ),
                  icon: Icons.description_rounded,
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrivacyHero extends StatelessWidget {
  const _PrivacyHero();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AppColors.warmOrange.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.privacy_tip_rounded,
              color: AppColors.warmOrange,
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
                    'You control your data',
                    'أنت تتحكم في بياناتك',
                  ),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  localeCopy(
                    context,
                    'Choose what Ticketa can use to personalize your experience.',
                    'اختر ما يمكن لتيكيتا استخدامه لتخصيص تجربتك.',
                  ),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
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

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool danger;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = danger ? Colors.redAccent : AppColors.warmOrange;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return _SurfaceTile(
      child: Row(
        children: [
          _TileIcon(icon: icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: _TileText(title: title, subtitle: subtitle),
          ),
          Icon(
            isRtl ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.24),
          ),
        ],
      ),
    );
  }
}

class _PolicyCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _PolicyCard({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return _ActionTile(icon: icon, title: title, subtitle: subtitle);
  }
}

class _SurfaceTile extends StatelessWidget {
  final Widget child;

  const _SurfaceTile({required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
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

