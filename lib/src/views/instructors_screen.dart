import 'package:flutter/material.dart';
import 'package:waslaacademy/src/constants/app_colors.dart';
import 'package:waslaacademy/src/widgets/custom_app_bar.dart';

class InstructorsScreen extends StatefulWidget {
  const InstructorsScreen({super.key});

  @override
  State<InstructorsScreen> createState() => _InstructorsScreenState();
}

class _InstructorsScreenState extends State<InstructorsScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Mock instructors data
  final List<Map<String, dynamic>> _allInstructors = [
    {
      'id': 1,
      'name': 'سارة أحمد',
      'specialty': 'برمجة بايثون',
      'rating': 4.8,
      'students': 2456,
      'experience': '5 سنوات',
      'bio':
          'مدربة متخصصة في برمجة بايثون مع خبرة تزيد عن 5 سنوات في تطوير تطبيقات الويب.',
      'image': 'https://randomuser.me/api/portraits/women/1.jpg',
      'courses': [1]
    },
    {
      'id': 2,
      'name': 'أحمد محمد',
      'specialty': 'تطوير الواجهات الأمامية',
      'rating': 4.7,
      'students': 1876,
      'experience': '7 سنوات',
      'bio':
          'مطور متخصص في الواجهات الأمامية وخبير في React ومكتبات JavaScript الحديثة.',
      'image': 'https://randomuser.me/api/portraits/men/1.jpg',
      'courses': [2]
    },
    {
      'id': 3,
      'name': 'مريم عبدالله',
      'specialty': 'اللغات',
      'rating': 4.9,
      'students': 3241,
      'experience': '8 سنوات',
      'bio':
          'مدربة لغات محترفة مع خبرة واسعة في تعليم اللغة الإنجليزية للمبتدئين والمتقدمين.',
      'image': 'https://randomuser.me/api/portraits/women/2.jpg',
      'courses': [3]
    },
    {
      'id': 4,
      'name': 'خالد السعيد',
      'specialty': 'القيادة والإدارة',
      'rating': 4.6,
      'students': 1243,
      'experience': '10 سنوات',
      'bio':
          'خبير في تطوير القيادات وإدارة الفرق مع خبرة تزيد عن 10 سنوات في الشركات الكبرى.',
      'image': 'https://randomuser.me/api/portraits/men/3.jpg',
      'courses': [4]
    },
    {
      'id': 5,
      'name': 'نورة السالم',
      'specialty': 'التسويق الرقمي',
      'rating': 4.8,
      'students': 2156,
      'experience': '6 سنوات',
      'bio':
          'متخصصة في التسويق الرقمي وخبيرة في استراتيجيات التسويق عبر وسائل التواصل الاجتماعي.',
      'image': 'https://randomuser.me/api/portraits/women/3.jpg',
      'courses': [5]
    },
    {
      'id': 6,
      'name': 'فهد العتيبي',
      'specialty': 'تصميم واجهات المستخدم',
      'rating': 4.5,
      'students': 1543,
      'experience': '4 سنوات',
      'bio':
          'مصمم واجهات مستخدم محترف مع خبرة في استخدام أحدث أدوات التصميم مثل Figma.',
      'image': 'https://randomuser.me/api/portraits/men/4.jpg',
      'courses': [6]
    },
  ];

  List<Map<String, dynamic>> _filteredInstructors = [];

  @override
  void initState() {
    super.initState();
    _filteredInstructors = _allInstructors;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterInstructors(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredInstructors = _allInstructors;
      } else {
        _filteredInstructors = _allInstructors
            .where((instructor) =>
                instructor['name']
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                instructor['specialty']
                    .toLowerCase()
                    .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'المدربون',
        onBack: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ابحث عن مدرب...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: _filterInstructors,
            ),
          ),

          // Instructors list
          Expanded(
            child: _filteredInstructors.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 80,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'لا توجد نتائج مطابقة',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'جرب البحث باسم مدرب أو تخصص مختلف',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredInstructors.length,
                    itemBuilder: (context, index) {
                      return _buildInstructorCard(_filteredInstructors[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructorCard(Map<String, dynamic> instructor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Instructor image
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(instructor['image']),
              onBackgroundImageError: (exception, stackTrace) {
                // Handle image load error
              },
            ),
            const SizedBox(width: 12),

            // Instructor info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    instructor['name'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    instructor['specialty'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 16,
                        color: AppColors.warning,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        instructor['rating'].toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '•',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${instructor['students']} طالب',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // View button
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to instructor detail screen
                _showInstructorDetails(instructor);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              child: const Text('عرض'),
            ),
          ],
        ),
      ),
    );
  }

  void _showInstructorDetails(Map<String, dynamic> instructor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(instructor['name']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(instructor['image']),
                onBackgroundImageError: (exception, stackTrace) {
                  // Handle image load error
                },
              ),
              const SizedBox(height: 16),
              Text('التخصص: ${instructor['specialty']}'),
              const SizedBox(height: 8),
              Text('الخبرة: ${instructor['experience']}'),
              const SizedBox(height: 8),
              Text('الطلاب: ${instructor['students']}'),
              const SizedBox(height: 8),
              Text('التقييم: ${instructor['rating']}'),
              const SizedBox(height: 16),
              const Text('الوصف:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(instructor['bio']),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('إغلاق'),
            ),
          ],
        );
      },
    );
  }
}
