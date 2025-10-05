import 'package:flutter/material.dart';
import 'package:waslaacademy/src/constants/app_colors.dart';
import 'package:waslaacademy/src/constants/app_sizes.dart';
import 'package:waslaacademy/src/constants/app_text_styles.dart';
import 'package:waslaacademy/src/utils/responsive_helper.dart';
import 'package:waslaacademy/src/models/live_lecture.dart';
import 'package:waslaacademy/src/widgets/live_lecture_card.dart';
import 'package:waslaacademy/src/widgets/empty_state.dart';
import 'package:waslaacademy/src/widgets/custom_app_bar.dart';

class LiveLecturesScreen extends StatefulWidget {
  const LiveLecturesScreen({super.key});

  @override
  State<LiveLecturesScreen> createState() => _LiveLecturesScreenState();
}

class _LiveLecturesScreenState extends State<LiveLecturesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<LiveLecture> _liveLectures = [];
  List<LiveLecture> _upcomingLectures = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadLectures();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadLectures() {
    // Mock lectures data
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _liveLectures = [
          LiveLecture(
            id: 'live_1',
            title: 'أساسيات البرمجة بـ Python',
            description: 'تعلم أساسيات البرمجة باستخدام لغة Python من الصفر',
            instructorName: 'د. أحمد محمد',
            instructorId: 'instructor_1',
            instructorImage: 'https://example.com/instructor1.jpg',
            startTime: DateTime.now().subtract(const Duration(minutes: 30)),
            estimatedDuration: 90,
            thumbnailUrl: 'https://example.com/thumb1.jpg',
            viewerCount: 245,
            status: LectureStatus.live,
            tags: const ['برمجة', 'Python', 'مبتدئ'],
          ),
          LiveLecture(
            id: 'live_2',
            title: 'تطوير تطبيقات الويب بـ React',
            description: 'تعلم كيفية بناء تطبيقات ويب تفاعلية باستخدام React',
            instructorName: 'م. سارة أحمد',
            instructorId: 'instructor_2',
            instructorImage: 'https://example.com/instructor2.jpg',
            startTime: DateTime.now().subtract(const Duration(minutes: 15)),
            estimatedDuration: 120,
            thumbnailUrl: 'https://example.com/thumb2.jpg',
            viewerCount: 189,
            status: LectureStatus.live,
            tags: const ['ويب', 'React', 'JavaScript'],
          ),
        ];

        _upcomingLectures = [
          LiveLecture(
            id: 'upcoming_1',
            title: 'تصميم قواعد البيانات',
            description: 'تعلم كيفية تصميم قواعد البيانات الفعالة',
            instructorName: 'د. خالد يوسف',
            instructorId: 'instructor_3',
            instructorImage: 'https://example.com/instructor3.jpg',
            startTime: DateTime.now().add(const Duration(hours: 2)),
            estimatedDuration: 75,
            thumbnailUrl: 'https://example.com/thumb3.jpg',
            viewerCount: 0,
            status: LectureStatus.scheduled,
            tags: const ['قواعد البيانات', 'SQL'],
          ),
          LiveLecture(
            id: 'upcoming_2',
            title: 'أمان المعلومات والشبكات',
            description: 'مقدمة في أمان المعلومات وحماية الشبكات',
            instructorName: 'أ. فاطمة حسن',
            instructorId: 'instructor_4',
            instructorImage: 'https://example.com/instructor4.jpg',
            startTime: DateTime.now().add(const Duration(hours: 4)),
            estimatedDuration: 100,
            thumbnailUrl: 'https://example.com/thumb4.jpg',
            viewerCount: 0,
            status: LectureStatus.scheduled,
            tags: const ['أمان', 'شبكات'],
          ),
          LiveLecture(
            id: 'upcoming_3',
            title: 'تطوير تطبيقات الموبايل بـ Flutter',
            description: 'تعلم تطوير تطبيقات الموبايل متعددة المنصات',
            instructorName: 'م. عمر علي',
            instructorId: 'instructor_5',
            instructorImage: 'https://example.com/instructor5.jpg',
            startTime: DateTime.now().add(const Duration(days: 1)),
            estimatedDuration: 150,
            thumbnailUrl: 'https://example.com/thumb5.jpg',
            viewerCount: 0,
            status: LectureStatus.scheduled,
            tags: const ['موبايل', 'Flutter', 'Dart'],
          ),
        ];

        _isLoading = false;
      });
    });
  }

  void _joinLecture(LiveLecture lecture) {
    // Show join confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.spaceSmall),
              decoration: BoxDecoration(
                color: AppColors.danger.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.live_tv,
                color: AppColors.danger,
                size: AppSizes.iconMedium,
              ),
            ),
            const SizedBox(width: AppSizes.spaceMedium),
            Expanded(
              child: Text(
                'انضمام للمحاضرة',
                style: AppTextStyles.headline3(context),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'هل تريد الانضمام إلى محاضرة "${lecture.title}"؟',
              style: AppTextStyles.bodyLarge(context),
            ),
            const SizedBox(height: AppSizes.spaceMedium),
            Container(
              padding: const EdgeInsets.all(AppSizes.spaceMedium),
              decoration: BoxDecoration(
                color: AppColors.light,
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.person,
                        size: AppSizes.iconSmall,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: AppSizes.spaceSmall),
                      Text(
                        'المدرب: ${lecture.instructorName}',
                        style: AppTextStyles.bodyMedium(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.spaceSmall),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: AppSizes.iconSmall,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: AppSizes.spaceSmall),
                      Text(
                        'المدة: ${lecture.getDurationText()}',
                        style: AppTextStyles.bodyMedium(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.spaceSmall),
                  Row(
                    children: [
                      const Icon(
                        Icons.visibility,
                        size: AppSizes.iconSmall,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: AppSizes.spaceSmall),
                      Text(
                        'المشاهدون: ${lecture.viewerCount}',
                        style: AppTextStyles.bodyMedium(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'إلغاء',
              style: AppTextStyles.buttonMedium(context).copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _performJoinLecture(lecture);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              ),
            ),
            child: Text(
              'انضمام',
              style: AppTextStyles.buttonMedium(context),
            ),
          ),
        ],
      ),
    );
  }

  void _performJoinLecture(LiveLecture lecture) {
    // Show loading and simulate joining
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: AppSizes.spaceLarge),
            Text(
              'جاري الانضمام للمحاضرة...',
              style: AppTextStyles.bodyLarge(context),
            ),
          ],
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تم الانضمام للمحاضرة بنجاح',
            style:
                AppTextStyles.bodyLarge(context).copyWith(color: Colors.white),
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
        ),
      );
    });
  }

  void _setReminder(LiveLecture lecture) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        ),
        title: Row(
          children: [
            const Icon(
              Icons.notifications,
              color: AppColors.primary,
              size: AppSizes.iconMedium,
            ),
            const SizedBox(width: AppSizes.spaceMedium),
            Text(
              'تذكير',
              style: AppTextStyles.headline3(context),
            ),
          ],
        ),
        content: Text(
          'هل تريد تعيين تذكير لمحاضرة "${lecture.title}"؟\n\nسيتم إرسال إشعار قبل بداية المحاضرة بـ 15 دقيقة.',
          style: AppTextStyles.bodyLarge(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'إلغاء',
              style: AppTextStyles.buttonMedium(context).copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();

              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'تم تعيين التذكير بنجاح',
                    style: AppTextStyles.bodyLarge(context)
                        .copyWith(color: Colors.white),
                  ),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              ),
            ),
            child: Text(
              'تعيين تذكير',
              style: AppTextStyles.buttonMedium(context),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenPadding = ResponsiveHelper.getScreenPadding(context);

    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: CustomAppBar(
        title: 'المحاضرات المباشرة',
        showAuthIcons: true,
        actions: [
          IconButton(
            onPressed: _loadLectures,
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'تحديث',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelStyle: AppTextStyles.labelLarge(context),
              unselectedLabelStyle: AppTextStyles.labelMedium(context),
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.danger,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: AppSizes.spaceSmall),
                      const Text('مباشر الآن'),
                    ],
                  ),
                ),
                const Tab(text: 'قادمة'),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    controller: _tabController,
                    children: [
                      // Live Now Tab
                      _liveLectures.isEmpty
                          ? EmptyState.noLiveLectures(
                              onRefresh: _loadLectures,
                            )
                          : ListView.builder(
                              padding: screenPadding,
                              itemCount: _liveLectures.length,
                              itemBuilder: (context, index) {
                                final lecture = _liveLectures[index];
                                return LiveLectureCard(
                                  title: lecture.title,
                                  instructorName: lecture.instructorName,
                                  instructorImage: lecture.instructorImage,
                                  thumbnailUrl: lecture.thumbnailUrl,
                                  viewerCount: lecture.viewerCount,
                                  isLive: lecture.isLive,
                                  onJoin: () => _joinLecture(lecture),
                                );
                              },
                            ),

                      // Upcoming Tab
                      _upcomingLectures.isEmpty
                          ? EmptyState(
                              icon: Icons.schedule,
                              title: 'لا توجد محاضرات قادمة',
                              subtitle:
                                  'لا توجد محاضرات مجدولة في الوقت الحالي',
                              actionText: 'تحديث',
                              onActionPressed: _loadLectures,
                              iconColor: AppColors.primary,
                            )
                          : ListView.builder(
                              padding: screenPadding,
                              itemCount: _upcomingLectures.length,
                              itemBuilder: (context, index) {
                                final lecture = _upcomingLectures[index];
                                return LiveLectureCard(
                                  title: lecture.title,
                                  instructorName: lecture.instructorName,
                                  instructorImage: lecture.instructorImage,
                                  thumbnailUrl: lecture.thumbnailUrl,
                                  viewerCount: lecture.viewerCount,
                                  startTime: lecture.startTime,
                                  isLive: false,
                                  onReminder: () => _setReminder(lecture),
                                );
                              },
                            ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
