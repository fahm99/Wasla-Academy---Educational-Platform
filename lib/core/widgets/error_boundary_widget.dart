import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../services/error_handler.dart';

/// Widget لمعالجة الأخطاء وعرضها للمستخدم
class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget Function(BuildContext context, Object error)? errorBuilder;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.errorBuilder,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Object? _error;

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return widget.errorBuilder?.call(context, _error!) ??
          ErrorDisplayWidget(
            error: _error!,
            onRetry: () {
              setState(() {
                _error = null;
              });
            },
          );
    }

    return ErrorCatcher(
      onError: (error, stackTrace) {
        setState(() {
          _error = error;
        });
        ErrorHandler().logError(error, stackTrace, context: 'ErrorBoundary');
      },
      child: widget.child,
    );
  }
}

/// Widget لالتقاط الأخطاء
class ErrorCatcher extends StatelessWidget {
  final Widget child;
  final void Function(Object error, StackTrace stackTrace)? onError;

  const ErrorCatcher({
    super.key,
    required this.child,
    this.onError,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

/// Widget لعرض الأخطاء
class ErrorDisplayWidget extends StatelessWidget {
  final Object error;
  final VoidCallback? onRetry;
  final bool showDetails;

  const ErrorDisplayWidget({
    super.key,
    required this.error,
    this.onRetry,
    this.showDetails = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.spaceLarge),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // أيقونة الخطأ
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.error_outline,
                    size: 60,
                    color: AppColors.error,
                  ),
                ),

                const SizedBox(height: AppSizes.spaceLarge),

                // عنوان الخطأ
                const Text(
                  'عذراً، حدث خطأ',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppSizes.spaceMedium),

                // رسالة الخطأ
                Text(
                  _getUserFriendlyMessage(error),
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),

                if (showDetails) ...[
                  const SizedBox(height: AppSizes.spaceMedium),
                  Container(
                    padding: const EdgeInsets.all(AppSizes.spaceMedium),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius:
                          BorderRadius.circular(AppSizes.radiusMedium),
                    ),
                    child: Text(
                      error.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: AppSizes.spaceLarge),

                // زر إعادة المحاولة
                if (onRetry != null)
                  ElevatedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh),
                    label: const Text('إعادة المحاولة'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.spaceLarge,
                        vertical: AppSizes.spaceMedium,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSizes.radiusMedium),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getUserFriendlyMessage(Object error) {
    final errorStr = error.toString().toLowerCase();

    if (errorStr.contains('network') || errorStr.contains('connection')) {
      return 'تحقق من اتصالك بالإنترنت وحاول مرة أخرى';
    } else if (errorStr.contains('timeout')) {
      return 'انتهت مهلة الاتصال. حاول مرة أخرى';
    } else if (errorStr.contains('unauthorized') || errorStr.contains('401')) {
      return 'انتهت جلستك. يرجى تسجيل الدخول مرة أخرى';
    } else if (errorStr.contains('forbidden') || errorStr.contains('403')) {
      return 'ليس لديك صلاحية للوصول إلى هذا المحتوى';
    } else if (errorStr.contains('not found') || errorStr.contains('404')) {
      return 'المحتوى المطلوب غير موجود';
    } else if (errorStr.contains('server') || errorStr.contains('500')) {
      return 'خطأ في الخادم. حاول مرة أخرى لاحقاً';
    }

    return 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى';
  }
}

/// Widget صغير لعرض رسالة خطأ
class ErrorMessageWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData icon;

  const ErrorMessageWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.icon = Icons.error_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spaceMedium),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.error, size: 40),
          const SizedBox(height: AppSizes.spaceSmall),
          Text(
            message,
            style: const TextStyle(color: AppColors.error),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: AppSizes.spaceSmall),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('إعادة المحاولة'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.error,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Snackbar للأخطاء
class ErrorSnackBar {
  static void show(BuildContext context, String message,
      {VoidCallback? onRetry}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: AppSizes.spaceSmall),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        action: onRetry != null
            ? SnackBarAction(
                label: 'إعادة',
                textColor: Colors.white,
                onPressed: onRetry,
              )
            : null,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
