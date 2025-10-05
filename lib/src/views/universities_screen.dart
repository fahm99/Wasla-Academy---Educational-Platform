import 'package:flutter/material.dart';
import 'package:waslaacademy/src/constants/app_colors.dart';
import 'package:waslaacademy/src/widgets/custom_app_bar.dart';

class UniversitiesScreen extends StatefulWidget {
  const UniversitiesScreen({super.key});

  @override
  State<UniversitiesScreen> createState() => _UniversitiesScreenState();
}

class _UniversitiesScreenState extends State<UniversitiesScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Mock universities data
  final List<Map<String, dynamic>> _allUniversities = [
    {
      'id': 1,
      'name': 'جامعة تعز',
      'type': 'جامعة حكومية',
      'rating': 4.9,
      'students': 15000,
      'faculties': 12,
      'description': 'جامعة حكومية رائدة في التعليم العالي والبحث العلمي',
      'image':
          'https://images.unsplash.com/photo-1562774053-701939374585?w=400',
      'location': 'تعز، اليمن',
      'established': '1993'
    },
    {
      'id': 2,
      'name': 'جامعة الجند',
      'type': 'جامعة حكومية',
      'rating': 4.7,
      'students': 8500,
      'faculties': 8,
      'description': 'جامعة متخصصة في العلوم الهندسية والتقنية',
      'image':
          'https://images.unsplash.com/photo-1524178232363-1fb2b075b655?w=400',
      'location': 'تعز، اليمن',
      'established': '2009'
    },
    {
      'id': 3,
      'name': 'جامعة صنعاء',
      'type': 'جامعة حكومية',
      'rating': 4.8,
      'students': 25000,
      'faculties': 18,
      'description': 'أقدم وأكبر جامعة في الجمهورية اليمنية',
      'image':
          'https://images.unsplash.com/photo-1497486751825-1233686d5d80?w=400',
      'location': 'صنعاء، اليمن',
      'established': '1970'
    },
    {
      'id': 4,
      'name': 'جامعة عدن',
      'type': 'جامعة حكومية',
      'rating': 4.6,
      'students': 12000,
      'faculties': 10,
      'description': 'جامعة رائدة في جنوب اليمن',
      'image':
          'https://images.unsplash.com/photo-1541339907198-e08756dedf3f?w=400',
      'location': 'عدن، اليمن',
      'established': '1975'
    },
  ];

  List<Map<String, dynamic>> _filteredUniversities = [];

  @override
  void initState() {
    super.initState();
    _filteredUniversities = _allUniversities;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterUniversities(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredUniversities = _allUniversities;
      } else {
        _filteredUniversities = _allUniversities
            .where((university) =>
                university['name']
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                university['location']
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
        title: 'الجامعات',
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
                hintText: 'ابحث عن جامعة...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: _filterUniversities,
            ),
          ),

          // Universities list
          Expanded(
            child: _filteredUniversities.isEmpty
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
                    itemCount: _filteredUniversities.length,
                    itemBuilder: (context, index) {
                      return _buildUniversityCard(_filteredUniversities[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildUniversityCard(Map<String, dynamic> university) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // University image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              university['image'],
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 150,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.account_balance,
                        size: 50, color: Colors.grey),
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
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        university['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'تأسست ${university['established']}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  university['type'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  university['description'],
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
                    Text('${university['rating']}'),
                    const SizedBox(width: 16),
                    const Icon(Icons.people, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text('${university['students']} طالب'),
                    const SizedBox(width: 16),
                    const Icon(Icons.school, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text('${university['faculties']} كلية'),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      university['location'],
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
