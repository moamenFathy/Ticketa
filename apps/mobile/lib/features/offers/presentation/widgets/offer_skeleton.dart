import 'package:flutter/material.dart';
import 'package:ticketa/core/widgets/app_shimmer.dart';

class OfferSkeleton extends StatelessWidget {
  const OfferSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          height: 160,
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                AppShimmer(width: 80, height: 24, borderRadius: 10),
                SizedBox(height: 16),
                AppShimmer(width: 200, height: 24),
                SizedBox(height: 12),
                AppShimmer(width: 140, height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
