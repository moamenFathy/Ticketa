import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketa/features/home/presentation/widgets/home_category_list.dart';
import 'package:ticketa/features/home/presentation/widgets/home_header.dart';
import 'package:ticketa/features/home/presentation/widgets/home_hero_section.dart';
import 'package:ticketa/features/home/presentation/widgets/movie_horizontal_list.dart';
import 'package:ticketa/features/home/presentation/widgets/home_skeleton.dart'
    as ticketa_home_skeleton;
import 'package:ticketa/l10n/app_localizations.dart';
import 'package:ticketa/core/di/injection.dart';
import 'package:ticketa/features/home/data/models/movie.dart';
import 'package:ticketa/features/home/presentation/cubit/home_cubit.dart';
import 'package:ticketa/features/home/presentation/cubit/home_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => getIt<HomeCubit>()..fetchHomeData(),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeInitial || state is HomeLoading) {
              return const ticketa_home_skeleton.HomeSkeleton(
                key: ValueKey('skeleton'),
              );
            }

            if (state is HomeError) {
              return _buildErrorState(theme, context, state.message);
            }

            final nowShowing = state is HomeLoaded ? state.nowShowing : <Movie>[];
            final comingSoon = state is HomeLoaded ? state.comingSoon : <Movie>[];

            final topRatedMovies = List<Movie>.from(nowShowing)
              ..sort((a, b) => b.rating.compareTo(a.rating));
            final heroMovies = topRatedMovies.take(6).toList();

            final l10n = AppLocalizations.of(context)!;
            final isDark = theme.brightness == Brightness.dark;
            final safePage = _currentPage < heroMovies.length
                ? _currentPage
                : 0;

            return _buildContent(theme, l10n, nowShowing, comingSoon, heroMovies, safePage, isDark, context);
          },
        ),
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme, BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () =>
                context.read<HomeCubit>().fetchHomeData(),
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ThemeData theme, AppLocalizations l10n, List<Movie> nowShowing, List<Movie> comingSoon, List<Movie> heroMovies, int safePage, bool isDark, BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      transitionBuilder: (child, animation) =>
          FadeTransition(opacity: animation, child: child),
      child: KeyedSubtree(
        key: const ValueKey('content'),
        child: Stack(
          children: [
            _buildBackground(theme, heroMovies, safePage, isDark),
            SafeArea(
              top: false,
              bottom: false,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: MediaQuery.of(context).padding.top + 8,
                    ),
                  ),
                  const SliverToBoxAdapter(child: HomeHeader()),
                  if (heroMovies.isNotEmpty)
                    SliverToBoxAdapter(
                      child: HomeHeroSection(
                        movies: heroMovies,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                      ),
                    ),
                  const SliverToBoxAdapter(child: HomeCategoryList()),
                  SliverToBoxAdapter(
                    child: MovieHorizontalList(
                      title: l10n.nowShowing,
                      movies: nowShowing,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: MovieHorizontalList(
                      title: l10n.comingSoon,
                      movies: comingSoon,
                      showRating: false,
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 120),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground(ThemeData theme, List<Movie> heroMovies, int safePage, bool isDark) {
    if (heroMovies.isNotEmpty) {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: Container(
          key: ValueKey<String>(heroMovies[safePage].posterUrl),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(heroMovies[safePage].posterUrl),
              fit: BoxFit.cover,
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              color: (isDark ? Colors.black : Colors.white)
                  .withValues(alpha: isDark ? 0.4 : 0.6),
            ),
          ),
        ),
      );
    }
    return Container(color: isDark ? Colors.black : Colors.white);
  }
}
