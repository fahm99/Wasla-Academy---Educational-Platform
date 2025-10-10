import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waslaacademy/src/user/constants/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final VoidCallback? onBack;
  final VoidCallback? onMenuPressed;
  final bool showAuthIcons; // New parameter to control auth icons visibility

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.onBack,
    this.onMenuPressed,
    this.showAuthIcons = true, // Default to true to maintain existing behavior
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isTablet = constraints.maxWidth > 600;
      return AppBar(
        backgroundColor: AppColors.primary,
        title: Row(
          children: [
          
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: isTablet ? 22.sp : 18.sp,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        centerTitle: false,
        leading: onMenuPressed != null
            ? IconButton(
                icon: Icon(
                  Icons.menu,
                  color: Colors.white,
                  size: isTablet ? 30.sp : 24.sp,
                ),
                onPressed: onMenuPressed,
              )
            : onBack != null
                ? IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: isTablet ? 30.sp : 24.sp,
                    ),
                    onPressed: onBack,
                  )
                : null,
        actions: [
          if (showAuthIcons) ...[
            // Search button
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
                size: isTablet ? 30.sp : 24.sp,
              ),
              onPressed: () {
                _showSearchDialog(context);
              },
            ),
            // Notifications button
            Stack(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.notifications,
                    color: Colors.white,
                    size: isTablet ? 30.sp : 24.sp,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/notifications');
                  },
                ),
                Positioned(
                  right: 5.w,
                  top: 5.h,
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: const BoxDecoration(
                      color: AppColors.danger,
                      shape: BoxShape.circle,
                    ),
                    constraints: BoxConstraints(
                      minWidth: 18.w,
                      minHeight: 18.w,
                    ),
                    child: Text(
                      '3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (actions != null) ...actions!,
        ],
        elevation: 0,
      );
    });
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.search,
                    color: AppColors.primary,
                    size: 28.sp,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'البحث',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              TextField(
                decoration: InputDecoration(
                  hintText: 'ابحث عن الكورسات والمحاضرات...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                ),
                autofocus: true,
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('إلغاء'),
                  ),
                  SizedBox(width: 12.w),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: Implement search functionality
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: const Text('بحث'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
