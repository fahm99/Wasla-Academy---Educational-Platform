import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../bloc/payments_bloc.dart';
import '../bloc/payments_event.dart';
import '../bloc/payments_state.dart';
import 'payment_upload_page.dart';

class PaymentInfoPage extends StatefulWidget {
  final String providerId;
  final String courseId;
  final String courseName;
  final double amount;

  const PaymentInfoPage({
    super.key,
    required this.providerId,
    required this.courseId,
    required this.courseName,
    required this.amount,
  });

  @override
  State<PaymentInfoPage> createState() => _PaymentInfoPageState();
}

class _PaymentInfoPageState extends State<PaymentInfoPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<PaymentsBloc>()
          .add(LoadProviderPaymentSettingsEvent(widget.providerId));
    });
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم نسخ $label'),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenPadding = ResponsiveHelper.getScreenPadding(context);

    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: AppBar(
        title: const Text('معلومات الدفع'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<PaymentsBloc, PaymentsState>(
        builder: (context, state) {
          if (state is PaymentsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PaymentsError) {
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
                    onPressed: () => context.read<PaymentsBloc>().add(
                        LoadProviderPaymentSettingsEvent(widget.providerId)),
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          if (state is PaymentSettingsLoaded) {
            final settings = state.settings;

            return SingleChildScrollView(
              padding: EdgeInsets.all(screenPadding),
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
                          Text('تفاصيل الكورس',
                              style: AppTextStyles.headlineSmall(context)),
                          const SizedBox(height: AppSizes.sm),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Text(widget.courseName,
                                      style: AppTextStyles.bodyLarge(context))),
                              Text('${widget.amount.toStringAsFixed(2)} ر.س',
                                  style: AppTextStyles.headlineSmall(context)
                                      .copyWith(color: AppColors.primary)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.lg),
                  Text('طرق الدفع المتاحة',
                      style: AppTextStyles.headlineSmall(context)),
                  const SizedBox(height: AppSizes.sm),
                  if (settings.acceptBankTransfer)
                    _buildPaymentMethodCard(
                        icon: Icons.account_balance,
                        title: 'تحويل بنكي',
                        isAvailable: true),
                  if (settings.acceptLocalTransfer)
                    _buildPaymentMethodCard(
                        icon: Icons.payment,
                        title: 'تحويل محلي',
                        isAvailable: true),
                  const SizedBox(height: AppSizes.lg),
                  if (settings.acceptBankTransfer) ...[
                    Text('معلومات الحساب البنكي',
                        style: AppTextStyles.headlineSmall(context)),
                    const SizedBox(height: AppSizes.sm),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppSizes.radiusMd)),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSizes.md),
                        child: Column(
                          children: [
                            if (settings.bankName != null)
                              _buildInfoRow('اسم البنك', settings.bankName!,
                                  canCopy: true),
                            if (settings.accountHolderName != null)
                              _buildInfoRow('اسم صاحب الحساب',
                                  settings.accountHolderName!,
                                  canCopy: true),
                            if (settings.iban != null)
                              _buildInfoRow('رقم الآيبان', settings.iban!,
                                  canCopy: true),
                            if (settings.accountNumber != null)
                              _buildInfoRow(
                                  'رقم الحساب', settings.accountNumber!,
                                  canCopy: true),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSizes.lg),
                  if (settings.instructions != null) ...[
                    Text('تعليمات الدفع',
                        style: AppTextStyles.headlineSmall(context)),
                    const SizedBox(height: AppSizes.sm),
                    Card(
                      elevation: 2,
                      color: AppColors.info.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppSizes.radiusMd)),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSizes.md),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.info_outline,
                                color: AppColors.info, size: 24.sp),
                            const SizedBox(width: AppSizes.sm),
                            Expanded(
                                child: Text(settings.instructions!,
                                    style: AppTextStyles.bodyMedium(context))),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSizes.xl),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentUploadPage(
                            courseId: widget.courseId,
                            courseName: widget.courseName,
                            amount: widget.amount,
                            acceptBankTransfer: settings.acceptBankTransfer,
                            acceptLocalTransfer: settings.acceptLocalTransfer,
                          ),
                        ),
                      ).then((_) {
                        // Reload payment settings when returning
                        context.read<PaymentsBloc>().add(
                            LoadProviderPaymentSettingsEvent(
                                widget.providerId));
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding:
                          const EdgeInsets.symmetric(vertical: AppSizes.md),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppSizes.radiusMd)),
                    ),
                    child: Text('رفع إيصال الدفع',
                        style: AppTextStyles.bodyLarge(context).copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildPaymentMethodCard(
      {required IconData icon,
      required String title,
      required bool isAvailable}) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.sm),
              decoration: BoxDecoration(
                color: isAvailable
                    ? AppColors.primary.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: Icon(icon,
                  color: isAvailable ? AppColors.primary : Colors.grey,
                  size: 24.sp),
            ),
            const SizedBox(width: AppSizes.md),
            Expanded(
                child: Text(title, style: AppTextStyles.bodyLarge(context))),
            if (isAvailable)
              Icon(Icons.check_circle, color: AppColors.success, size: 20.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool canCopy = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: AppTextStyles.bodyMedium(context)
                  .copyWith(color: AppColors.textSecondary)),
          Row(
            children: [
              Text(value,
                  style: AppTextStyles.bodyLarge(context)
                      .copyWith(fontWeight: FontWeight.bold)),
              if (canCopy) ...[
                const SizedBox(width: AppSizes.sm),
                InkWell(
                  onTap: () => _copyToClipboard(value, label),
                  child:
                      Icon(Icons.copy, size: 18.sp, color: AppColors.primary),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
