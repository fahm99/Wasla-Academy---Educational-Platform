import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/services/payment_validator.dart';

/// Badge لعرض حالة الدفع
class PaymentStatusBadge extends StatelessWidget {
  final String status;
  final bool showIcon;
  final double? fontSize;

  const PaymentStatusBadge({
    super.key,
    required this.status,
    this.showIcon = true,
    this.fontSize,
  });

  Color _getStatusColor() {
    if (PaymentValidator.isPaymentApproved(status)) {
      return AppColors.success;
    } else if (PaymentValidator.isPaymentRejected(status)) {
      return AppColors.error;
    } else if (PaymentValidator.isPaymentPending(status)) {
      return AppColors.warning;
    }
    return AppColors.textSecondary;
  }

  IconData _getStatusIcon() {
    if (PaymentValidator.isPaymentApproved(status)) {
      return Icons.check_circle;
    } else if (PaymentValidator.isPaymentRejected(status)) {
      return Icons.cancel;
    } else if (PaymentValidator.isPaymentPending(status)) {
      return Icons.pending;
    }
    return Icons.help;
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor();
    final text = PaymentValidator.getStatusText(status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceMedium,
        vertical: AppSizes.spaceSmall,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(_getStatusIcon(), size: fontSize ?? 16, color: color),
            const SizedBox(width: AppSizes.spaceSmall),
          ],
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: fontSize ?? 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Card لعرض تفاصيل الدفع
class PaymentInfoCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final bool isHighlighted;

  const PaymentInfoCard({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spaceMedium),
      decoration: BoxDecoration(
        color: isHighlighted
            ? AppColors.primary.withOpacity(0.05)
            : Colors.grey[50],
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: Border.all(
          color: isHighlighted
              ? AppColors.primary.withOpacity(0.2)
              : Colors.grey[200]!,
        ),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color:
                  isHighlighted ? AppColors.primary : AppColors.textSecondary,
              size: 24,
            ),
            const SizedBox(width: AppSizes.spaceMedium),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: AppSizes.spaceXSmall),
                Text(
                  value,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget لعرض صورة الإيصال
class ReceiptImagePreview extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback? onTap;

  const ReceiptImagePreview({
    super.key,
    this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
              SizedBox(height: AppSizes.spaceSmall),
              Text('لا توجد صورة', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline,
                              size: 48, color: Colors.red),
                          SizedBox(height: AppSizes.spaceSmall),
                          Text('فشل تحميل الصورة',
                              style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  );
                },
              ),
              if (onTap != null)
                Positioned(
                  bottom: AppSizes.spaceSmall,
                  right: AppSizes.spaceSmall,
                  child: Container(
                    padding: const EdgeInsets.all(AppSizes.spaceSmall),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.zoom_in, color: Colors.white, size: 16),
                        SizedBox(width: AppSizes.spaceXSmall),
                        Text(
                          'اضغط للتكبير',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
