import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:waslaacademy/core/constants/app_colors.dart';
import 'package:waslaacademy/core/constants/app_sizes.dart';
import 'package:waslaacademy/core/constants/app_text_styles.dart';

/// Simple video player widget with controls
///
/// Features:
/// - Play/Pause controls
/// - Progress bar with seek functionality
/// - Video completion callback
/// - Position change callback
/// - Fullscreen support
///
/// Usage:
/// ```dart
/// SimpleVideoPlayer(
///   videoUrl: 'https://example.com/video.mp4',
///   title: 'Lesson 1',
///   onVideoCompleted: () {
///     print('Video completed');
///   },
/// )
/// ```
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
  bool _showControls = true;
  String? _errorMessage;
  bool _notifiedCompletion = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  @override
  void dispose() {
    _controller?.removeListener(_videoListener);
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _initializePlayer() async {
    if (widget.videoUrl == null || widget.videoUrl!.isEmpty) {
      setState(() {
        _hasError = true;
        _errorMessage = 'رابط الفيديو غير متوفر';
      });
      return;
    }

    try {
      // Initialize video player with network URL
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl!),
      );

      await _controller!.initialize();

      // Add listener for video state changes
      _controller!.addListener(_videoListener);

      setState(() {
        _isInitialized = true;
      });

      // Auto play if enabled
      if (widget.autoPlay) {
        _controller!.play();
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'فشل في تحميل الفيديو: ${e.toString()}';
      });
    }
  }

  void _videoListener() {
    if (!mounted) return;

    // Notify position change
    if (widget.onPositionChanged != null && _controller != null) {
      widget.onPositionChanged!(_controller!.value.position);
    }

    // Check if video is completed (when position reaches 95% or more of duration)
    if (_controller != null &&
        _controller!.value.duration.inSeconds > 0 &&
        !_notifiedCompletion) {
      final position = _controller!.value.position.inSeconds;
      final duration = _controller!.value.duration.inSeconds;
      final completionPercentage = (position / duration) * 100;

      // Mark as completed when 95% of video is watched or video ends
      if (completionPercentage >= 95 || position >= duration) {
        _notifiedCompletion = true;
        if (widget.onVideoCompleted != null) {
          widget.onVideoCompleted!();
        }
      }
    }

    // Update UI
    if (mounted) {
      setState(() {});
    }
  }

  void _togglePlayPause() {
    if (_controller == null) return;

    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
      } else {
        _controller!.play();
        _showControls = false;
      }
    });
  }

  void _seekTo(Duration position) {
    if (_controller == null) return;
    _controller!.seekTo(position);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
    return '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }

  double _getCompletionPercentage(Duration position, Duration duration) {
    if (duration.inSeconds == 0) return 0;
    return (position.inSeconds / duration.inSeconds) * 100;
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
    final duration = _controller?.value.duration ?? Duration.zero;
    final position = _controller?.value.position ?? Duration.zero;
    final isPlaying = _controller?.value.isPlaying ?? false;

    return GestureDetector(
      onTap: () {
        setState(() {
          _showControls = !_showControls;
        });
      },
      child: Container(
        width: double.infinity,
        height: 250,
        color: Colors.black,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Video player - centered with proper aspect ratio and fit
            Center(
              child: AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: SizedBox(
                    width: _controller!.value.size.width,
                    height: _controller!.value.size.height,
                    child: AbsorbPointer(
                      // Prevent direct interaction with video player
                      absorbing: true,
                      child: VideoPlayer(_controller!),
                    ),
                  ),
                ),
              ),
            ),

            // Play/Pause button overlay
            if (_showControls || !isPlaying)
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
                    child: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            // Bottom controls
            if (_showControls)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(AppSizes.spaceMedium),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Progress bar
                      VideoProgressIndicator(
                        _controller!,
                        allowScrubbing: true,
                        colors: const VideoProgressColors(
                          playedColor: AppColors.primary,
                          bufferedColor: Colors.white30,
                          backgroundColor: Colors.white12,
                        ),
                      ),
                      const SizedBox(height: AppSizes.spaceSmall),
                      // Time and controls
                      Row(
                        children: [
                          Text(
                            _formatDuration(position),
                            style: AppTextStyles.caption(context).copyWith(
                              color: Colors.white,
                            ),
                          ),
                          const Text(
                            ' / ',
                            style: TextStyle(color: Colors.white70),
                          ),
                          Text(
                            _formatDuration(duration),
                            style: AppTextStyles.caption(context).copyWith(
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(width: AppSizes.spaceSmall),
                          // Completion percentage indicator
                          if (duration.inSeconds > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.spaceSmall,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _getCompletionPercentage(
                                            position, duration) >=
                                        95
                                    ? AppColors.success.withOpacity(0.8)
                                    : AppColors.primary.withOpacity(0.8),
                                borderRadius:
                                    BorderRadius.circular(AppSizes.radiusSmall),
                              ),
                              child: Text(
                                '${_getCompletionPercentage(position, duration).toStringAsFixed(0)}%',
                                style: AppTextStyles.caption(context).copyWith(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          const Spacer(),
                          // Rewind 10 seconds
                          IconButton(
                            onPressed: () {
                              final newPosition =
                                  position - const Duration(seconds: 10);
                              _seekTo(newPosition < Duration.zero
                                  ? Duration.zero
                                  : newPosition);
                            },
                            icon: const Icon(
                              Icons.replay_10,
                              color: Colors.white,
                            ),
                          ),
                          // Play/Pause
                          IconButton(
                            onPressed: _togglePlayPause,
                            icon: Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                            ),
                          ),
                          // Forward 10 seconds
                          IconButton(
                            onPressed: () {
                              final newPosition =
                                  position + const Duration(seconds: 10);
                              _seekTo(newPosition > duration
                                  ? duration
                                  : newPosition);
                            },
                            icon: const Icon(
                              Icons.forward_10,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

            // Title overlay
            if (_showControls)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(AppSizes.spaceMedium),
                  child: Text(
                    widget.title,
                    style: AppTextStyles.labelLarge(context).copyWith(
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
          ],
        ),
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
