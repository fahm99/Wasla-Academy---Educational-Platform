import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../../core/services/payment_validator.dart';
import '../widgets/payment_status_badge.dart';
import '../bloc/payments_bloc.dart';
import '../bloc/payments_event.dart';
import '../bloc/payments_state.dart';
import '../../data/models/payment_model.dart';

class PaymentStatusPage extends StatefulWidget {
  final String paymentId;

  const PaymentStatusPage({
    super.key,
    required this.paymentId,
  });

  @override
  State<PaymentStatusPage> createState() => _PaymentStatusPageState();
}

class _PaymentStatusPageState extends State<PaymentStatusPage> {
  final _imagePicker = ImagePicker();
  File? _newReceiptImage;
  final _transactionRefController = TextEditingController();
  bool _isResubmitting = false;

  @override
  void initState() {
    super.initState();
    // Load data in initState for first time
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaymentsBloc>().add(LoadPaymentByIdEvent(widget.paymentId));
    });
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
          _newReceiptImage = File(image.path);
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

  void _showResubmitDialog(PaymentModel payment) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('إعادة إرسال الدفع'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('يرجى تحديث معلومات الدفع وإعادة الإرسال'),
              const SizedBox(height: AppSizes.md),
              TextFormField(
                controller: _transactionRefController,
                decoration: InputDecoration(
                  labelText: 'رقم المعاملة الجديد',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
                ),
              ),
              const SizedBox(height: AppSizes.md),
              if (_newReceiptImage != null)
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      child: Image.file(_newReceiptImage!,
                          height: 150.h,
                          width: double.infinity,
                          fit: BoxFit.cover),
                    ),
                    Positioned(
                      top: 4,
                      left: 4,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.error,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.close,
                              color: Colors.white, size: 16),
                          onPressed: () {
                            setState(() {
                              _newReceiptImage = null;
                            });
                            Navigator.pop(dialogContext);
                            _showResubmitDialog(payment);
                          },
                        ),
                      ),
                    ),
                  ],
                )
              else
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    _showImageSourceDialog();
                    Future.delayed(const Duration(milliseconds: 500), () {
                      _showResubmitDialog(payment);
                    });
                  },
                  icon: const Icon(Icons.image),
                  label: const Text('اختيار صورة إيصال جديدة'),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              setState(() {
                _newReceiptImage = null;
                _transactionRefController.clear();
              });
            },
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_transactionRefController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('يرجى إدخال رقم المعاملة'),
                      backgroundColor: AppColors.error),
                );
                return;
              }
              if (_newReceiptImage == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('يرجى اختيار صورة الإيصال'),
                      backgroundColor: AppColors.error),
                );
                return;
              }

              Navigator.pop(dialogContext);
              setState(() {
                _isResubmitting = true;
              });

              context.read<PaymentsBloc>().add(
                    ResubmitPaymentEvent(
                      paymentId: payment.id,
                      receiptImage: _newReceiptImage!,
                      transactionReference:
                          _transactionRefController.text.trim(),
                    ),
                  );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('إرسال'),
          ),
        ],
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case ApiConstants.paymentStatusPending:
        return 'قيد المراجعة';
      case ApiConstants.paymentStatusCompleted:
        return 'مقبول';
      case ApiConstants.paymentStatusRejected:
        return 'مرفوض';
      case ApiConstants.paymentStatusFailed:
        return 'فشل';
      case ApiConstants.paymentStatusRefunded:
        return 'مسترد';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case ApiConstants.paymentStatusPending:
        return AppColors.warning;
      case ApiConstants.paymentStatusCompleted:
        return AppColors.success;
      case ApiConstants.paymentStatusRejected:
      case ApiConstants.paymentStatusFailed:
        return AppColors.error;
      case ApiConstants.paymentStatusRefunded:
        return AppColors.info;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case ApiConstants.paymentStatusPending:
        return Icons.hourglass_empty;
      case ApiConstants.paymentStatusCompleted:
        return Icons.check_circle;
      case ApiConstants.paymentStatusRejected:
      case ApiConstants.paymentStatusFailed:
        return Icons.cancel;
      case ApiConstants.paymentStatusRefunded:
        return Icons.refresh;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenPadding = ResponsiveHelper.getScreenPadding(context);

    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: AppBar(
        title: const Text('حالة الدفع'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<PaymentsBloc, PaymentsState>(
        listener: (context, state) {
          if (state is PaymentResubmitted) {
            setState(() {
              _isResubmitting = false;
              _newReceiptImage = null;
              _transactionRefController.clear();
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('تم إعادة إرسال الدفع بنجاح'),
                  backgroundColor: AppColors.success),
            );
            context
                .read<PaymentsBloc>()
                .add(LoadPaymentByIdEvent(widget.paymentId));
          } else if (state is PaymentsError && _isResubmitting) {
            setState(() {
              _isResubmitting = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error),
            );
          }
        },
        builder: (context, state) {
          if (state is PaymentsLoading && !_isResubmitting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PaymentsError && !_isResubmitting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline,
                      size: 60.sp, color: AppColors.error),
                  const SizedBox(height: AppSizes.md),
                  Text(state.message,
                      style: AppTextStyles.bodyLarge(context),
                      textAlign: TextAlign.center),
                  const SizedBox(height: AppSizes.md),
                  ElevatedButton(
                    onPressed: () => context
                        .read<PaymentsBloc>()
                        .add(LoadPaymentByIdEvent(widget.paymentId)),
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          if (state is PaymentLoaded || state is PaymentResubmitted) {
            final payment = state is PaymentLoaded
                ? state.payment
                : (state as PaymentResubmitted).payment;

            return SingleChildScrollView(
              padding: EdgeInsets.all(screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.lg),
                      child: Column(
                        children: [
                          Icon(_getStatusIcon(payment.status),
                              size: 60.sp,
                              color: _getStatusColor(payment.status)),
                          const SizedBox(height: AppSizes.md),
                          Text(_getStatusText(payment.status),
                              style: AppTextStyles.headlineMedium(context)
                                  .copyWith(
                                      color: _getStatusColor(payment.status),
                                      fontWeight: FontWeight.bold)),
                          if (payment.status ==
                              ApiConstants.paymentStatusPending)
                            Padding(
                              padding: const EdgeInsets.only(top: AppSizes.sm),
                              child: Text('سيتم مراجعة دفعتك قريباً',
                                  style: AppTextStyles.bodyMedium(context)
                                      .copyWith(color: AppColors.textSecondary),
                                  textAlign: TextAlign.center),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.lg),
                  Text('تفاصيل الدفع',
                      style: AppTextStyles.headlineSmall(context)),
                  const SizedBox(height: AppSizes.sm),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.md),
                      child: Column(
                        children: [
                          _buildDetailRow('المبلغ',
                              '${payment.amount.toStringAsFixed(2)} ر.س'),
                          _buildDetailRow(
                              'رقم المعاملة', payment.transactionReference),
                          _buildDetailRow(
                            'طريقة الدفع',
                            payment.paymentMethod ==
                                    ApiConstants.paymentMethodBankTransfer
                                ? 'تحويل بنكي'
                                : 'تحويل محلي',
                          ),
                          _buildDetailRow(
                            'تاريخ الإرسال',
                            payment.paymentDate != null
                                ? '${payment.paymentDate!.year}-${payment.paymentDate!.month.toString().padLeft(2, '0')}-${payment.paymentDate!.day.toString().padLeft(2, '0')}'
                                : '${payment.createdAt.year}-${payment.createdAt.month.toString().padLeft(2, '0')}-${payment.createdAt.day.toString().padLeft(2, '0')}',
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (payment.status == ApiConstants.paymentStatusRejected &&
                      payment.rejectionReason != null) ...[
                    const SizedBox(height: AppSizes.lg),
                    Text('سبب الرفض',
                        style: AppTextStyles.headlineSmall(context)),
                    const SizedBox(height: AppSizes.sm),
                    Card(
                      elevation: 2,
                      color: AppColors.error.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppSizes.radiusMd)),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSizes.md),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.warning_amber_rounded,
                                color: AppColors.error, size: 24.sp),
                            const SizedBox(width: AppSizes.sm),
                            Expanded(
                                child: Text(payment.rejectionReason!,
                                    style: AppTextStyles.bodyMedium(context))),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSizes.lg),
                  Text('صورة الإيصال',
                      style: AppTextStyles.headlineSmall(context)),
                  const SizedBox(height: AppSizes.sm),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    child: CachedNetworkImage(
                      imageUrl: payment.receiptImageUrl,
                      height: 250.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 250.h,
                        color: Colors.grey[200],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 250.h,
                        color: Colors.grey[200],
                        child: const Icon(Icons.error),
                      ),
                    ),
                  ),
                  if (payment.status == ApiConstants.paymentStatusRejected) ...[
                    const SizedBox(height: AppSizes.xl),
                    ElevatedButton(
                      onPressed: _isResubmitting
                          ? null
                          : () => _showResubmitDialog(payment),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding:
                            const EdgeInsets.symmetric(vertical: AppSizes.md),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppSizes.radiusMd)),
                      ),
                      child: _isResubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white)),
                            )
                          : Text('إعادة إرسال الدفع',
                              style: AppTextStyles.bodyLarge(context).copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                    ),
                  ],
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: AppTextStyles.bodyMedium(context)
                  .copyWith(color: AppColors.textSecondary)),
          Expanded(
            child: Text(value,
                style: AppTextStyles.bodyLarge(context)
                    .copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.left),
          ),
        ],
      ),
    );
  }
}
