import 'package:flutter/material.dart';

class MovieCastList extends StatelessWidget {
  const MovieCastList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: theme.colorScheme.onSurface.withOpacity(0.1),
                  child: Icon(Icons.person, color: theme.colorScheme.onSurface.withOpacity(0.3)),
                ),
                const SizedBox(height: 8),
                Text(
                  "Actor ${index + 1}",
                  style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
