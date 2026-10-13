import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class GenreFilter extends StatelessWidget {
  const GenreFilter({
    required this.genres,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final List<String> genres;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: genres.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final genre = genres[index];
          final selectedItem = genre == selected;

          return GestureDetector(
            onTap: () => onSelected(genre),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: selectedItem ? AppColors.textPrimary : AppColors.panel,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: selectedItem
                      ? AppColors.textPrimary
                      : AppColors.divider,
                  width: 1,
                ),
              ),
              child: Text(
                genre,
                style: TextStyle(
                  color: selectedItem
                      ? AppColors.backgroundPrimary
                      : AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
