import 'package:flutter/material.dart';
import 'package:waslaacademy/src/user/constants/app_colors.dart';
import 'package:waslaacademy/src/user/constants/app_sizes.dart';
import 'package:waslaacademy/src/user/constants/app_text_styles.dart';

class NotificationBadge extends StatelessWidget {
  final int count;
  final Widget child;
  final Color? badgeColor;
  final Color? textColor;
  final double? size;
  final EdgeInsetsGeometry? padding;
  final bool showZero;

  const NotificationBadge({
    super.key,
    required this.count,
    required this.child,
    this.badgeColor,
    this.textColor,
    this.size,
    this.padding,
    this.showZero = false,
  });

  @override
  Widget build(BuildContext context) {
    final shouldShow = showZero || count > 0;
    final badgeSize = size ?? AppSizes.badgeMedium;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (shouldShow)
          Positioned(
            right: -6,
            top: -6,
            child: Container(
              height: badgeSize,
              padding: padding ?? const EdgeInsets.all(AppSizes.spaceXSmall / 2),
              decoration: BoxDecoration(
                color: badgeColor ?? AppColors.danger,
                borderRadius: BorderRadius.circular(badgeSize / 2),
                border: Border.all(
                  color: Colors.white,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  count > 99 ? '99+' : count.toString(),
                  style: AppTextStyles.badge(context).copyWith(
                    color: textColor ?? Colors.white,
                    fontSize: AppSizes.fontXSmall,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Badge بسيط بدون نص (نقطة حمراء فقط)
class SimpleBadge extends StatelessWidget {
  final Widget child;
  final bool show;
  final Color? color;
  final double? size;

  const SimpleBadge({
    super.key,
    required this.child,
    required this.show,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final badgeSize = size ?? 8.0;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (show)
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              width: badgeSize,
              height: badgeSize,
              decoration: BoxDecoration(
                color: color ?? AppColors.danger,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Badge مع أيقونة
class IconBadge extends StatelessWidget {
  final IconData icon;
  final int count;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? badgeColor;
  final double? iconSize;

  const IconBadge({
    super.key,
    required this.icon,
    required this.count,
    this.onTap,
    this.iconColor,
    this.badgeColor,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceSmall),
        child: NotificationBadge(
          count: count,
          badgeColor: badgeColor,
          child: Icon(
            icon,
            size: iconSize ?? AppSizes.iconLarge,
            color: iconColor ?? AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

/// Badge متحرك مع تأثير النبض
class AnimatedNotificationBadge extends StatefulWidget {
  final int count;
  final Widget child;
  final Color? badgeColor;
  final Duration animationDuration;
  final bool enablePulse;

  const AnimatedNotificationBadge({
    super.key,
    required this.count,
    required this.child,
    this.badgeColor,
    this.animationDuration = const Duration(milliseconds: 300),
    this.enablePulse = true,
  });

  @override
  State<AnimatedNotificationBadge> createState() =>
      _AnimatedNotificationBadgeState();
}

class _AnimatedNotificationBadgeState extends State<AnimatedNotificationBadge>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  int _previousCount = 0;

  @override
  void initState() {
    super.initState();
    _previousCount = widget.count;

    _scaleController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.count > 0) {
      _scaleController.forward();
      if (widget.enablePulse) {
        _pulseController.repeat(reverse: true);
      }
    }
  }

  @override
  void didUpdateWidget(AnimatedNotificationBadge oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.count != _previousCount) {
      if (widget.count > 0 && _previousCount == 0) {
        // Badge appeared
        _scaleController.forward();
        if (widget.enablePulse) {
          _pulseController.repeat(reverse: true);
        }
      } else if (widget.count == 0 && _previousCount > 0) {
        // Badge disappeared
        _scaleController.reverse();
        _pulseController.stop();
      } else if (widget.count > _previousCount) {
        // Count increased - pulse once
        _pulseController.forward().then((_) {
          _pulseController.reverse();
          if (widget.enablePulse) {
            _pulseController.repeat(reverse: true);
          }
        });
      }
      _previousCount = widget.count;
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        widget.child,
        if (widget.count > 0)
          Positioned(
            right: -6,
            top: -6,
            child: AnimatedBuilder(
              animation: Listenable.merge([_scaleAnimation, _pulseAnimation]),
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value * _pulseAnimation.value,
                  child: Container(
                    height: AppSizes.badgeMedium,
                    padding: const EdgeInsets.all(AppSizes.spaceXSmall / 2),
                    decoration: BoxDecoration(
                      color: widget.badgeColor ?? AppColors.danger,
                      borderRadius:
                          BorderRadius.circular(AppSizes.badgeMedium / 2),
                      border: Border.all(
                        color: Colors.white,
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        widget.count > 99 ? '99+' : widget.count.toString(),
                        style: AppTextStyles.badge(context).copyWith(
                          fontSize: AppSizes.fontXSmall,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
