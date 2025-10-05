import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waslaacademy/src/constants/app_colors.dart';
import 'package:waslaacademy/src/widgets/custom_app_bar.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  // Mock user experience points
  final int _experiencePoints = 1250;

  // Mock badges
  final List<Map<String, dynamic>> _allBadges = [
    {
      'id': 1,
      'name': 'مبتدئ',
      'icon': Icons.star,
      'earned': true,
      'inProgress': false,
      'description': 'أكمل أول درس في أي كورس'
    },
    {
      'id': 2,
      'name': 'متعلم نشط',
      'icon': Icons.local_fire_department,
      'earned': true,
      'inProgress': false,
      'description': 'شاهد 10 دروس في أسبوع واحد'
    },
    {
      'id': 3,
      'name': 'أول كورس',
      'icon': Icons.emoji_events,
      'earned': true,
      'inProgress': false,
      'description': 'أكمل أول كورس بالكامل'
    },
    {
      'id': 4,
      'name': 'قارئ نهماك',
      'icon': Icons.book,
      'earned': false,
      'inProgress': true,
      'description': 'اقرأ جميع المراجع الإضافية (7/10)',
      'progress': 70
    },
    {
      'id': 5,
      'name': 'مطور محترف',
      'icon': Icons.code,
      'earned': false,
      'inProgress': true,
      'description': 'أكمل 3 مشاريع تطبيقية (1/3)',
      'progress': 33
    },
    {
      'id': 6,
      'name': 'مشارك نشط',
      'icon': Icons.comment,
      'earned': false,
      'inProgress': true,
      'description': 'شارك في 5 مناقشات (2/5)',
      'progress': 40
    },
    {
      'id': 7,
      'name': 'مبتكر',
      'icon': Icons.lightbulb,
      'earned': false,
      'inProgress': true,
      'description': 'اقترح 3 أفكار جديدة (0/3)',
      'progress': 0
    },
    {
      'id': 8,
      'name': 'خريج',
      'icon': Icons.school,
      'earned': false,
      'inProgress': false,
      'description': 'أكمل 5 كورسات مختلفة'
    },
  ];

  // Mock learning paths
  final List<Map<String, dynamic>> _learningPaths = [
    {
      'id': 1,
      'title': 'مطور ويب مبتدئ',
      'description': 'إتقان أساسيات HTML و CSS و JavaScript',
      'progress': 100,
      'completed': true
    },
    {
      'id': 2,
      'title': 'متخصص بايثون',
      'description': 'إتقان برمجة بايثون الأساسية والمتقدمة',
      'progress': 100,
      'completed': true
    },
    {
      'id': 3,
      'title': 'مطور تطبيقات الجوال',
      'description': 'بناء تطبيقات الجوال باستخدام React Native',
      'progress': 65,
      'completed': false
    },
    {
      'id': 4,
      'title': 'خبير البيانات',
      'description': 'تحليل البيانات وتعلم الآلة باستخدام بايثون',
      'progress': 30,
      'completed': false
    },
  ];

  @override
  Widget build(BuildContext context) {
    final earnedBadges =
        _allBadges.where((badge) => badge['earned'] == true).toList();
    final inProgressBadges =
        _allBadges.where((badge) => badge['inProgress'] == true).toList();
    final completedPaths =
        _learningPaths.where((path) => path['completed'] == true).toList();
    final inProgressPaths =
        _learningPaths.where((path) => path['completed'] == false).toList();

    return Scaffold(
      appBar: CustomAppBar(
        title: 'إنجازاتي',
        onBack: () => Navigator.pop(context),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        return SingleChildScrollView(
          padding: EdgeInsets.all(isTablet ? 24.w : 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Experience points
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(isTablet ? 24.w : 16.w),
                  child: Column(
                    children: [
                      Text(
                        'نقاط الخبرة',
                        style: TextStyle(
                          fontSize: isTablet ? 22.sp : 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        _experiencePoints.toString(),
                        style: TextStyle(
                          fontSize: isTablet ? 60.sp : 48.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.warning,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'نقطة',
                        style: TextStyle(
                          fontSize: isTablet ? 20.sp : 16.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              // Earned badges
              Text(
                'الشارات المكتسبة',
                style: TextStyle(
                  fontSize: isTablet ? 22.sp : 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),

              if (earnedBadges.isEmpty) ...[
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.emoji_events_outlined,
                        size: isTablet ? 80.sp : 60.sp,
                        color: Colors.grey[300],
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'لم تكسب أي شارات بعد',
                        style: TextStyle(
                          fontSize: isTablet ? 20.sp : 16.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Wrap(
                  spacing: 16.w,
                  runSpacing: 16.h,
                  children: earnedBadges
                      .map((badge) => _buildBadgeItem(badge, isTablet))
                      .toList(),
                ),
              ],

              SizedBox(height: 24.h),

              // In-progress badges
              Text(
                'الشارات قيد التقدم',
                style: TextStyle(
                  fontSize: isTablet ? 22.sp : 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),

              if (inProgressBadges.isEmpty) ...[
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.hourglass_empty,
                        size: isTablet ? 80.sp : 60.sp,
                        color: Colors.grey[300],
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'لا توجد شارات قيد التقدم',
                        style: TextStyle(
                          fontSize: isTablet ? 20.sp : 16.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Wrap(
                  spacing: 16.w,
                  runSpacing: 16.h,
                  children: inProgressBadges
                      .map((badge) => _buildBadgeItem(badge, isTablet))
                      .toList(),
                ),
              ],

              SizedBox(height: 24.h),

              // Completed learning paths
              Text(
                'مسارات التعلم المكتملة',
                style: TextStyle(
                  fontSize: isTablet ? 22.sp : 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),

              if (completedPaths.isEmpty) ...[
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.emoji_events_outlined,
                        size: isTablet ? 80.sp : 60.sp,
                        color: Colors.grey[300],
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'لم تكمل أي مسارات تعلم بعد',
                        style: TextStyle(
                          fontSize: isTablet ? 20.sp : 16.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                ...completedPaths
                    .map((path) => _buildLearningPathCard(path, isTablet))
                    ,
              ],

              SizedBox(height: 24.h),

              // In-progress learning paths
              Text(
                'مسارات التعلم قيد التقدم',
                style: TextStyle(
                  fontSize: isTablet ? 22.sp : 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),

              if (inProgressPaths.isEmpty) ...[
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.hourglass_empty,
                        size: isTablet ? 80.sp : 60.sp,
                        color: Colors.grey[300],
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'لا توجد مسارات تعلم قيد التقدم',
                        style: TextStyle(
                          fontSize: isTablet ? 20.sp : 16.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                ...inProgressPaths
                    .map((path) => _buildLearningPathCard(path, isTablet))
                    ,
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildBadgeItem(Map<String, dynamic> badge, bool isTablet) {
    return Column(
      children: [
        Container(
          width: isTablet ? 120.w : 80.w,
          height: isTablet ? 120.h : 80.h,
          decoration: BoxDecoration(
            color: badge['earned']
                ? AppColors.primary
                : (badge['inProgress'] ? AppColors.warning : AppColors.light),
            shape: BoxShape.circle,
          ),
          child: Icon(
            badge['icon'],
            color: Colors.white,
            size: isTablet ? 60.sp : 40.sp,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          badge['name'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isTablet ? 18.sp : 14.sp,
          ),
        ),
        if (badge['inProgress'])
          Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Text(
              '${badge['progress']}%',
              style: TextStyle(
                fontSize: isTablet ? 16.sp : 12.sp,
                color: Colors.grey,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLearningPathCard(Map<String, dynamic> path, bool isTablet) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 24.w : 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        path['title'],
                        style: TextStyle(
                          fontSize: isTablet ? 22.sp : 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        path['description'],
                        style: TextStyle(
                          fontSize: isTablet ? 18.sp : 14.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                if (path['completed'])
                  Container(
                    padding: EdgeInsets.all(isTablet ? 12.w : 8.w),
                    decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: isTablet ? 28.sp : 20.sp,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'التقدم',
                        style: TextStyle(
                          fontSize: isTablet ? 18.sp : 14.sp,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4.r),
                        child: LinearProgressIndicator(
                          value: path['progress'] / 100,
                          backgroundColor: AppColors.light,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            path['completed']
                                ? AppColors.success
                                : AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  '${path['progress']}%',
                  style: TextStyle(
                    fontSize: isTablet ? 18.sp : 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}