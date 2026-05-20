import 'package:flutter/material.dart';
import 'package:ticketa/core/data/dummy_data.dart';
import 'package:ticketa/l10n/app_localizations.dart';
import '../widgets/now_showing_card.dart';
import '../widgets/now_showing_skeleton.dart' as ticketa_now_skeleton;

class NowShowingPage extends StatefulWidget {
  const NowShowingPage({super.key});

  @override
  State<NowShowingPage> createState() => _NowShowingPageState();
}

class _NowShowingPageState extends State<NowShowingPage> {
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

          // Movie List or Skeleton — with smooth fade
          SliverFillRemaining(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
              child: _isLoading
                  ? const ticketa_now_skeleton.NowShowingSkeleton(
                      key: ValueKey('skeleton'))
                  : ListView.builder(
                      key: const ValueKey('content'),
                      padding:
                          const EdgeInsets.only(top: 10, bottom: 120),
                      itemCount: movies.length,
                      itemBuilder: (context, index) =>
                          NowShowingCard(movie: movies[index]),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
