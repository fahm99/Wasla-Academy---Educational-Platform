import 'package:flutter/material.dart';
import 'package:waslaacademy/src/user/constants/app_colors.dart';
import 'package:waslaacademy/src/user/widgets/custom_app_bar.dart';

class InstitutesScreen extends StatefulWidget {
  const InstitutesScreen({super.key});

  @override
  State<InstitutesScreen> createState() => _InstitutesScreenState();
}

class _InstitutesScreenState extends State<InstitutesScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Mock institutes data
  final List<Map<String, dynamic>> _allInstitutes = [
    {
      'id': 1,
      'name': 'معهد التقنية المتقدمة',
      'type': 'معهد تقني',
      'rating': 4.8,
      'students': 1200,
      'courses': 45,
      'description': 'معهد متخصص في التقنيات الحديثة والبرمجة',
      'image':
          'https://images.unsplash.com/photo-1562774053-701939374585?w=400',
      'location': 'صنعاء، اليمن'
    },
    {
      'id': 2,
      'name': 'معهد اللغات الدولي',
      'type': 'معهد لغات',
      'rating': 4.7,
      'students': 800,
      'courses': 32,
      'description': 'معهد متخصص في تعليم اللغات الأجنبية',
      'image':
          'https://images.unsplash.com/photo-1524178232363-1fb2b075b655?w=400',
      'location': 'عدن، اليمن'
    },
    {
      'id': 3,
      'name': 'معهد الإدارة والأعمال',
      'type': 'معهد إداري',
      'rating': 4.6,
      'students': 950,
      'courses': 28,
      'description': 'معهد متخصص في علوم الإدارة وريادة الأعمال',
      'image':
          'https://images.unsplash.com/photo-1497486751825-1233686d5d80?w=400',
      'location': 'تعز، اليمن'
    },
  ];

  List<Map<String, dynamic>> _filteredInstitutes = [];

  @override
  void initState() {
    super.initState();
    _filteredInstitutes = _allInstitutes;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterInstitutes(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredInstitutes = _allInstitutes;
      } else {
        _filteredInstitutes = _allInstitutes
            .where((institute) =>
                institute['name'].toLowerCase().contains(query.toLowerCase()) ||
                institute['type'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'المعاهد',
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
                hintText: 'ابحث عن معهد...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: _filterInstitutes,
            ),
          ),

          // Institutes list
          Expanded(
            child: _filteredInstitutes.isEmpty
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
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredInstitutes.length,
                    itemBuilder: (context, index) {
                      return _buildInstituteCard(_filteredInstitutes[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstituteCard(Map<String, dynamic> institute) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Institute image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              institute['image'],
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 150,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.school, size: 50, color: Colors.grey),
                  ),
                );
              },
              
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  institute['name'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  institute['type'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  institute['description'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: AppColors.warning),
                    const SizedBox(width: 4),
                    Text('${institute['rating']}'),
                    const SizedBox(width: 16),
                    const Icon(Icons.people, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text('${institute['students']} طالب'),
                    const SizedBox(width: 16),
                    const Icon(Icons.book, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text('${institute['courses']} كورس'),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      institute['location'],
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
