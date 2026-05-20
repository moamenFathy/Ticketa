import 'package:flutter/material.dart';
import 'package:ticketa/core/widgets/app_shimmer.dart';

class NowShowingSkeleton extends StatelessWidget {
  const NowShowingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 10, bottom: 120),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          height: 200,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.05)),
          ),
          child: Row(
            children: [
              // Poster Skeleton
              const AppShimmer(
                width: 130,
                height: 200,
                borderRadius: 24, // Matches container roughly for left side
              ),
              
              // Details Skeleton
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          AppShimmer(width: 50, height: 20),
                          AppShimmer(width: 30, height: 20),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const AppShimmer(width: 140, height: 24),
                      const SizedBox(height: 4),
                      const AppShimmer(width: 80, height: 16),
                      const Spacer(),
                      // Showtimes Skeleton
                      Row(
                        children: const [
                          AppShimmer(width: 50, height: 24, borderRadius: 10),
                          SizedBox(width: 6),
                          AppShimmer(width: 50, height: 24, borderRadius: 10),
                          SizedBox(width: 6),
                          AppShimmer(width: 50, height: 24, borderRadius: 10),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Trailer Button Skeleton
                      const AppShimmer(width: 100, height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
