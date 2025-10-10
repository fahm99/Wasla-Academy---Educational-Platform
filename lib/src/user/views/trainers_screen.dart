import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waslaacademy/src/user/constants/app_colors.dart';
import 'package:waslaacademy/src/user/widgets/custom_app_bar.dart';

class TrainersScreen extends StatefulWidget {
  const TrainersScreen({super.key});

  @override
  State<TrainersScreen> createState() => _TrainersScreenState();
}

class _TrainersScreenState extends State<TrainersScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> _trainers = [
    {
      'name': 'سارة أحمد',
      'specialty': 'برمجة بايثون',
      'image': 'https://randomuser.me/api/portraits/women/1.jpg',
      'rating': 4.7,
      'students': '1,245+',
      'experience': '8+ سنوات',
      'education': 'بكالوريوس علوم الحاسب - جامعة تعز',
    },
    {
      'name': 'أحمد محمد',
      'specialty': 'تطوير تطبيقات الويب',
      'image': 'https://randomuser.me/api/portraits/men/1.jpg',
      'rating': 4.8,
      'students': '856+',
      'experience': '10+ سنوات',
      'education': 'ماجستير علوم الحاسب - جامعة العلوم والتكنولوجيا',
    },
    {
      'name': 'مريم عبدالله',
      'specialty': 'اللغة الإنجليزية',
      'image': 'https://randomuser.me/api/portraits/women/2.jpg',
      'rating': 4.3,
      'students': '2,156+',
      'experience': '12+ سنة',
      'education': 'بكالوريوس اللغة الإنجليزية - جامعة الوطنية',
    },
    {
      'name': 'خالد السعيد',
      'specialty': 'مهارات القيادة',
      'image': 'https://randomuser.me/api/portraits/men/3.jpg',
      'rating': 4.6,
      'students': '642+',
      'experience': '15+ سنة',
      'education': 'ماجستير إدارة الأعمال - جامعة هارفارد',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'المدربون',
        onBack: () {
          Navigator.pop(context);
        },
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: EdgeInsets.all(16.w),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ابحث عن مدرب...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.r),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
                hintStyle: TextStyle(fontSize: 14.sp),
              ),
              style: TextStyle(fontSize: 14.sp),
            ),
          ),
          // Trainers list
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: _trainers.length,
              itemBuilder: (context, index) {
                final trainer = _trainers[index];
                return _buildTrainerCard(trainer);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainerCard(Map<String, dynamic> trainer) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      elevation: 2,
      child: ListTile(
        contentPadding: EdgeInsets.all(16.w),
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(trainer['image']),
          onBackgroundImageError: (exception, stackTrace) {
            // Handle image load error
          },
        ),
        title: Text(
          trainer['name'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
            color: AppColors.dark,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              trainer['specialty'],
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Icon(
                  Icons.star,
                  size: 14.sp,
                  color: AppColors.warning,
                ),
                SizedBox(width: 4.w),
                Text(
                  trainer['rating'].toString(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.dark,
                  ),
                ),
                SizedBox(width: 12.w),
                Icon(
                  Icons.people,
                  size: 14.sp,
                  color: AppColors.primary,
                ),
                SizedBox(width: 4.w),
                Text(
                  '${trainer['students']} طالب',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.dark,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Icon(
                  Icons.work,
                  size: 14.sp,
                  color: AppColors.primary,
                ),
                SizedBox(width: 4.w),
                Text(
                  trainer['experience'],
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.dark,
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          // TODO: Show trainer details
        },
      ),
    );
  }
}
