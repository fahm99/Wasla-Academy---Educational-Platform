import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_text_styles.dart';

/// محسّن Video Player مع معالجة أخطاء شاملة
class EnhancedVideoPlayer extends StatefulWidget {
  final String? videoUrl;
  final String title;
  final Function()? onVideoCompleted;
  final Function(Duration position)? onPositionChanged;
  final bool autoPlay;

  const EnhancedVideoPlayer({
    super.key,
    this.videoUrl,
    required this.title,
    this.onVideoCompleted,
    this.onPositionChanged,
    this.autoPlay = false,
  });

  @override
  State<EnhancedVideoPlayer> createState() => _EnhancedVideoPlayerState();
}

class _EnhancedVideoPlayerState extends State<EnhancedVideoPlayer> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  bool _showControls = true;
  bool _isBuffering = false;
  String? _errorMessage;
  bool _notifiedCompletion = false;
  int _retryCount = 0;
  static const int _maxRetries = 3;

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
      setState(() {
        _hasError = false;
        _errorMessage = null;
      });

      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl!),
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: false,
          allowBackgroundPlayback: false,
        ),
      );

      await _controller!.initialize();
      _controller!.addListener(_videoListener);

      setState(() {
        _isInitialized = true;
        _retryCount = 0;
      });

      if (widget.autoPlay) {
        _controller!.play();
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = _getErrorMessage(e);
      });
    }
  }

  String _getErrorMessage(dynamic error) {
    final errorStr = error.toString().toLowerCase();

    if (errorStr.contains('network') || errorStr.contains('connection')) {
      return 'خطأ في الاتصال. تحقق من الإنترنت وحاول مرة أخرى.';
    } else if (errorStr.contains('format') || errorStr.contains('codec')) {
      return 'تنسيق الفيديو غير مدعوم';
    } else if (errorStr.contains('404')) {
      return 'الفيديو غير موجود';
    } else if (errorStr.contains('403')) {
      return 'ليس لديك صلاحية لمشاهدة هذا الفيديو';
    }

    return 'فشل في تحميل الفيديو. حاول مرة أخرى.';
  }

  Future<void> _retryLoad() async {
    if (_retryCount >= _maxRetries) {
      setState(() {
        _errorMessage = 'فشل التحميل بعد $_maxRetries محاولات';
      });
      return;
    }

    _retryCount++;
    await _controller?.dispose();
    _controller = null;

    setState(() {
      _isInitialized = false;
      _hasError = false;
    });

    await Future.delayed(Duration(seconds: _retryCount));
    await _initializePlayer();
  }

  void _videoListener() {
    if (!mounted) return;

    // Check buffering state
    final isBuffering = _controller!.value.isBuffering;
    if (isBuffering != _isBuffering) {
      setState(() {
        _isBuffering = isBuffering;
      });
    }

    // Notify position change
    if (widget.onPositionChanged != null && _controller != null) {
      widget.onPositionChanged!(_controller!.value.position);
    }

    // Check completion
    if (_controller != null &&
        _controller!.value.duration.inSeconds > 0 &&
        !_notifiedCompletion) {
      final position = _controller!.value.position.inSeconds;
      final duration = _controller!.value.duration.inSeconds;
      final completionPercentage = (position / duration) * 100;

      if (completionPercentage >= 95 || position >= duration) {
        _notifiedCompletion = true;
        if (widget.onVideoCompleted != null) {
          widget.onVideoCompleted!();
        }
      }
    }

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
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spaceMedium),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 48),
              const SizedBox(height: AppSizes.spaceMedium),
              Text(
                'خطأ في تشغيل الفيديو',
                style: AppTextStyles.bodyLarge(context)
                    .copyWith(color: Colors.white),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: AppSizes.spaceSmall),
                Text(
                  _errorMessage!,
                  style: AppTextStyles.bodyMedium(context)
                      .copyWith(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: AppSizes.spaceMedium),
              if (_retryCount < _maxRetries)
                ElevatedButton.icon(
                  onPressed: _retryLoad,
                  icon: const Icon(Icons.refresh),
                  label:
                      Text('إعادة المحاولة (${_retryCount + 1}/$_maxRetries)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      height: 200,
      color: Colors.black,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColors.primary),
            SizedBox(height: AppSizes.spaceMedium),
            Text(
              'جاري تحميل الفيديو...',
              style: TextStyle(color: Colors.white),
            ),
          ],
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
            // Video
            Center(
              child: AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!),
              ),
            ),

            // Buffering indicator
            if (_isBuffering)
              const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),

            // Play/Pause button
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
                      Row(
                        children: [
                          Text(
                            _formatDuration(position),
                            style: const TextStyle(color: Colors.white),
                          ),
                          const Text(' / ',
                              style: TextStyle(color: Colors.white70)),
                          Text(
                            _formatDuration(duration),
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(width: AppSizes.spaceSmall),
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
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              final newPosition =
                                  position - const Duration(seconds: 10);
                              _seekTo(newPosition < Duration.zero
                                  ? Duration.zero
                                  : newPosition);
                            },
                            icon: const Icon(Icons.replay_10,
                                color: Colors.white),
                          ),
                          IconButton(
                            onPressed: _togglePlayPause,
                            icon: Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              final newPosition =
                                  position + const Duration(seconds: 10);
                              _seekTo(newPosition > duration
                                  ? duration
                                  : newPosition);
                            },
                            icon: const Icon(Icons.forward_10,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

            // Title
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
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
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
