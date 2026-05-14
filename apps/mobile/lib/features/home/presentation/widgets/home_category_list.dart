import 'package:flutter/material.dart';
import 'package:ticketa/core/theme/app_colors.dart';

class HomeCategoryList extends StatefulWidget {
  const HomeCategoryList({super.key});

  @override
  State<HomeCategoryList> createState() => _HomeCategoryListState();
}

class _HomeCategoryListState extends State<HomeCategoryList> {
  final List<String> _categories = ["Action", "Sci-Fi", "Drama", "Comedy", "Horror", "Animation"];
  int _selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 25),
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 20),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedCategoryIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategoryIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.warmOrange : theme.colorScheme.onSurface.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? Colors.transparent : theme.colorScheme.onSurface.withOpacity(0.1),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                _categories[index],
                style: theme.textTheme.labelLarge?.copyWith(
                  color: isSelected ? Colors.white : theme.colorScheme.onSurface.withOpacity(0.6),
                  fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
