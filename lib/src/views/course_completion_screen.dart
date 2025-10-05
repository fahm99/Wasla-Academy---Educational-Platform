import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:waslaacademy/src/constants/app_colors.dart';
import 'package:waslaacademy/src/widgets/custom_app_bar.dart';

class CourseCompletionScreen extends StatefulWidget {
  final String courseName;
  final String studentName;

  const CourseCompletionScreen({
    super.key,
    required this.courseName,
    required this.studentName,
  });

  @override
  State<CourseCompletionScreen> createState() => _CourseCompletionScreenState();
}

class _CourseCompletionScreenState extends State<CourseCompletionScreen> {
  double _rating = 0.0;
  final TextEditingController _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _submitRating() {
    // In a real app, this would submit the rating to the server
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم إرسال التقييم بنجاح'),
        backgroundColor: AppColors.success,
      ),
    );

    // Navigate back to my courses
    Navigator.pop(context); // Close completion screen
    Navigator.pop(context); // Close course player
  }

  Future<void> _downloadCertificate() async {
    // Show a snackbar to indicate the download has started
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('جاري تحميل الشهادة...'),
        duration: Duration(seconds: 2),
      ),
    );

    // TODO: Implement actual certificate download logic
    // This would typically involve generating a PDF certificate
    // and saving it to the device or sharing it via the share sheet

    // For now, we'll just show a success message
    await Future.delayed(const Duration(seconds: 2));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم تحميل الشهادة بنجاح'),
        backgroundColor: AppColors.success,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'إكمال الدورة',
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        return SingleChildScrollView(
          padding: EdgeInsets.all(isTablet ? 24.w : 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'تهانينا! لقد أكملت الدورة "${widget.courseName}"',
                style: TextStyle(
                  fontSize: isTablet ? 28.sp : 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: isTablet ? 20.h : 16.h),
              Text(
                'شكراً لك ${widget.studentName} على إكمال الدورة!',
                style: TextStyle(
                  fontSize: isTablet ? 22.sp : 18.sp,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: isTablet ? 40.h : 32.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StatItem(
                    value: '100%',
                    label: 'النسبة المئوية',
                    color: AppColors.primary,
                    isTablet: isTablet,
                  ),
                  _StatItem(
                    value: '5',
                    label: 'عدد الدروس',
                    color: AppColors.secondary,
                    isTablet: isTablet,
                  ),
                  _StatItem(
                    value: '2',
                    label: 'الاختبارات',
                    color: AppColors.primary,
                    isTablet: isTablet,
                  ),
                ],
              ),
              SizedBox(height: isTablet ? 40.h : 32.h),
              Text(
                'تقييم الدورة',
                style: TextStyle(
                  fontSize: isTablet ? 24.sp : 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: isTablet ? 12.h : 8.h),
              Slider(
                value: _rating,
                min: 0.0,
                max: 5.0,
                divisions: 5,
                label: _rating.toStringAsFixed(1),
                onChanged: (value) {
                  setState(() {
                    _rating = value;
                  });
                },
              ),
              SizedBox(height: isTablet ? 12.h : 8.h),
              TextField(
                controller: _reviewController,
                decoration: InputDecoration(
                  labelText: 'أكتب تعليقك هنا',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                maxLines: 4,
              ),
              SizedBox(height: isTablet ? 20.h : 16.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitRating,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: isTablet ? 16.h : 12.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'إرسال التقييم',
                    style: TextStyle(
                      fontSize: isTablet ? 18.sp : 16.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(height: isTablet ? 40.h : 32.h),
              Text(
                'شهادة الدورة',
                style: TextStyle(
                  fontSize: isTablet ? 24.sp : 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: isTablet ? 12.h : 8.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _downloadCertificate,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: isTablet ? 16.h : 12.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'تحميل الشهادة',
                    style: TextStyle(
                      fontSize: isTablet ? 18.sp : 16.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(height: isTablet ? 40.h : 32.h),
              Text(
                'شارك الدورة مع أصدقائك',
                style: TextStyle(
                  fontSize: isTablet ? 24.sp : 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: isTablet ? 16.h : 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SocialButton(
                    icon: Icons.facebook,
                    color: Colors.blue,
                    onPressed: () {
                      Share.share(
                        'شاركني في هذه الدورة الممتازة: ${widget.courseName}',
                      );
                    },
                    isTablet: isTablet,
                  ),
                  SizedBox(width: isTablet ? 20.w : 16.w),
                  _SocialButton(
                    icon: Icons.chat,
                    color: Colors.blue,
                    onPressed: () {
                      Share.share(
                        'شاركني في هذه الدورة الممتازة: ${widget.courseName}',
                      );
                    },
                    isTablet: isTablet,
                  ),
                  SizedBox(width: isTablet ? 20.w : 16.w),
                  _SocialButton(
                    icon: Icons.whatshot,
                    color: Colors.green,
                    onPressed: () {
                      Share.share(
                        'شاركني في هذه الدورة الممتازة: ${widget.courseName}',
                      );
                    },
                    isTablet: isTablet,
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final bool isTablet;

  const _StatItem({
    required this.value,
    required this.label,
    required this.color,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: isTablet ? 80.w : 60.w,
          height: isTablet ? 80.w : 60.w,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2.w),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontSize: isTablet ? 24.sp : 20.sp,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: TextStyle(
            fontSize: isTablet ? 18.sp : 14.sp,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final bool isTablet;

  const _SocialButton({
    required this.icon,
    required this.color,
    required this.onPressed,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isTablet ? 60.w : 50.w,
      height: isTablet ? 60.w : 50.w,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: Colors.white,
          size: isTablet ? 30.sp : 24.sp,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
