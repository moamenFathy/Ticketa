import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ticketa/l10n/app_localizations.dart';
import 'package:ticketa/features/offers/presentation/widgets/offer_card.dart';
import 'package:ticketa/features/offers/presentation/widgets/offer_skeleton.dart' as ticketa_offer_skeleton;

class OffersPage extends StatefulWidget {
  const OffersPage({super.key});

  @override
  State<OffersPage> createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _simulateLoading();
  }

  Future<void> _simulateLoading() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                l10n.offers.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: "https://images.unsplash.com/photo-1536440136628-849c177e76a1?q=80&w=2625&auto=format&fit=crop",
                    fit: BoxFit.cover,
                    memCacheWidth: 400,
                    placeholder: (_, _) => Container(color: Colors.grey[900]),
                    errorWidget: (_, _, _) => Container(color: Colors.grey[900]),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          (isDark ? Colors.black : Colors.white).withValues(alpha: 0.2),
                          theme.scaffoldBackgroundColor,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
            sliver: SliverFillRemaining(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                switchInCurve: Curves.easeIn,
                switchOutCurve: Curves.easeOut,
                transitionBuilder: (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
                child: _isLoading
                    ? const ticketa_offer_skeleton.OfferSkeleton(
                        key: ValueKey('skeleton'))
                    : ListView.builder(
                        key: const ValueKey('content'),
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          final (badge, title, desc) = switch (index) {
                            0 => (l10n.offerBadge1, l10n.offerTitle1, l10n.offerDesc1),
                            1 => (l10n.offerBadge2, l10n.offerTitle2, l10n.offerDesc2),
                            _ => (l10n.offerBadge3, l10n.offerTitle3, l10n.offerDesc3),
                          };
                          return OfferCard(badge: badge, title: title, description: desc);
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
