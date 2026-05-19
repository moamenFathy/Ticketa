import 'package:flutter/material.dart';
import 'package:ticketa/features/home/models/movie.dart';
import 'package:ticketa/features/home/presentation/screens/movie_detail_page.dart';
import 'package:ticketa/l10n/app_localizations.dart';

class NowShowingCard extends StatelessWidget {
  final Movie movie;

  const NowShowingCard({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => MovieDetailPage(movie: movie)),
      ),
      child: Container(
        height: 200,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            // Movie Poster
            Hero(
              tag: 'now_${movie.id}',
              child: Container(
                width: 130,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(24)),
                  image: DecorationImage(
                    image: NetworkImage(movie.posterUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Movie Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildFormatBadge(index: movie.id.length % 2, l10n: l10n, theme: theme),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Colors.orange, size: 16),
                            const SizedBox(width: 4),
                            Text(movie.rating.toString(), style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      movie.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      movie.genre.split('|')[0],
                      style: theme.textTheme.bodySmall,
                    ),
                    const Spacer(),
                    // Showtimes row
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: movie.showTimes.take(3).map((time) => _buildTimeChip(time, theme)).toList(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Trailer Button
                    Row(
                      children: [
                        Icon(Icons.play_circle_fill_rounded, color: theme.colorScheme.primary, size: 18),
                        const SizedBox(width: 6),
                        Text(l10n.watchTrailer, style: TextStyle(color: theme.colorScheme.primary, fontSize: 12, fontWeight: FontWeight.bold)),
                        const Spacer(),
                        Icon(Icons.arrow_forward_rounded, color: theme.dividerColor.withOpacity(0.2), size: 16),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormatBadge({required int index, required AppLocalizations l10n, required ThemeData theme}) {  
    final format = index == 0 ? l10n.imax : l10n.standard;
    final color = index == 0 ? const Color(0xFF00B0FF) : theme.colorScheme.onSurface.withOpacity(0.4);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        format,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
      ),
    );
  }

  Widget _buildTimeChip(DateTime time, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.dividerColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        "${time.hour}:${time.minute.toString().padLeft(2, '0')}",
        style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
