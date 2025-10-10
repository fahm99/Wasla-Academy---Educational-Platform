import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:waslaacademy/src/user/blocs/auth/auth_bloc.dart';
import 'package:waslaacademy/src/user/constants/app_colors.dart';
import 'package:waslaacademy/src/user/views/forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onRegisterTap;
  final VoidCallback onLoginSuccess;

  const LoginScreen({
    super.key,
    required this.onRegisterTap,
    required this.onLoginSuccess,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء ملء جميع الحقول'),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }

    context.read<AuthBloc>().add(
          LoginRequested(
            email: _emailController.text,
            password: _passwordController.text,
          ),
        );
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser != null) {
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم تسجيل الدخول بحساب جوجل بنجاح'),
              backgroundColor: AppColors.success,
            ),
          );
        }

        // Navigate to home screen
        widget.onLoginSuccess();
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('فشل في تسجيل الدخول بحساب جوجل'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  Future<void> _signInWithApple() async {
    // Show a snackbar to indicate the Apple sign in process
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('جاري تسجيل الدخول بحساب آبل'),
        duration: Duration(seconds: 2),
      ),
    );

    // TODO: Implement actual Apple sign in logic
    // This would typically involve using the sign_in_with_apple package
    // and implementing the Apple Sign In flow

    // For now, we'll just show a success message and navigate to home
    await Future.delayed(const Duration(seconds: 2));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم تسجيل الدخول بحساب آبل بنجاح'),
        backgroundColor: AppColors.success,
        duration: Duration(seconds: 2),
      ),
    );

    // Navigate to home screen
    widget.onLoginSuccess();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          widget.onLoginSuccess();
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.danger,
            ),
          );
        }
      },
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w), // Reduced from 20.w
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                                SizedBox(height: 20.h), // Reduced from 20.h

                // Logo - Reduced size
                Container(
                  width: 72.w, // Reduced from 96.w
                  height: 72.w, // Reduced from 96.w
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(16.r), // Reduced from 20.r
                  ),
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 36.w, // Reduced from 48.w
                    height: 36.w, // Reduced from 48.w
                  ),
                ),
                SizedBox(height: 16.h), // Reduced from 20.h
                Text(
                  'مرحباً بك',
                  style: TextStyle(
                    fontSize: 20.sp, // Reduced from 24.sp
                    fontWeight: FontWeight.bold,
                    color: AppColors.dark,
                  ),
                ),
                SizedBox(height: 6.h), // Reduced from 8.h
                Text(
                  'تسجيل الدخول لحسابك',
                  style: TextStyle(
                    fontSize: 14.sp, // Reduced from 16.sp
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 20.h), // Reduced from 30.h

                // Login form - Reduced padding
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(12.r), // Reduced from 16.r
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 16, // Reduced from 20
                        offset: const Offset(0, 2), // Reduced from (0, 4)
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(20.w), // Reduced from 30.w
                  child: Column(
                    children: [
                      // Email field
                      _buildFormField(
                        controller: _emailController,
                        label: 'البريد الإلكتروني',
                        hint: 'أدخل بريدك الإلكتروني',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 16.h), // Reduced from 20.h

                      // Password field
                      _buildFormField(
                        controller: _passwordController,
                        label: 'كلمة المرور',
                        hint: 'أدخل كلمة المرور',
                        obscureText: true,
                      ),
                      SizedBox(height: 12.h), // Reduced from 16.h

                      // Remember me and forgot password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                activeColor: AppColors.primary,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value ?? false;
                                  });
                                },
                              ),
                              Text(
                                'تذكرني',
                                style: TextStyle(
                                  fontSize: 12.sp, // Reduced from 14.sp
                                  color: AppColors.dark,
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              // Navigate to forgot password screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPasswordScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'نسيت كلمة المرور؟',
                              style: TextStyle(
                                fontSize: 12.sp, // Reduced from 14.sp
                                color: AppColors.info,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h), // Reduced from 20.h

                      // Login button - Reduced padding
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                vertical: 12.h), // Reduced from 16.h
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  6.r), // Reduced from 8.r
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'تسجيل الدخول',
                            style: TextStyle(
                              fontSize: 14.sp, // Reduced from 16.sp
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16.h), // Reduced from 20.h

                // Social login buttons - Reduced padding and size
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(12.r), // Reduced from 16.r
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 16, // Reduced from 20
                        offset: const Offset(0, 2), // Reduced from (0, 4)
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(16.w), // Reduced from 20.w
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            // TODO: Implement Google login
                            await _signInWithGoogle();
                          },
                          icon: Icon(
                            Icons.g_mobiledata,
                            size: 20.sp, // Reduced from 24.sp
                            color: AppColors.dark,
                          ),
                          label: Text(
                            'تسجيل الدخول بحساب جوجل',
                            style: TextStyle(
                              fontSize: 14.sp, // Reduced from 16.sp
                              fontWeight: FontWeight.w600,
                              color: AppColors.dark,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.dark,
                            padding: EdgeInsets.symmetric(
                                vertical: 12.h), // Reduced from 16.h
                            side: BorderSide(
                              color: Colors.grey[300]!,
                              width: 1.w,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  6.r), // Reduced from 8.r
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h), // Reduced from 12.h
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            // TODO: Implement Apple login
                            await _signInWithApple();
                          },
                          icon: Icon(
                            Icons.apple,
                            size: 20.sp, // Reduced from 24.sp
                            color: AppColors.dark,
                          ),
                          label: Text(
                            'تسجيل الدخول بحساب آبل',
                            style: TextStyle(
                              fontSize: 14.sp, // Reduced from 16.sp
                              fontWeight: FontWeight.w600,
                              color: AppColors.dark,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.dark,
                            padding: EdgeInsets.symmetric(
                                vertical: 12.h), // Reduced from 16.h
                            side: BorderSide(
                              color: Colors.grey[300]!,
                              width: 1.w,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  6.r), // Reduced from 8.r
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16.h), // Reduced from 20.h
                // Register link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ليس لديك حساب؟',
                      style: TextStyle(
                        fontSize: 12.sp, // Reduced from 14.sp
                        color: Colors.grey[600],
                      ),
                    ),
                    TextButton(
                      onPressed: widget.onRegisterTap,
                      child: Text(
                        'إنشاء حساب جديد',
                        style: TextStyle(
                          fontSize: 12.sp, // Reduced from 14.sp
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14.sp, // Reduced from 16.sp
            color: AppColors.dark,
          ),
        ),
        SizedBox(height: 6.h), // Reduced from 8.h
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 14.sp, // Reduced from 16.sp
              color: Colors.grey[500],
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r), // Reduced from 8.r
              borderSide: BorderSide(
                color: Colors.grey[300]!,
                width: 1.w,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r), // Reduced from 8.r
              borderSide: BorderSide(
                color: Colors.grey[300]!,
                width: 1.w,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r), // Reduced from 8.r
              borderSide: BorderSide(
                color: AppColors.primary,
                width: 1.w,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w, // Reduced from 16.w
              vertical: 10.h, // Reduced from 12.h
            ),
          ),
          keyboardType: keyboardType,
          obscureText: obscureText,
          style: TextStyle(
            fontSize: 14.sp, // Reduced from 16.sp
            color: AppColors.dark,
          ),
        ),
      ],
    );
  }
}
