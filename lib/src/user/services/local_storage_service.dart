import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waslaacademy/src/user/models/user.dart';

class LocalStorageService {
  static LocalStorageService? _instance;
  static late SharedPreferences _prefs;

  static const String _userKey = 'user_data';
  static const String _enrolledCoursesKey = 'enrolled_courses';
  static const String _completedCoursesKey = 'completed_courses';
  static const String _themeModeKey = 'theme_mode';

  LocalStorageService._();

  static Future<LocalStorageService> getInstance() async {
    _instance ??= LocalStorageService._();
    _prefs = await SharedPreferences.getInstance();
    return _instance!;
  }

  // Save user data
  Future<void> saveUser(User user) async {
    final userMap = {
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'password': user.password,
      'phone': user.phone,
      'avatar': user.avatar,
    };

    await _prefs.setString(_userKey, jsonEncode(userMap));
    await saveEnrolledCourses(user.enrolledCourses);
    await saveCompletedCourses(user.completedCourses);
    await saveCertificates(user.certificates);
    await saveExams(user.exams);
  }

  // Get user data
  Future<User?> getUser() async {
    final userString = _prefs.getString(_userKey);
    if (userString == null) return null;

    try {
      final userMap = jsonDecode(userString);
      final enrolledCourses = await getEnrolledCourses();
      final completedCourses = await getCompletedCourses();
      final certificates = await getCertificates();
      final exams = await getExams();

      return User(
        id: userMap['id'],
        name: userMap['name'],
        email: userMap['email'],
        password: userMap['password'],
        phone: userMap['phone'],
        avatar: userMap['avatar'],
        enrolledCourses: enrolledCourses,
        completedCourses: completedCourses,
        certificates: certificates,
        exams: exams,
      );
    } catch (e) {
      return null;
    }
  }

  // Save enrolled courses
  Future<void> saveEnrolledCourses(List<int> courseIds) async {
    await _prefs.setStringList(
        _enrolledCoursesKey, courseIds.map((id) => id.toString()).toList());
  }

  // Get enrolled courses
  Future<List<int>> getEnrolledCourses() async {
    final courseIds = _prefs.getStringList(_enrolledCoursesKey) ?? [];
    return courseIds.map((id) => int.parse(id)).toList();
  }

  // Save completed courses
  Future<void> saveCompletedCourses(List<int> courseIds) async {
    await _prefs.setStringList(
        _completedCoursesKey, courseIds.map((id) => id.toString()).toList());
  }

  // Get completed courses
  Future<List<int>> getCompletedCourses() async {
    final courseIds = _prefs.getStringList(_completedCoursesKey) ?? [];
    return courseIds.map((id) => int.parse(id)).toList();
  }

  // Save certificates
  Future<void> saveCertificates(List<Certificate> certificates) async {
    final certificatesList = certificates
        .map((cert) => {
              'id': cert.id,
              'courseId': cert.courseId,
              'courseName': cert.courseName,
              'date': cert.date,
            })
        .toList();
    await _prefs.setString('certificates', jsonEncode(certificatesList));
  }

  // Get certificates
  Future<List<Certificate>> getCertificates() async {
    final certificatesString = _prefs.getString('certificates');
    if (certificatesString == null) return [];

    try {
      final certificatesList = jsonDecode(certificatesString);
      return certificatesList
          .map<Certificate>((certMap) => Certificate(
                id: certMap['id'],
                courseId: certMap['courseId'],
                courseName: certMap['courseName'],
                date: certMap['date'],
              ))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Save exams
  Future<void> saveExams(List<UserExam> exams) async {
    final examsList = exams
        .map((exam) => {
              'id': exam.id,
              'courseId': exam.courseId,
              'examId': exam.examId,
              'title': exam.title,
              'date': exam.date,
              'score': exam.score,
              'status': exam.status,
            })
        .toList();
    await _prefs.setString('exams', jsonEncode(examsList));
  }

  // Get exams
  Future<List<UserExam>> getExams() async {
    final examsString = _prefs.getString('exams');
    if (examsString == null) return [];

    try {
      final examsList = jsonDecode(examsString);
      return examsList
          .map<UserExam>((examMap) => UserExam(
                id: examMap['id'],
                courseId: examMap['courseId'],
                examId: examMap['examId'],
                title: examMap['title'],
                date: examMap['date'],
                score: examMap['score'],
                status: examMap['status'],
              ))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Save theme mode
  Future<void> saveThemeMode(String themeMode) async {
    await _prefs.setString(_themeModeKey, themeMode);
  }

  // Get theme mode
  Future<String> getThemeMode() async {
    return _prefs.getString(_themeModeKey) ?? 'system';
  }

  // Clear all data
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
