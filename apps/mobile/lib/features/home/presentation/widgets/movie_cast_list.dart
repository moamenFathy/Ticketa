import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ticketa/features/home/data/models/movie.dart';

class MovieCastList extends StatelessWidget {
  final List<CastMember> cast;
  const MovieCastList({super.key, this.cast = const []});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (cast.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: cast.length,
        itemBuilder: (context, index) {
          final member = cast[index];
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                  backgroundImage: member.profilePath != null && member.profilePath!.isNotEmpty
                      ? CachedNetworkImageProvider(member.profilePath!, maxWidth: 120)
                      : null,
                  child: member.profilePath == null || member.profilePath!.isEmpty
                      ? Icon(Icons.person, color: theme.colorScheme.onSurface.withValues(alpha: 0.3))
                      : null,
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: 64,
                  child: Text(
                    member.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(
                  width: 64,
                  child: Text(
                    member.character,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
