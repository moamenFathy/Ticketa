import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:ticketa/features/home/presentation/screens/see_all_movies_page.dart';

class HomePage extends StatefulWidget {
  final VoidCallback? onProfileAvatarTap;

  const HomePage({super.key, this.onProfileAvatarTap});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 1;

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
            final topBooked = state is HomeLoaded ? state.topBooked : <Movie>[];

            final heroMoviesTop = topBooked.take(6).toList();
            final nowShowingById = {
              for (final m in nowShowing) m.id: m,
            };
            final heroMovies = heroMoviesTop.map((movie) {
              final match = nowShowingById[movie.id];
              if (match == null) return movie;
              return movie.copyWith(
                showtimeInfos: match.showtimeInfos,
                showTimes: match.showTimes,
                hallType: match.hallType,
              );
            }).toList();

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
    final l10n = AppLocalizations.of(context)!;
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
            child: Text(l10n.retry),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ThemeData theme, AppLocalizations l10n, List<Movie> nowShowing, List<Movie> comingSoon, List<Movie> heroMovies, int safePage, bool isDark, BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 700),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        final slide = Tween<Offset>(
          begin: const Offset(0, 0.08),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
        return SlideTransition(
          position: slide,
          child: FadeTransition(opacity: animation, child: child),
        );
      },
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
                  _staggeredSliver(0.00, HomeHeader(onAvatarTap: widget.onProfileAvatarTap)),
                  if (heroMovies.isNotEmpty)
                    _staggeredSliver(0.10, HomeHeroSection(
                      movies: heroMovies,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                    )),
                  _staggeredSliver(0.20, MovieHorizontalList(
                    title: l10n.nowShowing,
                    movies: nowShowing,
                    onSeeAll: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SeeAllMoviesPage(title: l10n.nowShowing, movies: nowShowing),
                      ),
                    ),
                  )),
                  _staggeredSliver(0.40, MovieHorizontalList(
                    title: l10n.comingSoon,
                    movies: comingSoon,
                    showRating: false,
                    onSeeAll: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SeeAllMoviesPage(title: l10n.comingSoon, movies: comingSoon),
                      ),
                    ),
                  )),
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

  Widget _staggeredSliver(double delay, Widget child) {
    return SliverToBoxAdapter(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 600),
        curve: Interval(delay, 1.0, curve: Curves.easeOutCubic),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 16 * (1 - value)),
              child: child,
            ),
          );
        },
        child: child,
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
              image: CachedNetworkImageProvider(heroMovies[safePage].posterUrl, maxWidth: 1080),
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
