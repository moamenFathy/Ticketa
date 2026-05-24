import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ticketa/core/theme/app_colors.dart';
import 'package:ticketa/features/home/data/models/movie.dart';
import 'package:ticketa/l10n/app_localizations.dart';

class SeeAllCastPage extends StatelessWidget {
  final List<CastMember> cast;

  const SeeAllCastPage({super.key, required this.cast});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          l10n.cast,
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: cast.length,
        itemBuilder: (context, index) {
          final member = cast[index];
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: Duration(milliseconds: 350 + (index * 50)),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: _CastCard(member: member),
          );
        },
      ),
    );
  }
}

class _CastCard extends StatelessWidget {
  final CastMember member;

  const _CastCard({required this.member});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final hasImage = member.profilePath != null && member.profilePath!.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkGrey.withValues(alpha: 0.6)
            : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Expanded(
            child: hasImage
                ? CachedNetworkImage(
                    imageUrl: member.profilePath!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    memCacheWidth: 300,
                    placeholder: (_, _) => _imagePlaceholder(theme),
                    errorWidget: (_, _, _) => _imagePlaceholder(theme),
                  )
                : _imagePlaceholder(theme),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                Text(
                  member.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.onSurface,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  member.character,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.warmOrange,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imagePlaceholder(ThemeData theme) {
    return Container(
      color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
      child: Center(
        child: Icon(
          Icons.person_rounded,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.15),
          size: 40,
        ),
      ),
    );
  }
}
