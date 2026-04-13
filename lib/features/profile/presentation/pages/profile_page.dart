import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/helpers.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../courses/presentation/pages/my_courses_page.dart';
import '../../../certificates/presentation/pages/certificates_page.dart';
import '../../../payments/presentation/pages/my_payments_page.dart';
import '../../../settings/presentation/pages/settings_screen.dart';
import '../../../info/presentation/pages/help_screen.dart';
import '../bloc/profile_bloc.dart';
import 'edit_profile_page.dart';

/// صفحة الملف الشخصي
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin, RouteAware {
  final ImagePicker _imagePicker = ImagePicker();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Load data in initState for first time
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfile();
    });
  }

  void _loadProfile() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      context.read<ProfileBloc>().add(LoadProfileEvent(authState.user.id));
    }
  }

  Future<void> _pickAndUploadImage(String userId) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null && mounted) {
        context.read<ProfileBloc>().add(
              UploadAvatarEvent(
                userId: userId,
                imageFile: image,
              ),
            );
      }
    } catch (e) {
      if (mounted) {
        Helpers.showErrorSnackbar(context, 'فشل اختيار الصورة');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: AppBar(
        title: Text(
          'الملف الشخصي',
          style: AppTextStyles.headline2(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            Helpers.showErrorSnackbar(context, state.message);
          } else if (state is ProfileUpdated) {
            Helpers.showSuccessSnackbar(context, 'تم تحديث الملف الشخصي');
            _loadProfile();
          } else if (state is AvatarUploaded) {
            Helpers.showSuccessSnackbar(context, 'تم تحديث الصورة الشخصية');
            _loadProfile();
          }
        },
        builder: (context, state) {
          // Handle initial state and loading
          if (state is ProfileInitial || state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProfileLoaded) {
            final profile = state.profile;
            return _buildProfileContent(profile);
          }

          return _buildEmptyState();
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_outline,
            size: 80,
            color: AppColors.textLight,
          ),
          const SizedBox(height: AppSizes.lg),
          Text(
            'لا توجد بيانات',
            style: AppTextStyles.bodyLarge(context).copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent(profile) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: AppSizes.xl),

          // Avatar with camera button
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.2),
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: AppColors.light,
                  child: profile.avatarUrl != null
                      ? ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: profile.avatarUrl!,
                            width: 140,
                            height: 140,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Icon(
                              Icons.person,
                              size: 70,
                              color: AppColors.primary.withOpacity(0.5),
                            ),
                          ),
                        )
                      : Icon(
                          Icons.person,
                          size: 70,
                          color: AppColors.primary.withOpacity(0.5),
                        ),
                ),
              ),
              Positioned(
                bottom: 5,
                right: 5,
                child: GestureDetector(
                  onTap: () => _pickAndUploadImage(profile.id),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSizes.lg),

          // Name
          Text(
            profile.name,
            style: AppTextStyles.headlineLarge(context).copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSizes.sm),

          // Email
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.email_outlined,
                size: 18,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: AppSizes.xs),
              Text(
                profile.email,
                style: AppTextStyles.bodyMedium(context).copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),

          if (profile.phone != null) ...[
            const SizedBox(height: AppSizes.xs),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.phone_outlined,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: AppSizes.xs),
                Text(
                  profile.phone!,
                  style: AppTextStyles.bodyMedium(context).copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],

          if (profile.bio != null) ...[
            const SizedBox(height: AppSizes.lg),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: AppSizes.xl,
              ),
              padding: const EdgeInsets.all(AppSizes.lg),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: Text(
                      profile.bio!,
                      style: AppTextStyles.bodyMedium(context),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: AppSizes.xxl),

          // Stats Cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    icon: Icons.school_outlined,
                    label: 'الكورسات',
                    value: profile.coursesEnrolled.toString(),
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: _buildStatCard(
                    context,
                    icon: Icons.workspace_premium_outlined,
                    label: 'الشهادات',
                    value: profile.certificatesCount.toString(),
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.xxl),

          // Menu Items
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
            child: Column(
              children: [
                _buildMenuItem(
                  context,
                  icon: Icons.edit_outlined,
                  title: 'تعديل الملف الشخصي',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfilePage(profile: profile),
                      ),
                    ).then((_) => _loadProfile());
                  },
                ),
                const SizedBox(height: AppSizes.sm),
                _buildMenuItem(
                  context,
                  icon: Icons.school_outlined,
                  title: 'كورساتي',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyCoursesPage(),
                      ),
                    ).then((_) => _loadProfile());
                  },
                ),
                const SizedBox(height: AppSizes.sm),
                _buildMenuItem(
                  context,
                  icon: Icons.workspace_premium_outlined,
                  title: 'شهاداتي',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CertificatesPage(),
                      ),
                    ).then((_) => _loadProfile());
                  },
                ),
                const SizedBox(height: AppSizes.sm),
                _buildMenuItem(
                  context,
                  icon: Icons.payment_outlined,
                  title: 'مدفوعاتي',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyPaymentsPage(),
                      ),
                    ).then((_) => _loadProfile());
                  },
                ),
                const SizedBox(height: AppSizes.sm),
                _buildMenuItem(
                  context,
                  icon: Icons.settings_outlined,
                  title: 'الإعدادات',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    ).then((_) => _loadProfile());
                  },
                ),
                const SizedBox(height: AppSizes.sm),
                _buildMenuItem(
                  context,
                  icon: Icons.help_outline,
                  title: 'المساعدة',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HelpScreen(),
                      ),
                    ).then((_) => _loadProfile());
                  },
                ),
                const SizedBox(height: AppSizes.sm),
                _buildMenuItem(
                  context,
                  icon: Icons.logout,
                  title: 'تسجيل الخروج',
                  onTap: () {
                    _showLogoutDialog(context);
                  },
                  isDestructive: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.xxxl),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.xl,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            value,
            style: AppTextStyles.headlineMedium(context).copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            label,
            style: AppTextStyles.bodyMedium(context).copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.lg,
          vertical: AppSizes.sm,
        ),
        leading: Container(
          padding: const EdgeInsets.all(AppSizes.sm),
          decoration: BoxDecoration(
            color: isDestructive
                ? AppColors.error.withOpacity(0.1)
                : AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          child: Icon(
            icon,
            color: isDestructive ? AppColors.error : AppColors.primary,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyLarge(context).copyWith(
            color: isDestructive ? AppColors.error : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 18,
          color: isDestructive
              ? AppColors.error.withOpacity(0.5)
              : AppColors.textLight,
        ),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
        title: const Row(
          children: [
            Icon(
              Icons.logout,
              color: AppColors.error,
            ),
            SizedBox(width: AppSizes.sm),
            Text('تسجيل الخروج'),
          ],
        ),
        content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'إلغاء',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // تسجيل الخروج
              context.read<AuthBloc>().add(const SignOutRequested());
              // العودة لصفحة تسجيل الدخول
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login',
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
            ),
            child: const Text(
              'تسجيل الخروج',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
