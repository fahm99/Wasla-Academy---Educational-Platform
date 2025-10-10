import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waslaacademy/src/user/blocs/auth/auth_bloc.dart';
import 'package:waslaacademy/src/user/constants/app_colors.dart';
import 'package:waslaacademy/src/user/widgets/custom_app_bar.dart';

class VerificationScreen extends StatefulWidget {
  final String email;
  final String name;
  final String phone;
  final String password;

  const VerificationScreen({
    super.key,
    required this.email,
    required this.name,
    required this.phone,
    required this.password,
  });

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  String _verificationCode = '';
  bool _isLoading = false;
  int _resendTimer = 60;
  Timer? _timer;
  bool _canResend = false;

  // رمز التحقق التجريبي
  final String _testVerificationCode = '123456';

  @override
  void initState() {
    super.initState();
    _startResendTimer();

    // إرسال رمز التحقق (محاكاة)
    _sendVerificationCode();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _startResendTimer() {
    _canResend = false;
    _resendTimer = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendTimer > 0) {
          _resendTimer--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  void _sendVerificationCode() {
    // محاكاة إرسال رمز التحقق
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم إرسال رمز التحقق إلى ${widget.email}'),
        backgroundColor: AppColors.success,
        action: SnackBarAction(
          label: 'الرمز التجريبي: $_testVerificationCode',
          textColor: Colors.white,
          onPressed: () {
            // ملء الرمز تلقائياً للاختبار
            _fillTestCode();
          },
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void _fillTestCode() {
    for (int i = 0; i < _testVerificationCode.length; i++) {
      _controllers[i].text = _testVerificationCode[i];
    }
    _updateVerificationCode();
  }

  void _onCodeChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      }
    } else {
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }
    _updateVerificationCode();
  }

  void _updateVerificationCode() {
    setState(() {
      _verificationCode = _controllers.map((c) => c.text).join();
    });
  }

  void _verifyCode() {
    if (_verificationCode.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء إدخال رمز التحقق كاملاً'),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // محاكاة التحقق من الرمز
    Future.delayed(const Duration(seconds: 2), () {
      if (_verificationCode == _testVerificationCode) {
        // رمز صحيح - إنشاء الحساب
        context.read<AuthBloc>().add(
              RegisterRequested(
                name: widget.name,
                email: widget.email,
                phone: widget.phone,
                password: widget.password,
              ),
            );
      } else {
        // رمز خاطئ
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('رمز التحقق غير صحيح، الرجاء المحاولة مرة أخرى'),
            backgroundColor: AppColors.danger,
          ),
        );
        _clearCode();
      }
    });
  }

  void _clearCode() {
    for (var controller in _controllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
    setState(() {
      _verificationCode = '';
    });
  }

  void _resendCode() {
    if (_canResend) {
      _sendVerificationCode();
      _startResendTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          setState(() {
            _isLoading = false;
          });

          // إظهار رسالة نجاح
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم إنشاء الحساب بنجاح! مرحباً بك في وصلة أكاديمي'),
              backgroundColor: AppColors.success,
              duration: Duration(seconds: 3),
            ),
          );

          // الانتقال إلى الشاشة الرئيسية
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/',
            (route) => false,
          );
        } else if (state is AuthFailure) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.danger,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'التحقق من البريد الإلكتروني',
          onBack: () => Navigator.pop(context),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20.h),

              // أيقونة التحقق
              Container(
                width: 100.w,
                height: 100.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.mark_email_read_outlined,
                  size: 50.sp,
                  color: AppColors.primary,
                ),
              ),

              SizedBox(height: 30.h),

              // العنوان
              Text(
                'تحقق من بريدك الإلكتروني',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.dark,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 10.h),

              // الوصف
              Text(
                'لقد أرسلنا رمز التحقق المكون من 6 أرقام إلى',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 5.h),

              Text(
                widget.email,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 40.h),

              // حقول إدخال الرمز
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 45.w,
                    height: 55.h,
                    child: TextFormField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.dark,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
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
                            width: 2.w,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (value) => _onCodeChanged(value, index),
                    ),
                  );
                }),
              ),

              SizedBox(height: 30.h),

              // زر التحقق
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verifyCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'تحقق من الرمز',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              SizedBox(height: 20.h),

              // إعادة الإرسال
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'لم تستلم الرمز؟ ',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  TextButton(
                    onPressed: _canResend ? _resendCode : null,
                    child: Text(
                      _canResend
                          ? 'إعادة الإرسال'
                          : 'إعادة الإرسال خلال $_resendTimer ثانية',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color:
                            _canResend ? AppColors.primary : Colors.grey[400],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              // معلومات الاختبار
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: AppColors.info.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColors.info,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'للاختبار',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.info,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'رمز التحقق التجريبي: $_testVerificationCode\nاضغط على الإشعار أعلاه لملء الرمز تلقائياً',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.info,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
