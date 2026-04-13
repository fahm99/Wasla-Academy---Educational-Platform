import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/network/api_client.dart';

/// بانر الصفحة الرئيسية
class HomeBanner extends StatefulWidget {
  const HomeBanner({super.key});

  @override
  State<HomeBanner> createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  int _current = 0;
  List<Map<String, dynamic>> _providers = [];
  bool _isLoading = true;
  final String _defaultImage =
      'https://images.unsplash.com/photo-1562774053-701939374585?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80';

  @override
  void initState() {
    super.initState();
    _loadProviders();
  }

  Future<void> _loadProviders() async {
    try {
      final response = await ApiClient.instance
          .from('users')
          .select(
              'id, name, avatar_url, profile_image_url, bio, courses_count, students_count, rating')
          .eq('user_type', 'provider')
          .eq('is_active', true)
          .order('students_count', ascending: false)
          .limit(5);

      if (mounted) {
        setState(() {
          _providers = List<Map<String, dynamic>>.from(response);
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading providers: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        final height = isTablet ? 300.0 : 180.0;

        if (_isLoading) {
          return SizedBox(
            height: height,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (_providers.isEmpty) {
          return SizedBox(
            height: height,
            child: Center(
              child: Text(
                'لا يوجد شركاء متاحون حالياً',
                style: AppTextStyles.bodyLarge(context),
              ),
            ),
          );
        }

        return SizedBox(
          height: height,
          child: Stack(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: height,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 5),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  pauseAutoPlayOnTouch: true,
                  enlargeCenterPage: true,
                  viewportFraction: 1.0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                ),
                items: _providers.map((provider) {
                  return Builder(
                    builder: (BuildContext context) {
                      final imageUrl = provider['profile_image_url'] ??
                          provider['avatar_url'] ??
                          _defaultImage;
                      final name = provider['name'] ?? 'مقدم خدمة';
                      final bio = provider['bio'] ?? 'شريك أكاديمي معتمد';
                      final coursesCount = provider['courses_count'] ?? 0;
                      final studentsCount = provider['students_count'] ?? 0;
                      final rating = provider['rating'] ?? 0.0;

                      return Container(
                        margin:
                            const EdgeInsets.symmetric(horizontal: AppSizes.lg),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppSizes.radiusLg),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(AppSizes.radiusLg),
                          child: Stack(
                            children: [
                              // صورة البانر
                              CachedNetworkImage(
                                imageUrl: imageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: height,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                errorWidget: (context, url, error) {
                                  return CachedNetworkImage(
                                    imageUrl: _defaultImage,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: height,
                                    errorWidget: (context, url, error) {
                                      return Container(
                                        color: Colors.grey[300],
                                        child: const Center(
                                          child: Icon(
                                            Icons.person,
                                            size: 50,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              // تدرج لوني
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.8),
                                    ],
                                  ),
                                ),
                              ),
                              // النص
                              Positioned(
                                bottom: 20,
                                left: 20,
                                right: 20,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style:
                                          AppTextStyles.headlineMedium(context)
                                              .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      bio,
                                      style: AppTextStyles.bodyMedium(context)
                                          .copyWith(
                                        color: Colors.white70,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        if (rating > 0) ...[
                                          const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            rating.toStringAsFixed(1),
                                            style:
                                                AppTextStyles.bodySmall(context)
                                                    .copyWith(
                                                        color: Colors.white),
                                          ),
                                          const SizedBox(width: 12),
                                        ],
                                        const Icon(
                                          Icons.school,
                                          color: Colors.white70,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '$coursesCount كورس',
                                          style:
                                              AppTextStyles.bodySmall(context)
                                                  .copyWith(
                                                      color: Colors.white70),
                                        ),
                                        const SizedBox(width: 12),
                                        const Icon(
                                          Icons.people,
                                          color: Colors.white70,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '$studentsCount طالب',
                                          style:
                                              AppTextStyles.bodySmall(context)
                                                  .copyWith(
                                                      color: Colors.white70),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              // مؤشرات الصفحات
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _providers.asMap().entries.map((entry) {
                    return Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(
                          _current == entry.key ? 1.0 : 0.5,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
