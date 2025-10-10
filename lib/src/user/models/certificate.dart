import 'package:equatable/equatable.dart';

class Certificate extends Equatable {
  final String id;
  final String courseId;
  final String courseName;
  final String studentName;
  final String studentId;
  final DateTime issueDate;
  final String certificateUrl;
  final String? thumbnailUrl;
  final String? instructorName;
  final String? institutionName;
  final double? grade;
  final String? gradeLevel; // ممتاز، جيد جداً، جيد، مقبول
  final Map<String, dynamic>? metadata;

  const Certificate({
    required this.id,
    required this.courseId,
    required this.courseName,
    required this.studentName,
    required this.studentId,
    required this.issueDate,
    required this.certificateUrl,
    this.thumbnailUrl,
    this.instructorName,
    this.institutionName,
    this.grade,
    this.gradeLevel,
    this.metadata,
  });

  /// Create a copy with updated fields
  Certificate copyWith({
    String? id,
    String? courseId,
    String? courseName,
    String? studentName,
    String? studentId,
    DateTime? issueDate,
    String? certificateUrl,
    String? thumbnailUrl,
    String? instructorName,
    String? institutionName,
    double? grade,
    String? gradeLevel,
    Map<String, dynamic>? metadata,
  }) {
    return Certificate(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      courseName: courseName ?? this.courseName,
      studentName: studentName ?? this.studentName,
      studentId: studentId ?? this.studentId,
      issueDate: issueDate ?? this.issueDate,
      certificateUrl: certificateUrl ?? this.certificateUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      instructorName: instructorName ?? this.instructorName,
      institutionName: institutionName ?? this.institutionName,
      grade: grade ?? this.grade,
      gradeLevel: gradeLevel ?? this.gradeLevel,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Create from JSON
  factory Certificate.fromJson(Map<String, dynamic> json) {
    return Certificate(
      id: json['id'] as String,
      courseId: json['courseId'] as String,
      courseName: json['courseName'] as String,
      studentName: json['studentName'] as String,
      studentId: json['studentId'] as String,
      issueDate: DateTime.parse(json['issueDate'] as String),
      certificateUrl: json['certificateUrl'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      instructorName: json['instructorName'] as String?,
      institutionName: json['institutionName'] as String?,
      grade: json['grade'] as double?,
      gradeLevel: json['gradeLevel'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseId': courseId,
      'courseName': courseName,
      'studentName': studentName,
      'studentId': studentId,
      'issueDate': issueDate.toIso8601String(),
      'certificateUrl': certificateUrl,
      'thumbnailUrl': thumbnailUrl,
      'instructorName': instructorName,
      'institutionName': institutionName,
      'grade': grade,
      'gradeLevel': gradeLevel,
      'metadata': metadata,
    };
  }

  /// Get formatted issue date
  String getFormattedIssueDate() {
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

    return '${issueDate.day} ${months[issueDate.month - 1]} ${issueDate.year}';
  }

  /// Get certificate number (formatted ID)
  String getCertificateNumber() {
    return 'CERT-${id.toUpperCase()}';
  }

  /// Get grade display text
  String? getGradeDisplayText() {
    if (gradeLevel != null) {
      return gradeLevel;
    }

    if (grade != null) {
      if (grade! >= 90) {
        return 'ممتاز';
      } else if (grade! >= 80) {
        return 'جيد جداً';
      } else if (grade! >= 70) {
        return 'جيد';
      } else if (grade! >= 60) {
        return 'مقبول';
      } else {
        return 'ضعيف';
      }
    }

    return null;
  }

  /// Check if certificate is recent (issued within last 30 days)
  bool get isRecent {
    final now = DateTime.now();
    final difference = now.difference(issueDate);
    return difference.inDays <= 30;
  }

  /// Get certificate validity period (if applicable)
  DateTime? getExpiryDate() {
    // Some certificates might have expiry dates
    // This can be customized based on course type or institution requirements
    if (metadata != null && metadata!.containsKey('validityYears')) {
      final validityYears = metadata!['validityYears'] as int;
      return issueDate.add(Duration(days: validityYears * 365));
    }
    return null; // Most certificates don't expire
  }

  /// Check if certificate is still valid
  bool get isValid {
    final expiryDate = getExpiryDate();
    if (expiryDate == null) return true; // No expiry date means always valid
    return DateTime.now().isBefore(expiryDate);
  }

  /// Generate share text for social media
  String generateShareText() {
    return 'حصلت على شهادة إتمام في "$courseName" من أكاديمية وصلة! 🎓\n'
        'تاريخ الإصدار: ${getFormattedIssueDate()}\n'
        '${getGradeDisplayText() != null ? "التقدير: ${getGradeDisplayText()}\n" : ""}'
        '#وصلة_أكاديمي #تعلم_عبر_الإنترنت #شهادة';
  }

  /// Download certificate (placeholder for actual implementation)
  Future<bool> download() async {
    // This would typically involve:
    // 1. Downloading the certificate file from certificateUrl
    // 2. Saving it to device storage
    // 3. Showing success/error message
    // Implementation depends on platform and file handling requirements

    try {
      // Placeholder implementation
      await Future.delayed(const Duration(seconds: 2));
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Share certificate (placeholder for actual implementation)
  Future<bool> share() async {
    // This would typically involve:
    // 1. Using platform-specific sharing APIs
    // 2. Sharing the certificate URL or file
    // 3. Including share text

    try {
      // Placeholder implementation
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Verify certificate authenticity (placeholder)
  Future<bool> verify() async {
    // This would typically involve:
    // 1. Checking certificate against blockchain or verification service
    // 2. Validating digital signatures
    // 3. Confirming with issuing institution

    try {
      // Placeholder implementation
      await Future.delayed(const Duration(seconds: 3));
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  List<Object?> get props => [
        id,
        courseId,
        courseName,
        studentName,
        studentId,
        issueDate,
        certificateUrl,
        thumbnailUrl,
        instructorName,
        institutionName,
        grade,
        gradeLevel,
        metadata,
      ];

  @override
  String toString() {
    return 'Certificate(id: $id, courseName: $courseName, studentName: $studentName, issueDate: $issueDate)';
  }
}

/// Extension for list of certificates
extension CertificateListExtension on List<Certificate> {
  /// Get recent certificates (within last 30 days)
  List<Certificate> get recent => where((cert) => cert.isRecent).toList();

  /// Get valid certificates
  List<Certificate> get valid => where((cert) => cert.isValid).toList();

  /// Group certificates by year
  Map<int, List<Certificate>> groupByYear() {
    final Map<int, List<Certificate>> grouped = {};

    for (final certificate in this) {
      final year = certificate.issueDate.year;
      grouped[year] = grouped[year] ?? [];
      grouped[year]!.add(certificate);
    }

    return grouped;
  }

  /// Sort by issue date (newest first)
  List<Certificate> sortByIssueDate() {
    final sorted = List<Certificate>.from(this);
    sorted.sort((a, b) => b.issueDate.compareTo(a.issueDate));
    return sorted;
  }

  /// Filter by course name
  List<Certificate> filterByCourse(String courseName) {
    return where((cert) =>
            cert.courseName.toLowerCase().contains(courseName.toLowerCase()))
        .toList();
  }

  /// Get certificates with high grades (>= 80)
  List<Certificate> get highGrades =>
      where((cert) => cert.grade != null && cert.grade! >= 80).toList();
}
