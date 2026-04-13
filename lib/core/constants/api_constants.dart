/// ثوابت API
class ApiConstants {
  // Table Names
  static const String usersTable = 'users';
  static const String coursesTable = 'courses';
  static const String modulesTable = 'modules';
  static const String lessonsTable = 'lessons';
  static const String lessonResourcesTable = 'lesson_resources';
  static const String enrollmentsTable = 'enrollments';
  static const String lessonProgressTable = 'lesson_progress';
  static const String examsTable = 'exams';
  static const String examQuestionsTable = 'exam_questions';
  static const String examResultsTable = 'exam_results';
  static const String certificatesTable = 'certificates';
  static const String paymentsTable = 'payments';
  static const String providerPaymentSettingsTable =
      'provider_payment_settings';
  static const String notificationsTable = 'notifications';
  static const String reviewsTable = 'reviews';
  static const String appSettingsTable = 'app_settings';

  // User Types
  static const String userTypeStudent = 'student';
  static const String userTypeProvider = 'provider';
  static const String userTypeAdmin = 'admin';

  // Course Status
  static const String courseStatusDraft = 'draft';
  static const String courseStatusPublished = 'published';
  static const String courseStatusArchived = 'archived';
  static const String courseStatusPendingReview = 'pending_review';

  // Course Levels
  static const String levelBeginner = 'beginner';
  static const String levelIntermediate = 'intermediate';
  static const String levelAdvanced = 'advanced';

  // Lesson Types
  static const String lessonTypeVideo = 'video';
  static const String lessonTypeText = 'text';
  static const String lessonTypeFile = 'file';
  static const String lessonTypeQuiz = 'quiz';

  // Enrollment Status
  static const String enrollmentStatusActive = 'active';
  static const String enrollmentStatusCompleted = 'completed';
  static const String enrollmentStatusDropped = 'dropped';

  // Payment Status
  static const String paymentStatusPending = 'pending';
  static const String paymentStatusCompleted = 'completed';
  static const String paymentStatusFailed = 'failed';
  static const String paymentStatusRefunded = 'refunded';
  static const String paymentStatusRejected = 'rejected';

  // Payment Methods
  static const String paymentMethodBankTransfer = 'bank_transfer';
  static const String paymentMethodLocalTransfer = 'local_transfer';
  static const String paymentMethodCreditCard = 'credit_card';
  static const String paymentMethodApplePay = 'apple_pay';
  static const String paymentMethodGooglePay = 'google_pay';

  // Exam Status
  static const String examStatusDraft = 'draft';
  static const String examStatusPublished = 'published';

  // Question Types
  static const String questionTypeMultipleChoice = 'multiple_choice';
  static const String questionTypeTrueFalse = 'true_false';
  static const String questionTypeEssay = 'essay';
  static const String questionTypeShortAnswer = 'short_answer';

  // Certificate Status
  static const String certificateStatusIssued = 'issued';
  static const String certificateStatusRevoked = 'revoked';

  // Notification Types
  static const String notificationTypeCourse = 'course';
  static const String notificationTypeExam = 'exam';
  static const String notificationTypeCertificate = 'certificate';
  static const String notificationTypePayment = 'payment';
  static const String notificationTypeSystem = 'system';

  // File Types
  static const String fileTypePdf = 'pdf';
  static const String fileTypeDoc = 'doc';
  static const String fileTypeImage = 'image';
  static const String fileTypeZip = 'zip';
  static const String fileTypeOther = 'other';

  // Theme Modes
  static const String themeLight = 'light';
  static const String themeDark = 'dark';

  // Languages
  static const String languageAr = 'ar';
  static const String languageEn = 'en';
}
