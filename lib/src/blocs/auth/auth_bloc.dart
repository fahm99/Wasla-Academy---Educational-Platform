import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:waslaacademy/src/models/user.dart';
import 'package:waslaacademy/src/data/test_users.dart';
import 'package:waslaacademy/src/services/local_storage_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<UpdateUserProgress>(_onUpdateUserProgress);
    on<LoadUserFromStorage>(_onLoadUserFromStorage);
  }

  void _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // التحقق من بيانات المستخدم التجريبي
      if (TestUsers.verifyPassword(event.email, event.password)) {
        final userData = TestUsers.getUserByEmail(event.email)!;

        final user = User(
          id: userData['id'],
          name: userData['name'],
          email: userData['email'],
          password: userData['password'],
          phone: userData['phone'],
          avatar: userData['avatar'],
          enrolledCourses: List<int>.from(userData['enrolledCourses']),
          completedCourses: List<int>.from(userData['completedCourses']),
          certificates: const [
            Certificate(
              id: 1,
              courseId: 1,
              courseName: "مقدمة في برمجة بايثون",
              date: "01/01/2023",
            )
          ],
          exams: const [
            UserExam(
              id: 1,
              courseId: 1,
              examId: 1,
              title: "امتحان الفصل الأول",
              date: "15/01/2023",
              score: 85,
              status: "completed",
            )
          ],
        );

        // Save user to local storage
        final localStorage = await LocalStorageService.getInstance();
        await localStorage.saveUser(user);

        emit(AuthSuccess(user: user));
      } else {
        emit(const AuthFailure(
            message: "البريد الإلكتروني أو كلمة المرور غير صحيحة"));
      }
    } catch (e) {
      emit(const AuthFailure(message: "فشل في تسجيل الدخول"));
    }
  }

  void _onRegisterRequested(
      RegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // إنشاء مستخدم جديد باستخدام البيانات التجريبية
      final userData = TestUsers.createUser(
        name: event.name,
        email: event.email,
        phone: event.phone,
        password: event.password,
      );

      final user = User(
        id: userData['id'],
        name: userData['name'],
        email: userData['email'],
        password: userData['password'],
        phone: userData['phone'],
        avatar: userData['avatar'],
        enrolledCourses: List<int>.from(userData['enrolledCourses']),
        completedCourses: List<int>.from(userData['completedCourses']),
        certificates: const [],
        exams: const [],
      );

      // Save user to local storage
      final localStorage = await LocalStorageService.getInstance();
      await localStorage.saveUser(user);

      emit(AuthSuccess(user: user));
    } catch (e) {
      emit(const AuthFailure(message: "فشل في إنشاء الحساب"));
    }
  }

  void _onLogoutRequested(
      LogoutRequested event, Emitter<AuthState> emit) async {
    // Clear user data from local storage
    final localStorage = await LocalStorageService.getInstance();
    await localStorage.clearAll();

    emit(AuthInitial());
  }

  void _onUpdateUserProgress(
      UpdateUserProgress event, Emitter<AuthState> emit) {
    if (state is AuthSuccess) {
      final currentUser = (state as AuthSuccess).user;

      // Update user with new progress
      final updatedUser = currentUser.copyWith(
        enrolledCourses: event.enrolledCourses ?? currentUser.enrolledCourses,
        completedCourses:
            event.completedCourses ?? currentUser.completedCourses,
        certificates: event.certificates ?? currentUser.certificates,
        exams: event.exams ?? currentUser.exams,
      );

      // Save updated user to local storage
      emit(AuthSuccess(user: updatedUser));

      // Save to local storage in the background
      LocalStorageService.getInstance().then((localStorage) {
        localStorage.saveUser(updatedUser);
      });
    }
  }

  void _onLoadUserFromStorage(
      LoadUserFromStorage event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final localStorage = await LocalStorageService.getInstance();
      final user = await localStorage.getUser();

      if (user != null) {
        emit(AuthSuccess(user: user));
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthInitial());
    }
  }
}
