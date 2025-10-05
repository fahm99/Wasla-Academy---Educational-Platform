import 'package:equatable/equatable.dart';

enum LectureStatus {
  scheduled,
  live,
  ended,
  cancelled,
}

class LiveLecture extends Equatable {
  final String id;
  final String title;
  final String description;
  final String instructorName;
  final String instructorId;
  final String? instructorImage;
  final DateTime startTime;
  final DateTime? endTime;
  final int estimatedDuration; // in minutes
  final String? thumbnailUrl;
  final String? streamUrl;
  final int viewerCount;
  final int maxViewers;
  final LectureStatus status;
  final bool isRecorded;
  final String? recordingUrl;
  final List<String> tags;
  final String? courseId;
  final String? courseName;
  final bool requiresRegistration;
  final double? price;
  final Map<String, dynamic>? metadata;

  const LiveLecture({
    required this.id,
    required this.title,
    required this.description,
    required this.instructorName,
    required this.instructorId,
    this.instructorImage,
    required this.startTime,
    this.endTime,
    required this.estimatedDuration,
    this.thumbnailUrl,
    this.streamUrl,
    this.viewerCount = 0,
    this.maxViewers = 1000,
    this.status = LectureStatus.scheduled,
    this.isRecorded = false,
    this.recordingUrl,
    this.tags = const [],
    this.courseId,
    this.courseName,
    this.requiresRegistration = false,
    this.price,
    this.metadata,
  });

  /// Create a copy with updated fields
  LiveLecture copyWith({
    String? id,
    String? title,
    String? description,
    String? instructorName,
    String? instructorId,
    String? instructorImage,
    DateTime? startTime,
    DateTime? endTime,
    int? estimatedDuration,
    String? thumbnailUrl,
    String? streamUrl,
    int? viewerCount,
    int? maxViewers,
    LectureStatus? status,
    bool? isRecorded,
    String? recordingUrl,
    List<String>? tags,
    String? courseId,
    String? courseName,
    bool? requiresRegistration,
    double? price,
    Map<String, dynamic>? metadata,
  }) {
    return LiveLecture(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      instructorName: instructorName ?? this.instructorName,
      instructorId: instructorId ?? this.instructorId,
      instructorImage: instructorImage ?? this.instructorImage,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      streamUrl: streamUrl ?? this.streamUrl,
      viewerCount: viewerCount ?? this.viewerCount,
      maxViewers: maxViewers ?? this.maxViewers,
      status: status ?? this.status,
      isRecorded: isRecorded ?? this.isRecorded,
      recordingUrl: recordingUrl ?? this.recordingUrl,
      tags: tags ?? this.tags,
      courseId: courseId ?? this.courseId,
      courseName: courseName ?? this.courseName,
      requiresRegistration: requiresRegistration ?? this.requiresRegistration,
      price: price ?? this.price,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Create from JSON
  factory LiveLecture.fromJson(Map<String, dynamic> json) {
    return LiveLecture(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      instructorName: json['instructorName'] as String,
      instructorId: json['instructorId'] as String,
      instructorImage: json['instructorImage'] as String?,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'] as String)
          : null,
      estimatedDuration: json['estimatedDuration'] as int,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      streamUrl: json['streamUrl'] as String?,
      viewerCount: json['viewerCount'] as int? ?? 0,
      maxViewers: json['maxViewers'] as int? ?? 1000,
      status: LectureStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => LectureStatus.scheduled,
      ),
      isRecorded: json['isRecorded'] as bool? ?? false,
      recordingUrl: json['recordingUrl'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      courseId: json['courseId'] as String?,
      courseName: json['courseName'] as String?,
      requiresRegistration: json['requiresRegistration'] as bool? ?? false,
      price: json['price'] as double?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'instructorName': instructorName,
      'instructorId': instructorId,
      'instructorImage': instructorImage,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'estimatedDuration': estimatedDuration,
      'thumbnailUrl': thumbnailUrl,
      'streamUrl': streamUrl,
      'viewerCount': viewerCount,
      'maxViewers': maxViewers,
      'status': status.toString().split('.').last,
      'isRecorded': isRecorded,
      'recordingUrl': recordingUrl,
      'tags': tags,
      'courseId': courseId,
      'courseName': courseName,
      'requiresRegistration': requiresRegistration,
      'price': price,
      'metadata': metadata,
    };
  }

  /// Check if lecture is currently live
  bool get isLive => status == LectureStatus.live;

  /// Check if lecture is starting soon (within next 15 minutes)
  bool isStartingSoon() {
    if (status != LectureStatus.scheduled) return false;

    final now = DateTime.now();
    final difference = startTime.difference(now);
    return difference.inMinutes <= 15 && difference.inMinutes >= 0;
  }

  /// Get time until start
  Duration? getTimeUntilStart() {
    if (status != LectureStatus.scheduled) return null;

    final now = DateTime.now();
    final difference = startTime.difference(now);
    return difference.isNegative ? null : difference;
  }

  /// Get formatted start time
  String getFormattedStartTime() {
    final hour = startTime.hour;
    final minute = startTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'م' : 'ص';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

    return '$displayHour:$minute $period';
  }

  /// Get formatted date
  String getFormattedDate() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lectureDate =
        DateTime(startTime.year, startTime.month, startTime.day);

    if (lectureDate == today) {
      return 'اليوم';
    } else if (lectureDate == today.add(const Duration(days: 1))) {
      return 'غداً';
    } else {
      final months = [
        'يناير',
        'فبراير',
        'مارس',
        'أبريل',
        'مايو',
        'يونيو',
        'يوليو',
        'أغسطس',
        'سبتمبر',
        'أكتوبر',
        'نوفمبر',
        'ديسمبر'
      ];
      return '${startTime.day} ${months[startTime.month - 1]}';
    }
  }

  /// Get countdown text
  String getCountdownText() {
    final timeUntil = getTimeUntilStart();
    if (timeUntil == null) return '';

    if (timeUntil.inDays > 0) {
      return 'خلال ${timeUntil.inDays} يوم';
    } else if (timeUntil.inHours > 0) {
      return 'خلال ${timeUntil.inHours} ساعة';
    } else if (timeUntil.inMinutes > 0) {
      return 'خلال ${timeUntil.inMinutes} دقيقة';
    } else {
      return 'يبدأ الآن';
    }
  }

  /// Get estimated end time
  DateTime getEstimatedEndTime() {
    return startTime.add(Duration(minutes: estimatedDuration));
  }

  /// Get duration text
  String getDurationText() {
    if (estimatedDuration < 60) {
      return '$estimatedDuration دقيقة';
    } else {
      final hours = estimatedDuration ~/ 60;
      final minutes = estimatedDuration % 60;
      if (minutes == 0) {
        return '$hours ساعة';
      } else {
        return '$hours ساعة و $minutes دقيقة';
      }
    }
  }

  /// Get status display text
  String getStatusDisplayText() {
    switch (status) {
      case LectureStatus.scheduled:
        return 'مجدولة';
      case LectureStatus.live:
        return 'مباشر الآن';
      case LectureStatus.ended:
        return 'انتهت';
      case LectureStatus.cancelled:
        return 'ملغية';
    }
  }

  /// Check if lecture is free
  bool get isFree => price == null || price == 0;

  /// Get price text
  String getPriceText() {
    if (isFree) return 'مجاني';
    return '${price!.toStringAsFixed(0)} ر.س';
  }

  /// Check if viewer capacity is full
  bool get isCapacityFull => viewerCount >= maxViewers;

  /// Get capacity percentage
  double get capacityPercentage => viewerCount / maxViewers;

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        instructorName,
        instructorId,
        instructorImage,
        startTime,
        endTime,
        estimatedDuration,
        thumbnailUrl,
        streamUrl,
        viewerCount,
        maxViewers,
        status,
        isRecorded,
        recordingUrl,
        tags,
        courseId,
        courseName,
        requiresRegistration,
        price,
        metadata,
      ];

  @override
  String toString() {
    return 'LiveLecture(id: $id, title: $title, instructor: $instructorName, startTime: $startTime, status: $status)';
  }
}

/// Extension for list of live lectures
extension LiveLectureListExtension on List<LiveLecture> {
  /// Get currently live lectures
  List<LiveLecture> get live => where((lecture) => lecture.isLive).toList();

  /// Get scheduled lectures
  List<LiveLecture> get scheduled =>
      where((lecture) => lecture.status == LectureStatus.scheduled).toList();

  /// Get lectures starting soon
  List<LiveLecture> get startingSoon =>
      where((lecture) => lecture.isStartingSoon()).toList();

  /// Get ended lectures
  List<LiveLecture> get ended =>
      where((lecture) => lecture.status == LectureStatus.ended).toList();

  /// Get free lectures
  List<LiveLecture> get free => where((lecture) => lecture.isFree).toList();

  /// Sort by start time (earliest first)
  List<LiveLecture> sortByStartTime() {
    final sorted = List<LiveLecture>.from(this);
    sorted.sort((a, b) => a.startTime.compareTo(b.startTime));
    return sorted;
  }

  /// Filter by instructor
  List<LiveLecture> filterByInstructor(String instructorId) {
    return where((lecture) => lecture.instructorId == instructorId).toList();
  }

  /// Filter by course
  List<LiveLecture> filterByCourse(String courseId) {
    return where((lecture) => lecture.courseId == courseId).toList();
  }

  /// Filter by tags
  List<LiveLecture> filterByTags(List<String> tags) {
    return where((lecture) => tags.any((tag) => lecture.tags.contains(tag)))
        .toList();
  }

  /// Group by date
  Map<String, List<LiveLecture>> groupByDate() {
    final Map<String, List<LiveLecture>> grouped = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (final lecture in this) {
      final lectureDate = DateTime(
        lecture.startTime.year,
        lecture.startTime.month,
        lecture.startTime.day,
      );

      String dateKey;
      if (lectureDate == today) {
        dateKey = 'اليوم';
      } else if (lectureDate == today.add(const Duration(days: 1))) {
        dateKey = 'غداً';
      } else if (lectureDate.isBefore(today)) {
        dateKey = 'السابقة';
      } else {
        dateKey = lecture.getFormattedDate();
      }

      grouped[dateKey] = grouped[dateKey] ?? [];
      grouped[dateKey]!.add(lecture);
    }

    return grouped;
  }
}
