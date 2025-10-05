import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waslaacademy/src/blocs/auth/auth_bloc.dart';
import 'package:waslaacademy/src/constants/app_colors.dart';
import 'package:waslaacademy/src/widgets/custom_app_bar.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current user data
    final state = BlocProvider.of<AuthBloc>(context).state;
    if (state is AuthSuccess) {
      _nameController.text = state.user.name;
      _emailController.text = state.user.email;
      _phoneController.text = state.user.phone ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'تعديل الملف الشخصي',
        onBack: () {
          Navigator.pop(context);
        },
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AuthFailure) {
            return Center(
              child: Text(state.message),
            );
          } else if (state is AuthSuccess) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  // Profile picture
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50.w,
                          backgroundImage: state.user.avatar != null
                              ? NetworkImage(state.user.avatar!)
                              : null,
                          onBackgroundImageError: (exception, stackTrace) {
                            // Handle image load error
                          },
                          child: state.user.avatar == null
                              ? const Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'تغيير الصورة',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 30.h),
                  // Edit form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Name field
                        _buildTextFormField(
                          controller: _nameController,
                          label: 'الاسم الكامل',
                          hint: 'أدخل اسمك الكامل',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال الاسم الكامل';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20.h),
                        // Email field
                        _buildTextFormField(
                          controller: _emailController,
                          label: 'البريد الإلكتروني',
                          hint: 'أدخل بريدك الإلكتروني',
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال البريد الإلكتروني';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return 'الرجاء إدخال بريد إلكتروني صحيح';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20.h),
                        // Phone field
                        _buildTextFormField(
                          controller: _phoneController,
                          label: 'رقم الهاتف',
                          hint: 'أدخل رقم هاتفك',
                          keyboardType: TextInputType.phone,
                        ),
                        SizedBox(height: 20.h),
                        // Password field
                        _buildTextFormField(
                          controller: _passwordController,
                          label: 'كلمة المرور الجديدة',
                          hint: 'أدخل كلمة المرور الجديدة',
                          obscureText: true,
                        ),
                        SizedBox(height: 20.h),
                        // Confirm password field
                        _buildTextFormField(
                          controller: _confirmPasswordController,
                          label: 'تأكيد كلمة المرور',
                          hint: 'أعد إدخال كلمة المرور',
                          obscureText: true,
                          validator: (value) {
                            if (value != null &&
                                value.isNotEmpty &&
                                value != _passwordController.text) {
                              return 'كلمتا المرور غير متطابقتين';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 30.h),
                        // Save button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _saveProfileChanges();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'حفظ التغييرات',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
            color: AppColors.dark,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[500],
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: Colors.grey[300]!,
                width: 1.w,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: Colors.grey[300]!,
                width: 1.w,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: AppColors.primary,
                width: 1.w,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
          ),
          keyboardType: keyboardType,
          obscureText: obscureText,
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.dark,
          ),
          validator: validator,
        ),
      ],
    );
  }

  void _saveProfileChanges() {
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم حفظ التغييرات بنجاح'),
        backgroundColor: AppColors.success,
      ),
    );

    // Navigate back
    Navigator.pop(context);
  }
}
