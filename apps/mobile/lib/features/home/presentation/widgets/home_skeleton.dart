import 'package:flutter/material.dart';
import 'package:ticketa/core/theme/app_colors.dart';
import 'package:ticketa/core/widgets/app_shimmer.dart';

class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
          top: false,
          bottom: false,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status bar spacing
                SizedBox(
                  height: MediaQuery.of(context).padding.top + 10,
                ),
                // ─── Hero: كارد كامل في النص + نص كارد يمين/شمال ───────
                const SizedBox(height: 10),
                const _HomeHeroSkeleton(),

                // ─── Page Indicators ──────────────────────────────────
                const SizedBox(height: 16),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(4, (i) {
                      final isActive = i == 1;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 6,
                        width: isActive ? 20 : 6,
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.warmOrange
                              : Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.3),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),
                ),

                // ─── Movie Info under hero ─────────────────────────────
                const SizedBox(height: 20),
                const Center(
                  child: AppShimmer(width: 200, height: 28, borderRadius: 8),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      AppShimmer(width: 60, height: 28, borderRadius: 14),
                      SizedBox(width: 10),
                      AppShimmer(width: 80, height: 28, borderRadius: 14),
                      SizedBox(width: 10),
                      AppShimmer(width: 60, height: 28, borderRadius: 14),
                    ],
                  ),
                ),

                // ─── Category Chips ───────────────────────────────────
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    children: List.generate(
                      4,
                      (i) => const Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: AppShimmer(width: 80, height: 36, borderRadius: 18),
                      ),
                    ),
                  ),
                ),

                // ─── Horizontal Movie List 1 ──────────────────────────
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      AppShimmer(width: 110, height: 20, borderRadius: 6),
                      AppShimmer(width: 55, height: 16, borderRadius: 6),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 210,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(left: 20),
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    itemBuilder: (_, __) => const Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: AppShimmer(width: 140, height: 210, borderRadius: 24),
                    ),
                  ),
                ),

                // ─── Horizontal Movie List 2 ──────────────────────────
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      AppShimmer(width: 110, height: 20, borderRadius: 6),
                      AppShimmer(width: 55, height: 16, borderRadius: 6),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 210,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(left: 20),
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    itemBuilder: (_, __) => const Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: AppShimmer(width: 140, height: 210, borderRadius: 24),
                    ),
                  ),
                ),

                const SizedBox(height: 120),
              ],
            ),
          ),
      ),
    );
  }
}

/// نفس أبعاد وتأثير الـ hero الحقيقي: كارد كامل في النص، والجانبين أصغر.
class _HomeHeroSkeleton extends StatefulWidget {
  const _HomeHeroSkeleton();

  @override
  State<_HomeHeroSkeleton> createState() => _HomeHeroSkeletonState();
}

class _HomeHeroSkeletonState extends State<_HomeHeroSkeleton> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.7, initialPage: 1);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 420,
      child: PageView.builder(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              double scale = 1.0;
              if (_controller.position.haveDimensions) {
                final delta = _controller.page! - index;
                scale = (1 - (delta.abs() * 0.2)).clamp(0.0, 1.0);
              }
              return Center(
                child: Transform.scale(
                  scale: scale,
                  child: child,
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: const AppShimmer(
                width: double.infinity,
                height: 400,
                borderRadius: 40,
              ),
            ),
          );
        },
      ),
    );
  }
}
