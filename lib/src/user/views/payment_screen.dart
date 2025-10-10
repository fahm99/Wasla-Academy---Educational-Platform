import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waslaacademy/src/user/blocs/course/course_bloc.dart';
import 'package:waslaacademy/src/user/constants/app_colors.dart';
import 'package:waslaacademy/src/user/constants/app_sizes.dart';
import 'package:waslaacademy/src/user/constants/app_text_styles.dart';
import 'package:waslaacademy/src/user/models/course.dart';
import 'package:waslaacademy/src/user/views/course_content_screen.dart';

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

      // Enroll user in course
      context.read<CourseBloc>().add(EnrollCourse(courseId: widget.course.id));

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

                // Navigate directly to course content screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CourseContentScreen(
                      courseId: widget.course.id,
                    ),
                  ),
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
                      title: 'PayPal',
                      subtitle: 'الدفع عبر PayPal',
                      index: 2,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.spaceXXLarge),

              // Payment Form
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
                    border: Border.all(color: AppColors.light),
                  ),
                  child: Column(
                    children: [
                      // Card Number
                      TextField(
                        controller: _cardNumberController,
                        decoration: const InputDecoration(
                          labelText: 'رقم البطاقة',
                          hintText: '1234 5678 9012 3456',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.credit_card),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: AppSizes.spaceMedium),

                      // Expiry Date and CVV
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _expiryDateController,
                              decoration: const InputDecoration(
                                labelText: 'تاريخ الانتهاء',
                                hintText: 'MM/YY',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.date_range),
                              ),
                              keyboardType: TextInputType.datetime,
                            ),
                          ),
                          const SizedBox(width: AppSizes.spaceMedium),
                          Expanded(
                            child: TextField(
                              controller: _cvvController,
                              decoration: const InputDecoration(
                                labelText: 'CVV',
                                hintText: '123',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.lock),
                              ),
                              keyboardType: TextInputType.number,
                              obscureText: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.spaceMedium),

                      // Card Holder Name
                      TextField(
                        controller: _cardHolderController,
                        decoration: const InputDecoration(
                          labelText: 'اسم حامل البطاقة',
                          hintText: 'أحمد محمد',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
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
                  ),
                  Expanded(
                    child: Text(
                      'أوافق على الشروط والأحكام وسياسة الخصوصية',
                      style: AppTextStyles.bodyLarge(context),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSizes.spaceXXLarge),

              // Pay Button
              SizedBox(
                width: double.infinity,
                height: AppSizes
                    .buttonHeight, // Use AppSizes directly instead of ResponsiveHelper
                child: ElevatedButton(
                  onPressed: _completePayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppSizes.radiusMedium),
                    ),
                    elevation: AppSizes.elevationLow,
                  ),
                  child: Text(
                    'دفع ${widget.course.price} ر.س',
                    style: AppTextStyles.buttonLarge(context),
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
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: AppTextStyles.labelLarge(context)),
      subtitle: Text(subtitle, style: AppTextStyles.bodySmall(context)),
      trailing: Radio<int>(
        value: index,
        groupValue: _selectedPaymentMethod,
        onChanged: (value) {
          setState(() {
            _selectedPaymentMethod = value ?? 0;
          });
        },
      ),
      onTap: () {
        setState(() {
          _selectedPaymentMethod = index;
        });
      },
    );
  }
}