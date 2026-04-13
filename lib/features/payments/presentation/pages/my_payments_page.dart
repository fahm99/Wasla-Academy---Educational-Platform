import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../bloc/payments_bloc.dart';
import '../bloc/payments_event.dart';
import '../bloc/payments_state.dart';
import '../../data/models/payment_model.dart';
import 'payment_status_page.dart';

class MyPaymentsPage extends StatefulWidget {
  const MyPaymentsPage({super.key});

  @override
  State<MyPaymentsPage> createState() => _MyPaymentsPageState();
}

class _MyPaymentsPageState extends State<MyPaymentsPage> {
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    // Load data in initState for first time
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaymentsBloc>().add(const LoadMyPaymentsEvent());
    });
  }

  void _refreshData() {
    context.read<PaymentsBloc>().add(const LoadMyPaymentsEvent());
  }

  List<PaymentModel> _filterPayments(List<PaymentModel> payments) {
    if (_selectedStatus == null || _selectedStatus == 'all') {
      return payments;
    }
    return payments.where((p) => p.status == _selectedStatus).toList();
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

  @override
  Widget build(BuildContext context) {
    final screenPadding = ResponsiveHelper.getScreenPadding(context);

    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: AppBar(
        title: const Text('مدفوعاتي'),
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
                    onPressed: () => context
                        .read<PaymentsBloc>()
                        .add(const LoadMyPaymentsEvent()),
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          if (state is PaymentsListLoaded) {
            final allPayments = state.payments;
            final filteredPayments = _filterPayments(allPayments);

            if (allPayments.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.payment_outlined,
                        size: 80.sp,
                        color: AppColors.textSecondary.withOpacity(0.5)),
                    const SizedBox(height: AppSizes.md),
                    Text('لا توجد مدفوعات',
                        style: AppTextStyles.headlineSmall(context)
                            .copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: AppSizes.sm),
                    Text('لم تقم بأي عملية دفع حتى الآن',
                        style: AppTextStyles.bodyMedium(context)
                            .copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              );
            }

            return Column(
              children: [
                Container(
                  padding: EdgeInsets.all(screenPadding),
                  color: Colors.white,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('الكل', 'all', allPayments.length),
                        const SizedBox(width: AppSizes.sm),
                        _buildFilterChip(
                          'قيد المراجعة',
                          ApiConstants.paymentStatusPending,
                          allPayments
                              .where((p) =>
                                  p.status == ApiConstants.paymentStatusPending)
                              .length,
                        ),
                        const SizedBox(width: AppSizes.sm),
                        _buildFilterChip(
                          'مقبول',
                          ApiConstants.paymentStatusCompleted,
                          allPayments
                              .where((p) =>
                                  p.status ==
                                  ApiConstants.paymentStatusCompleted)
                              .length,
                        ),
                        const SizedBox(width: AppSizes.sm),
                        _buildFilterChip(
                          'مرفوض',
                          ApiConstants.paymentStatusRejected,
                          allPayments
                              .where((p) =>
                                  p.status ==
                                  ApiConstants.paymentStatusRejected)
                              .length,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: filteredPayments.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.filter_list_off,
                                  size: 60.sp,
                                  color:
                                      AppColors.textSecondary.withOpacity(0.5)),
                              const SizedBox(height: AppSizes.md),
                              Text('لا توجد مدفوعات بهذه الحالة',
                                  style: AppTextStyles.bodyLarge(context)
                                      .copyWith(
                                          color: AppColors.textSecondary)),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            context
                                .read<PaymentsBloc>()
                                .add(const LoadMyPaymentsEvent());
                          },
                          child: ListView.builder(
                            padding: EdgeInsets.all(screenPadding),
                            itemCount: filteredPayments.length,
                            itemBuilder: (context, index) {
                              final payment = filteredPayments[index];
                              return _buildPaymentCard(payment);
                            },
                          ),
                        ),
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, int count) {
    final isSelected =
        _selectedStatus == value || (_selectedStatus == null && value == 'all');

    return FilterChip(
      label: Text('$label ($count)'),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedStatus = selected ? value : null;
        });
      },
      selectedColor: AppColors.primary.withOpacity(0.2),
      checkmarkColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildPaymentCard(PaymentModel payment) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: AppSizes.md),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PaymentStatusPage(paymentId: payment.id)),
          ).then((_) => _refreshData());
        },
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text('دفعة #${payment.id.substring(0, 8)}',
                        style: AppTextStyles.bodyLarge(context)
                            .copyWith(fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.sm, vertical: AppSizes.xs),
                    decoration: BoxDecoration(
                      color: _getStatusColor(payment.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    ),
                    child: Text(_getStatusText(payment.status),
                        style: AppTextStyles.bodySmall(context).copyWith(
                            color: _getStatusColor(payment.status),
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.sm),
              Row(
                children: [
                  Icon(Icons.payments_outlined,
                      size: 18.sp, color: AppColors.textSecondary),
                  const SizedBox(width: AppSizes.xs),
                  Text('${payment.amount.toStringAsFixed(2)} ر.س',
                      style: AppTextStyles.headlineSmall(context)
                          .copyWith(color: AppColors.primary)),
                ],
              ),
              const SizedBox(height: AppSizes.sm),
              Row(
                children: [
                  Icon(Icons.numbers,
                      size: 18.sp, color: AppColors.textSecondary),
                  const SizedBox(width: AppSizes.xs),
                  Expanded(
                    child: Text('رقم المعاملة: ${payment.transactionReference}',
                        style: AppTextStyles.bodyMedium(context)
                            .copyWith(color: AppColors.textSecondary)),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.sm),
              Row(
                children: [
                  Icon(Icons.calendar_today,
                      size: 18.sp, color: AppColors.textSecondary),
                  const SizedBox(width: AppSizes.xs),
                  Text(
                    payment.paymentDate != null
                        ? '${payment.paymentDate!.year}-${payment.paymentDate!.month.toString().padLeft(2, '0')}-${payment.paymentDate!.day.toString().padLeft(2, '0')}'
                        : '${payment.createdAt.year}-${payment.createdAt.month.toString().padLeft(2, '0')}-${payment.createdAt.day.toString().padLeft(2, '0')}',
                    style: AppTextStyles.bodyMedium(context)
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
              if (payment.status == ApiConstants.paymentStatusRejected &&
                  payment.rejectionReason != null) ...[
                const SizedBox(height: AppSizes.sm),
                Container(
                  padding: const EdgeInsets.all(AppSizes.sm),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.warning_amber_rounded,
                          size: 16.sp, color: AppColors.error),
                      const SizedBox(width: AppSizes.xs),
                      Expanded(
                        child: Text(payment.rejectionReason!,
                            style: AppTextStyles.bodySmall(context)
                                .copyWith(color: AppColors.error),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: AppSizes.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('عرض التفاصيل',
                      style: AppTextStyles.bodySmall(context).copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold)),
                  Icon(Icons.arrow_back_ios,
                      size: 12.sp, color: AppColors.primary),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
