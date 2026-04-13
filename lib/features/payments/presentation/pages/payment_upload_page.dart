import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../bloc/payments_bloc.dart';
import '../bloc/payments_event.dart';
import '../bloc/payments_state.dart';
import 'payment_status_page.dart';

class PaymentUploadPage extends StatefulWidget {
  final String courseId;
  final String courseName;
  final double amount;
  final bool acceptBankTransfer;
  final bool acceptLocalTransfer;

  const PaymentUploadPage({
    super.key,
    required this.courseId,
    required this.courseName,
    required this.amount,
    required this.acceptBankTransfer,
    required this.acceptLocalTransfer,
  });

  @override
  State<PaymentUploadPage> createState() => _PaymentUploadPageState();
}

class _PaymentUploadPageState extends State<PaymentUploadPage> {
  final _formKey = GlobalKey<FormState>();
  final _transactionRefController = TextEditingController();
  final _imagePicker = ImagePicker();

  File? _receiptImage;
  String? _selectedPaymentMethod;

  @override
  void initState() {
    super.initState();
    if (widget.acceptBankTransfer) {
      _selectedPaymentMethod = ApiConstants.paymentMethodBankTransfer;
    } else if (widget.acceptLocalTransfer) {
      _selectedPaymentMethod = ApiConstants.paymentMethodLocalTransfer;
    }
  }

  @override
  void dispose() {
    _transactionRefController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _receiptImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('فشل اختيار الصورة: $e'),
              backgroundColor: AppColors.error),
        );
      }
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppSizes.radiusLg)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColors.primary),
                title: const Text('التقاط صورة'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.photo_library, color: AppColors.primary),
                title: const Text('اختيار من المعرض'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitPayment() {
    if (!_formKey.currentState!.validate()) return;
    if (_receiptImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('يرجى اختيار صورة الإيصال'),
            backgroundColor: AppColors.error),
      );
      return;
    }
    if (_selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('يرجى اختيار طريقة الدفع'),
            backgroundColor: AppColors.error),
      );
      return;
    }

    context.read<PaymentsBloc>().add(
          SubmitPaymentEvent(
            courseId: widget.courseId,
            receiptImage: _receiptImage!,
            transactionReference: _transactionRefController.text.trim(),
            paymentMethod: _selectedPaymentMethod!,
            amount: widget.amount,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final screenPadding = ResponsiveHelper.getScreenPadding(context);

    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: AppBar(
        title: const Text('رفع إيصال الدفع'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<PaymentsBloc, PaymentsState>(
        listener: (context, state) {
          if (state is PaymentSubmitted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PaymentStatusPage(paymentId: state.payment.id)),
            );
          } else if (state is PaymentsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is PaymentsLoading;

          return SingleChildScrollView(
            padding: EdgeInsets.all(screenPadding),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.courseName,
                              style: AppTextStyles.headlineSmall(context)),
                          const SizedBox(height: AppSizes.sm),
                          Text(
                              'المبلغ: ${widget.amount.toStringAsFixed(2)} ر.س',
                              style: AppTextStyles.bodyLarge(context).copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.lg),
                  Text('طريقة الدفع',
                      style: AppTextStyles.headlineSmall(context)),
                  const SizedBox(height: AppSizes.sm),
                  if (widget.acceptBankTransfer)
                    RadioListTile<String>(
                      value: ApiConstants.paymentMethodBankTransfer,
                      groupValue: _selectedPaymentMethod,
                      onChanged: isLoading
                          ? null
                          : (value) =>
                              setState(() => _selectedPaymentMethod = value),
                      title: const Text('تحويل بنكي'),
                      activeColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppSizes.radiusMd)),
                      tileColor: Colors.white,
                    ),
                  if (widget.acceptLocalTransfer)
                    RadioListTile<String>(
                      value: ApiConstants.paymentMethodLocalTransfer,
                      groupValue: _selectedPaymentMethod,
                      onChanged: isLoading
                          ? null
                          : (value) =>
                              setState(() => _selectedPaymentMethod = value),
                      title: const Text('تحويل محلي'),
                      activeColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppSizes.radiusMd)),
                      tileColor: Colors.white,
                    ),
                  const SizedBox(height: AppSizes.lg),
                  Text('رقم المعاملة',
                      style: AppTextStyles.headlineSmall(context)),
                  const SizedBox(height: AppSizes.sm),
                  TextFormField(
                    controller: _transactionRefController,
                    enabled: !isLoading,
                    decoration: InputDecoration(
                      hintText: 'أدخل رقم المعاملة',
                      prefixIcon: const Icon(Icons.numbers),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppSizes.radiusMd)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'يرجى إدخال رقم المعاملة';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSizes.lg),
                  Text('صورة الإيصال',
                      style: AppTextStyles.headlineSmall(context)),
                  const SizedBox(height: AppSizes.sm),
                  if (_receiptImage != null)
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(AppSizes.radiusMd),
                          child: Image.file(_receiptImage!,
                              height: 200.h,
                              width: double.infinity,
                              fit: BoxFit.cover),
                        ),
                        Positioned(
                          top: 8,
                          left: 8,
                          child: CircleAvatar(
                            backgroundColor: AppColors.error,
                            child: IconButton(
                              icon:
                                  const Icon(Icons.close, color: Colors.white),
                              onPressed: isLoading
                                  ? null
                                  : () => setState(() => _receiptImage = null),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    InkWell(
                      onTap: isLoading ? null : _showImageSourceDialog,
                      child: Container(
                        height: 200.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(AppSizes.radiusMd),
                          border: Border.all(
                              color: AppColors.textSecondary.withOpacity(0.3),
                              width: 2),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cloud_upload_outlined,
                                size: 60.sp, color: AppColors.primary),
                            const SizedBox(height: AppSizes.sm),
                            Text('اضغط لاختيار صورة الإيصال',
                                style: AppTextStyles.bodyLarge(context)
                                    .copyWith(color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: AppSizes.xl),
                  ElevatedButton(
                    onPressed: isLoading ? null : _submitPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppSizes.radiusMd)),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white)),
                          )
                        : Text('إرسال الدفع',
                            style: AppTextStyles.bodyLarge(context).copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
