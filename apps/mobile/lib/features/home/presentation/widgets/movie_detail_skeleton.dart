import 'package:flutter/material.dart';
import 'package:ticketa/core/widgets/app_shimmer.dart';

class MovieDetailSkeleton extends StatelessWidget {
  const MovieDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster Area
            const AppShimmer(width: double.infinity, height: 400, borderRadius: 0),
            
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      AppShimmer(width: 200, height: 32),
                      AppShimmer(width: 50, height: 20),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Tags
                  Row(
                    children: const [
                      AppShimmer(width: 80, height: 30, borderRadius: 15),
                      SizedBox(width: 10),
                      AppShimmer(width: 80, height: 30, borderRadius: 15),
                      SizedBox(width: 10),
                      AppShimmer(width: 60, height: 30, borderRadius: 15),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // Synopsis
                  const AppShimmer(width: 120, height: 20),
                  const SizedBox(height: 12),
                  const AppShimmer(width: double.infinity, height: 14),
                  const SizedBox(height: 6),
                  const AppShimmer(width: double.infinity, height: 14),
                  const SizedBox(height: 6),
                  const AppShimmer(width: 200, height: 14),
                  
                  const SizedBox(height: 32),
                  
                  // Cast
                  const AppShimmer(width: 80, height: 20),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(4, (index) => const AppShimmer(width: 60, height: 60, borderRadius: 30)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
