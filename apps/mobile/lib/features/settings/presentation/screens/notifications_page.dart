import 'package:flutter/material.dart';
import 'package:ticketa/core/theme/app_colors.dart';
import 'package:ticketa/l10n/app_localizations.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool bookingAlerts = true;
  bool offerAlerts = true;
  bool reminderAlerts = false;

  final List<_NotificationItem> _notifications = const [
    _NotificationItem(
      icon: Icons.confirmation_number_rounded,
      titleEn: 'Your Dune tickets are ready',
      titleAr: 'تذاكر Dune جاهزة',
      bodyEn: 'Show the QR code at Vox Cinemas before 08:30 PM.',
      bodyAr: 'اعرض كود QR في Vox Cinemas قبل 08:30 مساء.',
      time: '12m',
      isUnread: true,
      color: AppColors.warmOrange,
    ),
    _NotificationItem(
      icon: Icons.local_offer_rounded,
      titleEn: 'Weekend combo offer',
      titleAr: 'عرض كومبو نهاية الأسبوع',
      bodyEn: 'Save 25% on popcorn and drinks with any evening show.',
      bodyAr: 'وفر 25% على الفشار والمشروبات مع أي حفلة مسائية.',
      time: '2h',
      isUnread: true,
      color: AppColors.success,
    ),
    _NotificationItem(
      icon: Icons.schedule_rounded,
      titleEn: 'Movie starts soon',
      titleAr: 'الفيلم هيبدأ قريب',
      bodyEn: 'Inside Out 2 starts in 45 minutes at Galaxy Cairo Festival.',
      bodyAr: 'Inside Out 2 يبدأ بعد 45 دقيقة في Galaxy Cairo Festival.',
      time: '1d',
      isUnread: false,
      color: AppColors.warning,
    ),
    _NotificationItem(
      icon: Icons.star_rounded,
      titleEn: 'You earned 80 points',
      titleAr: 'كسبت 80 نقطة',
      bodyEn: 'Your loyalty points were added after your last booking.',
      bodyAr: 'تمت إضافة نقاط الولاء بعد آخر حجز لك.',
      time: '3d',
      isUnread: false,
      color: Colors.blueAccent,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final unreadCount = _notifications.where((item) => item.isUnread).length;

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
              l10n.notifications,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 0,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 12),
                child: IconButton(
                  tooltip: _copy(context, 'Mark all read', 'تحديد الكل كمقروء'),
                  onPressed: () {},
                  icon: const Icon(Icons.done_all_rounded),
                ),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _NotificationHero(unreadCount: unreadCount),
                const SizedBox(height: 18),
                _PreferenceCard(
                  title: _copy(
                    context,
                    'Notification preferences',
                    'تفضيلات الإشعارات',
                  ),
                  children: [
                    _PreferenceSwitch(
                      icon: Icons.confirmation_number_rounded,
                      title: _copy(context, 'Booking updates', 'تحديثات الحجز'),
                      value: bookingAlerts,
                      onChanged: (value) =>
                          setState(() => bookingAlerts = value),
                    ),
                    _PreferenceSwitch(
                      icon: Icons.local_offer_rounded,
                      title: _copy(
                        context,
                        'Offers and discounts',
                        'العروض والخصومات',
                      ),
                      value: offerAlerts,
                      onChanged: (value) => setState(() => offerAlerts = value),
                    ),
                    _PreferenceSwitch(
                      icon: Icons.schedule_rounded,
                      title: _copy(
                        context,
                        'Showtime reminders',
                        'تذكير مواعيد العروض',
                      ),
                      value: reminderAlerts,
                      onChanged: (value) =>
                          setState(() => reminderAlerts = value),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                _SectionTitle(title: _copy(context, 'Recent', 'الأحدث')),
                const SizedBox(height: 12),
                ..._notifications.map((item) => _NotificationTile(item: item)),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationHero extends StatelessWidget {
  final int unreadCount;

  const _NotificationHero({required this.unreadCount});

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
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.warmOrange.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.notifications_active_rounded,
              color: AppColors.warmOrange,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _copy(context, 'Stay in the loop', 'خليك متابع'),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _copy(
                    context,
                    '$unreadCount unread updates',
                    '$unreadCount إشعارات غير مقروءة',
                  ),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.52),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.warmOrange,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              unreadCount.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PreferenceCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _PreferenceCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 2, 4, 8),
            child: Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 0,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

class _PreferenceSwitch extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _PreferenceSwitch({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.warmOrange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.warmOrange, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
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

class _NotificationTile extends StatelessWidget {
  final _NotificationItem item;

  const _NotificationTile({required this.item});

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
          color: item.isUnread
              ? AppColors.warmOrange.withValues(alpha: 0.18)
              : theme.colorScheme.onSurface.withValues(alpha: 0.06),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(item.icon, color: item.color, size: 21),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _copy(context, item.titleEn, item.titleAr),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item.time,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.38,
                        ),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  _copy(context, item.bodyEn, item.bodyAr),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    fontSize: 12,
                    height: 1.35,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (item.isUnread) ...[
            const SizedBox(width: 8),
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(top: 6),
              decoration: const BoxDecoration(
                color: AppColors.warmOrange,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _NotificationItem {
  final IconData icon;
  final String titleEn;
  final String titleAr;
  final String bodyEn;
  final String bodyAr;
  final String time;
  final bool isUnread;
  final Color color;

  const _NotificationItem({
    required this.icon,
    required this.titleEn,
    required this.titleAr,
    required this.bodyEn,
    required this.bodyAr,
    required this.time,
    required this.isUnread,
    required this.color,
  });
}

String _copy(BuildContext context, String en, String ar) {
  return Localizations.localeOf(context).languageCode == 'ar' ? ar : en;
}
