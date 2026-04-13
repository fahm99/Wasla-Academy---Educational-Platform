import 'package:flutter/material.dart';
import 'package:waslaacademy/core/constants/app_colors.dart';
import 'package:waslaacademy/core/constants/app_sizes.dart';
import 'package:waslaacademy/core/constants/app_text_styles.dart';

/// Custom search bar widget with optional filter button
///
/// Usage:
/// ```dart
/// SearchBarWidget(
///   hintText: 'البحث عن الكورسات...',
///   onChanged: (value) {
///     print('Search: $value');
///   },
///   showFilter: true,
///   onFilterTap: () {
///     // Show filter dialog
///   },
/// )
/// ```
class SearchBarWidget extends StatefulWidget {
  final String? hintText;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final VoidCallback? onFilterTap;
  final bool showFilter;
  final TextEditingController? controller;
  final bool enabled;

  const SearchBarWidget({
    super.key,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.onFilterTap,
    this.showFilter = false,
    this.controller,
    this.enabled = true,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late TextEditingController _controller;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.searchBarHeight,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(AppSizes.radiusRound),
        border:
            _hasFocus ? Border.all(color: AppColors.primary, width: 1.5) : null,
      ),
      child: Row(
        children: [
          // Search Icon
          const Padding(
            padding: EdgeInsets.only(
              left: AppSizes.spaceLarge,
              right: AppSizes.spaceSmall,
            ),
            child: Icon(
              Icons.search,
              size: AppSizes.iconMedium,
              color: AppColors.textSecondary,
            ),
          ),

          // Search Input
          Expanded(
            child: Focus(
              onFocusChange: (hasFocus) {
                setState(() {
                  _hasFocus = hasFocus;
                });
              },
              child: TextField(
                controller: _controller,
                enabled: widget.enabled,
                onChanged: widget.onChanged,
                onSubmitted: widget.onSubmitted,
                style: AppTextStyles.bodyLarge(context),
                decoration: InputDecoration(
                  hintText: widget.hintText ?? 'البحث عن الكورسات...',
                  hintStyle: AppTextStyles.bodyLarge(context).copyWith(
                    color: AppColors.textLight,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: AppSizes.spaceMedium,
                  ),
                ),
              ),
            ),
          ),

          // Clear Button (when text exists)
          if (_controller.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: AppSizes.spaceSmall),
              child: InkWell(
                onTap: () {
                  _controller.clear();
                  widget.onChanged?.call('');
                  setState(() {});
                },
                borderRadius: BorderRadius.circular(AppSizes.iconSmall),
                child: const Padding(
                  padding: EdgeInsets.all(AppSizes.spaceXSmall),
                  child: Icon(
                    Icons.clear,
                    size: AppSizes.iconSmall,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),

          // Filter Button (optional)
          if (widget.showFilter)
            Padding(
              padding: const EdgeInsets.only(right: AppSizes.spaceMedium),
              child: InkWell(
                onTap: widget.onFilterTap,
                borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                child: Container(
                  padding: const EdgeInsets.all(AppSizes.spaceSmall),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                  ),
                  child: const Icon(
                    Icons.tune,
                    size: AppSizes.iconSmall,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
