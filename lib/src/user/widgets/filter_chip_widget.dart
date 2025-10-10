import 'package:flutter/material.dart';
import 'package:waslaacademy/src/user/constants/app_colors.dart';
import 'package:waslaacademy/src/user/constants/app_sizes.dart';
import 'package:waslaacademy/src/user/constants/app_text_styles.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final IconData? icon;
  final Color? selectedColor;
  final Color? unselectedColor;

  const FilterChipWidget({
    super.key,
    required this.label,
    required this.isSelected,
    this.onTap,
    this.icon,
    this.selectedColor,
    this.unselectedColor,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isSelected
        ? (selectedColor ?? AppColors.primary)
        : (unselectedColor ?? const Color(0xFFF3F4F6));

    final textColor = isSelected ? Colors.white : AppColors.textPrimary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusXXLarge),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spaceMedium,
            vertical: AppSizes.spaceSmall,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(AppSizes.radiusXXLarge),
            border: isSelected
                ? null
                : Border.all(
                    color: AppColors.textLight.withOpacity(0.3),
                    width: 1,
                  ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: AppSizes.iconSmall,
                  color: textColor,
                ),
                const SizedBox(width: AppSizes.spaceXSmall),
              ],
              Text(
                label,
                style: AppTextStyles.labelMedium(context).copyWith(
                  color: textColor,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// مجموعة من رقاقات الفلتر القابلة للتمرير أفقياً
class FilterChipGroup extends StatelessWidget {
  final List<String> options;
  final String? selectedOption;
  final Function(String)? onSelectionChanged;
  final EdgeInsetsGeometry? padding;
  final double spacing;

  const FilterChipGroup({
    super.key,
    required this.options,
    this.selectedOption,
    this.onSelectionChanged,
    this.padding,
    this.spacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding ??
          const EdgeInsets.symmetric(horizontal: AppSizes.screenPaddingMobile),
      child: Row(
        children: options.map((option) {
          final isSelected = selectedOption == option;
          return Padding(
            padding: EdgeInsets.only(right: spacing),
            child: FilterChipWidget(
              label: option,
              isSelected: isSelected,
              onTap: () => onSelectionChanged?.call(option),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// مجموعة من رقاقات الفلتر متعددة الاختيار
class MultiSelectFilterChipGroup extends StatelessWidget {
  final List<String> options;
  final List<String> selectedOptions;
  final Function(List<String>)? onSelectionChanged;
  final EdgeInsetsGeometry? padding;
  final double spacing;
  final bool wrap;

  const MultiSelectFilterChipGroup({
    super.key,
    required this.options,
    required this.selectedOptions,
    this.onSelectionChanged,
    this.padding,
    this.spacing = 8.0,
    this.wrap = false,
  });

  void _toggleSelection(String option) {
    final newSelection = List<String>.from(selectedOptions);
    if (newSelection.contains(option)) {
      newSelection.remove(option);
    } else {
      newSelection.add(option);
    }
    onSelectionChanged?.call(newSelection);
  }

  @override
  Widget build(BuildContext context) {
    if (wrap) {
      return Padding(
        padding: padding ??
            const EdgeInsets.symmetric(horizontal: AppSizes.screenPaddingMobile),
        child: Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: options.map((option) {
            final isSelected = selectedOptions.contains(option);
            return FilterChipWidget(
              label: option,
              isSelected: isSelected,
              onTap: () => _toggleSelection(option),
            );
          }).toList(),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding ??
          const EdgeInsets.symmetric(horizontal: AppSizes.screenPaddingMobile),
      child: Row(
        children: options.map((option) {
          final isSelected = selectedOptions.contains(option);
          return Padding(
            padding: EdgeInsets.only(right: spacing),
            child: FilterChipWidget(
              label: option,
              isSelected: isSelected,
              onTap: () => _toggleSelection(option),
            ),
          );
        }).toList(),
      ),
    );
  }
}
