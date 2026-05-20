import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ticketa/core/data/dummy_data.dart';
import 'package:ticketa/features/home/presentation/widgets/home_category_list.dart';
import 'package:ticketa/features/home/presentation/widgets/home_header.dart';
import 'package:ticketa/features/home/presentation/widgets/home_hero_section.dart';
import 'package:ticketa/features/home/presentation/widgets/movie_horizontal_list.dart';
import 'package:ticketa/features/home/presentation/widgets/home_skeleton.dart' as ticketa_home_skeleton;
import 'package:ticketa/l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 1;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _simulateLoading();
  }

  Future<void> _simulateLoading() async {
    await Future.delayed(const Duration(seconds: 2));
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        transitionBuilder: (child, animation) =>
            FadeTransition(opacity: animation, child: child),
        child: _isLoading
            ? const ticketa_home_skeleton.HomeSkeleton(key: ValueKey('skeleton'))
            : KeyedSubtree(
                key: const ValueKey('content'),
                child: Stack(
                  children: [
                    // Dynamic Blurred Background
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: Container(
                        key: ValueKey<String>(movies[_currentPage].posterUrl),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(movies[_currentPage].posterUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(
                            color: (isDark ? Colors.black : Colors.white)
                                .withOpacity(isDark ? 0.4 : 0.6),
                          ),
                        ),
                      ),
                    ),

                    SafeArea(
                      child: CustomScrollView(
                        physics: const BouncingScrollPhysics(),
                        slivers: [
                          // Premium Header
                          const SliverToBoxAdapter(child: HomeHeader()),

                          // Hero Section
                          SliverToBoxAdapter(
                            child: HomeHeroSection(
                              movies: movies,
                              onPageChanged: (index) {
                                setState(() {
                                  _currentPage = index;
                                });
                              },
                            ),
                          ),

                          // Category Chips
                          const SliverToBoxAdapter(child: HomeCategoryList()),

                          // Now Showing
                          SliverToBoxAdapter(
                            child: MovieHorizontalList(
                              title: l10n.nowShowing,
                              movies: movies,
                            ),
                          ),

                          // Coming Soon
                          SliverToBoxAdapter(
                            child: MovieHorizontalList(
                              title: l10n.comingSoon,
                              movies: movies.reversed.toList(),
                              showRating: false,
                            ),
                          ),

                          const SliverToBoxAdapter(child: SizedBox(height: 120)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}