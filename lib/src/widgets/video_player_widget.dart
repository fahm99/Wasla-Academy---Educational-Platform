import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:waslaacademy/src/constants/app_colors.dart';
import 'package:waslaacademy/src/constants/app_sizes.dart';
import 'package:waslaacademy/src/constants/app_text_styles.dart';

class SimpleVideoPlayer extends StatefulWidget {
  final String? videoUrl;
  final String title;
  final Function()? onVideoCompleted;
  final Function(Duration position)? onPositionChanged;
  final bool autoPlay;

  const SimpleVideoPlayer({
    super.key,
    this.videoUrl,
    required this.title,
    this.onVideoCompleted,
    this.onPositionChanged,
    this.autoPlay = false,
  });

  @override
  State<SimpleVideoPlayer> createState() => _SimpleVideoPlayerState();
}

class _SimpleVideoPlayerState extends State<SimpleVideoPlayer> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  final bool _showControls = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _initializePlayer() async {
    try {
      // For demo purposes, we'll create a mock video player
      // In production, you would use widget.videoUrl
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'فشل في تحميل الفيديو';
      });
    }
  }

  void _togglePlayPause() {
    // Mock play/pause functionality
    if (widget.onVideoCompleted != null) {
      widget.onVideoCompleted!();
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return _buildErrorWidget();
    }

    if (!_isInitialized) {
      return _buildLoadingWidget();
    }

    return _buildVideoPlayer();
  }

  Widget _buildErrorWidget() {
    return Container(
      height: 200,
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 48,
            ),
            const SizedBox(height: AppSizes.spaceMedium),
            Text(
              'خطأ في تشغيل الفيديو',
              style: AppTextStyles.bodyLarge(context).copyWith(
                color: Colors.white,
              ),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: AppSizes.spaceSmall),
              Text(
                _errorMessage!,
                style: AppTextStyles.bodyMedium(context).copyWith(
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      height: 200,
      color: Colors.black,
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return Container(
      height: 200,
      color: Colors.black,
      child: Stack(
        children: [
          // Video background
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),

          // Play button
          Center(
            child: GestureDetector(
              onTap: _togglePlayPause,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.play_arrow,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Video info overlay
          Positioned(
            bottom: AppSizes.spaceMedium,
            left: AppSizes.spaceMedium,
            right: AppSizes.spaceMedium,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: AppTextStyles.labelLarge(context).copyWith(
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSizes.spaceXSmall),
                Row(
                  children: [
                    const Icon(
                      Icons.play_circle_outline,
                      size: AppSizes.iconSmall,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: AppSizes.spaceXSmall),
                    Text(
                      'فيديو تجريبي',
                      style: AppTextStyles.caption(context).copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Controls overlay
          if (_showControls)
            Positioned(
              top: AppSizes.spaceMedium,
              right: AppSizes.spaceMedium,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // Toggle fullscreen
                    },
                    icon: const Icon(
                      Icons.fullscreen,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Toggle settings
                    },
                    icon: const Icon(
                      Icons.settings,
                      color: Colors.white,
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

/// Simple video placeholder for demo purposes
class VideoPlaceholder extends StatelessWidget {
  final String title;
  final String duration;
  final VoidCallback? onPlay;

  const VideoPlaceholder({
    super.key,
    required this.title,
    required this.duration,
    this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            ),
          ),

          // Play button
          Center(
            child: GestureDetector(
              onTap: onPlay,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.play_arrow,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Video info
          Positioned(
            bottom: AppSizes.spaceMedium,
            left: AppSizes.spaceMedium,
            right: AppSizes.spaceMedium,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.labelLarge(context).copyWith(
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSizes.spaceXSmall),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: AppSizes.iconSmall,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: AppSizes.spaceXSmall),
                    Text(
                      duration,
                      style: AppTextStyles.caption(context).copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
