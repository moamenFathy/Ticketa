import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketa/core/di/injection.dart';
import 'package:ticketa/features/home/data/models/movie.dart';
import 'package:ticketa/features/now_showing/presentation/cubit/now_showing_cubit.dart';
import 'package:ticketa/features/now_showing/presentation/cubit/now_showing_state.dart';
import 'package:ticketa/l10n/app_localizations.dart';
import 'package:ticketa/features/now_showing/presentation/widgets/now_showing_card.dart';
import 'package:ticketa/features/now_showing/presentation/widgets/now_showing_skeleton.dart' as ticketa_now_skeleton;

class NowShowingPage extends StatelessWidget {
  const NowShowingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<NowShowingCubit>()..fetchNowShowing(),
      child: const _NowShowingView(),
    );
  }
}

class _NowShowingView extends StatelessWidget {
  const _NowShowingView();

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
              titlePadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                  CachedNetworkImage(
                    imageUrl: "https://images.unsplash.com/photo-1478720568477-152d9b164e26?q=80&w=2670&auto=format&fit=crop",
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
                          (isDark ? Colors.black : Colors.white)
                              .withValues(alpha: 0.2),
                          theme.scaffoldBackgroundColor.withValues(alpha: 0.8),
                          theme.scaffoldBackgroundColor,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            child: BlocBuilder<NowShowingCubit, NowShowingState>(
              builder: (context, state) {
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
                  child: _buildBody(context, state, theme),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    NowShowingState state,
    ThemeData theme,
  ) {
    if (state is NowShowingInitial || state is NowShowingLoading) {
      return const ticketa_now_skeleton.NowShowingSkeleton(
        key: ValueKey('skeleton'),
      );
    }

    if (state is NowShowingError) {
      return Center(
        key: const ValueKey('error'),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                state.message,
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    context.read<NowShowingCubit>().fetchNowShowing(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final movies = state is NowShowingLoaded ? state.movies : <Movie>[];

    if (movies.isEmpty) {
      return Center(
        key: const ValueKey('empty'),
        child: Text(
          'No movies showing right now',
          style: theme.textTheme.titleMedium,
        ),
      );
    }

    return ListView.builder(
      key: const ValueKey('content'),
      padding: const EdgeInsets.only(top: 10, bottom: 120),
      itemCount: movies.length,
      itemBuilder: (context, index) => TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 500),
        curve: Interval((index * 0.08).clamp(0.0, 0.7), 1.0, curve: Curves.easeOutCubic),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 24 * (1 - value)),
              child: child,
            ),
          );
        },
        child: NowShowingCard(movie: movies[index]),
      ),
    );
  }
}
