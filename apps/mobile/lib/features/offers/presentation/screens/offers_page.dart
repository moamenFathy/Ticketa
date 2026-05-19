import 'package:flutter/material.dart';
import 'package:ticketa/l10n/app_localizations.dart';
import '../widgets/offer_card.dart';

class OffersPage extends StatelessWidget {
  const OffersPage({super.key});

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
                  Image.network(
                    "https://images.unsplash.com/photo-1536440136628-849c177e76a1?q=80&w=2625&auto=format&fit=crop",
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          (isDark ? Colors.black : Colors.white).withOpacity(0.2),
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
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => OfferCard(index: index),
                childCount: 5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
