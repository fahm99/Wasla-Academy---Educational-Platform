import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/helpers.dart';
import '../bloc/profile_bloc.dart';

/// صفحة تعديل الملف الشخصي
class EditProfilePage extends StatefulWidget {
  final dynamic profile;

  const EditProfilePage({super.key, required this.profile});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _phoneController = TextEditingController(text: widget.profile.phone ?? '');
    _bioController = TextEditingController(text: widget.profile.bio ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: AppBar(
        title: Text(
          'تعديل الملف الشخصي',
          style: AppTextStyles.headlineMedium(context),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            Helpers.showErrorSnackbar(context, state.message);
          } else if (state is ProfileUpdated) {
            Helpers.showSuccessSnackbar(context, 'تم تحديث الملف الشخصي');
            Navigator.pop(context);
          } else if (state is AvatarUploaded) {
            Helpers.showSuccessSnackbar(context, 'تم رفع الصورة');
            // Reload profile
          } else if (state is AvatarDeleted) {
            Helpers.showSuccessSnackbar(context, 'تم حذف الصورة');
            // Reload profile
          }
        },
        builder: (context, state) {
          final isLoading = state is ProfileLoading;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.xl),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Avatar Section
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: AppColors.light,
                        backgroundImage: widget.profile.avatarUrl != null
                            ? NetworkImage(widget.profile.avatarUrl!)
                            : null,
                        child: widget.profile.avatarUrl == null
                            ? Text(
                                widget.profile.name[0].toUpperCase(),
                                style: AppTextStyles.headlineLarge(context)
                                    .copyWith(
                                  color: AppColors.primary,
                                  fontSize: 48,
                                ),
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () => _showAvatarOptions(context),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSizes.xxl),

                  // Name Field
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'الاسم',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال الاسم';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: AppSizes.lg),

                  // Phone Field
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'رقم الجوال',
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                  ),

                  const SizedBox(height: AppSizes.lg),

                  // Bio Field
                  TextFormField(
                    controller: _bioController,
                    decoration: InputDecoration(
                      labelText: 'نبذة عني',
                      prefixIcon: const Icon(Icons.info),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      ),
                    ),
                    maxLines: 3,
                  ),

                  const SizedBox(height: AppSizes.xxl),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSizes.lg,
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('حفظ التغييرات'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileBloc>().add(
            UpdateProfileEvent(
              userId: widget.profile.id,
              name: _nameController.text,
              phone:
                  _phoneController.text.isEmpty ? null : _phoneController.text,
              bio: _bioController.text.isEmpty ? null : _bioController.text,
            ),
          );
    }
  }

  void _showAvatarOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('اختيار من المعرض'),
              onTap: () {
                Navigator.pop(context);
                Helpers.showInfoSnackbar(context, 'سيتم إضافة اختيار الصورة');
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('التقاط صورة'),
              onTap: () {
                Navigator.pop(context);
                Helpers.showInfoSnackbar(context, 'سيتم إضافة التقاط الصورة');
              },
            ),
            if (widget.profile.avatarUrl != null)
              ListTile(
                leading: const Icon(Icons.delete, color: AppColors.error),
                title: const Text(
                  'حذف الصورة',
                  style: TextStyle(color: AppColors.error),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context
                      .read<ProfileBloc>()
                      .add(DeleteAvatarEvent(widget.profile.id));
                },
              ),
          ],
        ),
      ),
    );
  }
}
