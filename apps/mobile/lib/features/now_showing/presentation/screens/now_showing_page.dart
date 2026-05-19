import 'package:flutter/material.dart';
import 'package:ticketa/core/data/dummy_data.dart';
import 'package:ticketa/l10n/app_localizations.dart';
import '../widgets/now_showing_card.dart';

class NowShowingPage extends StatelessWidget {
  const NowShowingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final movies = DummyData.movies;
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Premium Header
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              title: Text(
                l10n.nowShowing.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                  letterSpacing: 2,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    "https://images.unsplash.com/photo-1478720568477-152d9b164e26?q=80&w=2670&auto=format&fit=crop",
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          (isDark ? Colors.black : Colors.white).withOpacity(0.2),
                          theme.scaffoldBackgroundColor.withOpacity(0.8),
                          theme.scaffoldBackgroundColor,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Movie List
          SliverPadding(
            padding: const EdgeInsets.only(top: 10, bottom: 120),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => NowShowingCard(movie: movies[index]),
                childCount: movies.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
