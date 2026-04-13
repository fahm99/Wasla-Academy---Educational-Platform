import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/user_model.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../../../core/services/local_storage_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final SignOutUseCase signOutUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final LocalStorageService localStorageService;

  AuthBloc({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.signOutUseCase,
    required this.resetPasswordUseCase,
    required this.getCurrentUserUseCase,
    required this.localStorageService,
  }) : super(AuthInitial()) {
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
    on<LoadCurrentUser>(_onLoadCurrentUser);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  Future<void> _onSignInRequested(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await signInUseCase(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) async {
        // حفظ المستخدم محلياً
        await localStorageService.saveUser(user);
        emit(Authenticated(user: user));
      },
    );
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await signUpUseCase(
      email: event.email,
      password: event.password,
      name: event.name,
      phone: event.phone,
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) async {
        // حفظ المستخدم محلياً
        await localStorageService.saveUser(user);
        emit(Authenticated(user: user));
      },
    );
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await signOutUseCase();

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) async {
        // حذف البيانات المحلية
        await localStorageService.clearUser();
        emit(Unauthenticated());
      },
    );
  }

  Future<void> _onResetPasswordRequested(
    ResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await resetPasswordUseCase(email: event.email);

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(PasswordResetSent(email: event.email)),
    );
  }

  Future<void> _onLoadCurrentUser(
    LoadCurrentUser event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    // محاولة جلب المستخدم من التخزين المحلي أولاً
    final localUser = await localStorageService.getUser();

    if (localUser != null) {
      // عرض المستخدم المحلي فوراً
      emit(Authenticated(user: localUser));
      return; // إنهاء الدالة هنا لتسريع العملية
    }

    // لا يوجد مستخدم محلي، التحقق من Supabase
    final result = await getCurrentUserUseCase();
    await result.fold(
      (failure) async {
        if (!emit.isDone) emit(Unauthenticated());
      },
      (user) async {
        if (user != null && !emit.isDone) {
          await localStorageService.saveUser(user);
          emit(Authenticated(user: user));
        } else if (!emit.isDone) {
          emit(Unauthenticated());
        }
      },
    );
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    final result = await getCurrentUserUseCase();

    await result.fold(
      (failure) async {
        if (!emit.isDone) emit(Unauthenticated());
      },
      (user) async {
        if (user != null && !emit.isDone) {
          await localStorageService.saveUser(user);
          emit(Authenticated(user: user));
        } else if (!emit.isDone) {
          await localStorageService.clearUser();
          emit(Unauthenticated());
        }
      },
    );
  }
}
