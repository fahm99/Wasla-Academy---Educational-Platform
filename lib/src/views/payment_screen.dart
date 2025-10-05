import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waslaacademy/src/blocs/course/course_bloc.dart';
import 'package:waslaacademy/src/constants/app_colors.dart';
import 'package:waslaacademy/src/constants/app_sizes.dart';
import 'package:waslaacademy/src/constants/app_text_styles.dart';
import 'package:waslaacademy/src/models/course.dart';
import 'package:waslaacademy/src/views/course_player_screen.dart';

class PaymentScreen extends StatefulWidget {
  final Course course;

  const PaymentScreen({
    super.key,
    required this.course,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedPaymentMethod = 0; // 0: Credit Card, 1: PayPal, 2: Bank Transfer
  bool _termsAccepted = false;
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _cardHolderController.dispose();
    super.dispose();
  }

  void _completePayment() {
    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى الموافقة على الشروط والأحكام'),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: AppSizes.spaceLarge),
            Text(
              'جاري معالجة الدفع...',
              style: AppTextStyles.bodyLarge(context),
            ),
          ],
        ),
      ),
    );

    // Simulate payment processing
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop(); // Close loading dialog

      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('تم الدفع بنجاح'),
          content: Text(
            'تم تسجيلك في كورس "${widget.course.title}" بنجاح!',
            style: AppTextStyles.bodyLarge(context),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Close payment screen
                Navigator.of(context).pop(); // Close course detail screen

                // Enroll user in course
                context
                    .read<CourseBloc>()
                    .add(EnrollCourse(courseId: widget.course.id));

                // Navigate to main screen with learning tab selected
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/main',
                  (route) => false,
                  arguments: {
                    'initialTab': 2, // Learning tab index
                    'showWelcome': true,
                  },
                );
              },
              child: const Text('متابعة'),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الدفع'),
        backgroundColor: Colors.white,
        elevation: AppSizes.elevationLow,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spaceLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Course Summary
              Container(
                padding: const EdgeInsets.all(AppSizes.spaceLarge),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: AppSizes.elevationMedium,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.course.title,
                      style: AppTextStyles.headline3(context),
                    ),
                    const SizedBox(height: AppSizes.spaceMedium),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'السعر:',
                          style: AppTextStyles.bodyLarge(context),
                        ),
                        Text(
                          '${widget.course.price} ر.س',
                          style: AppTextStyles.headline2(context).copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.spaceXXLarge),

              // Payment Method Selection
              Text(
                'طريقة الدفع',
                style: AppTextStyles.headline3(context),
              ),
              const SizedBox(height: AppSizes.spaceMedium),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  border: Border.all(color: AppColors.light),
                ),
                child: Column(
                  children: [
                    _buildPaymentMethodOption(
                      context,
                      icon: Icons.credit_card,
                      title: 'بطاقة ائتمان',
                      subtitle: 'فيزا، ماستركارد',
                      index: 0,
                    ),
                    const Divider(height: 0),
                    _buildPaymentMethodOption(
                      context,
                      icon: Icons.account_balance,
                      title: 'تحويل بنكي',
                      subtitle: 'تحويل مباشر إلى الحساب البنكي',
                      index: 1,
                    ),
                    const Divider(height: 0),
                    _buildPaymentMethodOption(
                      context,
                      icon: Icons.paypal,
                      title: 'بايبال',
                      subtitle: 'الدفع عبر بايبال',
                      index: 2,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.spaceXXLarge),

              // Payment Details Form
              if (_selectedPaymentMethod == 0) ...[
                Text(
                  'تفاصيل البطاقة',
                  style: AppTextStyles.headline3(context),
                ),
                const SizedBox(height: AppSizes.spaceMedium),
                Container(
                  padding: const EdgeInsets.all(AppSizes.spaceLarge),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  ),
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: _cardNumberController,
                        label: 'رقم البطاقة',
                        hint: '1234 5678 9012 3456',
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: AppSizes.spaceMedium),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _expiryDateController,
                              label: 'تاريخ الانتهاء',
                              hint: 'MM/YY',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: AppSizes.spaceMedium),
                          Expanded(
                            child: _buildTextField(
                              controller: _cvvController,
                              label: 'CVV',
                              hint: '123',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.spaceMedium),
                      _buildTextField(
                        controller: _cardHolderController,
                        label: 'اسم حامل البطاقة',
                        hint: 'كما يظهر على البطاقة',
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: AppSizes.spaceXXLarge),

              // Terms and Conditions
              Row(
                children: [
                  Checkbox(
                    value: _termsAccepted,
                    onChanged: (value) {
                      setState(() {
                        _termsAccepted = value ?? false;
                      });
                    },
                    activeColor: AppColors.primary,
                  ),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'أوافق على ',
                            style: AppTextStyles.bodyMedium(context),
                          ),
                          TextSpan(
                            text: 'الشروط والأحكام',
                            style: AppTextStyles.bodyMedium(context).copyWith(
                              color: AppColors.primary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          TextSpan(
                            text: ' و',
                            style: AppTextStyles.bodyMedium(context),
                          ),
                          TextSpan(
                            text: 'سياسة الخصوصية',
                            style: AppTextStyles.bodyMedium(context).copyWith(
                              color: AppColors.primary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSizes.spaceXXLarge),

              // Pay Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _completePayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppSizes.radiusMedium),
                    ),
                    elevation: AppSizes.elevationLow,
                  ),
                  child: Text(
                    'دفع ${widget.course.price} ر.س',
                    style: AppTextStyles.buttonLarge(context).copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required int index,
  }) {
    return RadioListTile<int>(
      value: index,
      groupValue: _selectedPaymentMethod,
      onChanged: (value) {
        setState(() {
          _selectedPaymentMethod = value ?? 0;
        });
      },
      title: Text(
        title,
        style: AppTextStyles.labelLarge(context),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.bodyMedium(context).copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      secondary: Icon(
        icon,
        color: AppColors.primary,
      ),
      activeColor: AppColors.primary,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceLarge,
        vertical: AppSizes.spaceSmall,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelMedium(context),
        ),
        const SizedBox(height: AppSizes.spaceXSmall),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
            ),
            contentPadding: const EdgeInsets.all(AppSizes.spaceMedium),
          ),
          keyboardType: keyboardType,
        ),
      ],
    );
  }
}
