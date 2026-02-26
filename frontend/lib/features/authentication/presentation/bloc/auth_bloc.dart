import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:frontend/core/wrapper/api_exception_wrapper.dart';
import 'package:frontend/features/authentication/data/user_model.dart';
import 'package:frontend/features/authentication/domain/auth_repository.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  AuthBloc(this.authRepository) : super(AuthState()) {
    on<EmailChanged>(_emailChanged);
    on<RegisterRequested>(_registerRequested);
    on<LoginRequested>(_loginRequested);
    on<ForgotPasswordRequested>(_forgotPasswordRequested);
    on<ResendOtpRequested>(_resendOtpRequested);
    on<VerifyOtpRequested>(_verifyOtpRequested);
    on<ResetPasswordRequested>(_resetPasswordRequested);
    on<LogoutRequested>(_logoutRequested);
    on<CheckAuthStatus>(_checkAuthStatus);
    on<AuthReset>(_authReset);
  }

  FutureOr<void> _registerRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final user = await authRepository.register(
        event.username,
        event.emailId,
        event.password,
      );

      emit(
        state.copyWith(
          user: user.data,
          status: Status.loaded,
          successMessage: user.message,
          error: "",
          isAuthenticated: true,
        ),
      );
    } on ApiException catch (e) {
      emit(
        state.copyWith(
          error: e.message,
          status: Status.error,
          successMessage: "",
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          error: e.toString(),
          status: Status.error,
          successMessage: "",
          isAuthenticated: false,
        ),
      );
    }
  }

  FutureOr<void> _loginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));

    try {
      final user = await authRepository.login(event.emailId, event.password);

      emit(
        state.copyWith(
          user: user.data,
          status: Status.loaded,
          successMessage: user.message,
          error: "",
          isAuthenticated: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: Status.error,
          successMessage: "",
          isAuthenticated: false,
          error: e.toString(),
        ),
      );
    }
  }

  FutureOr<void> _authReset(AuthReset event, Emitter<AuthState> emit) {
    emit(AuthState());
  }

  FutureOr<void> _logoutRequested(
      LogoutRequested event,
      Emitter<AuthState> emit,
      ) async {
    try {
      await authRepository.logout();

      emit(state.copyWith(
          status: Status.loaded,
          isAuthenticated: false,
          user: null,
          successMessage: "",
          error: "",
        ));
    } catch (e) {
      emit(state.copyWith(
          status: Status.error,
          isAuthenticated: false,
          user: null,
          error: e.toString(),
        ));
    }
  }

  FutureOr<void> _checkAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));

    try{

      final response = await authRepository.getCurrentUser();
      emit(state.copyWith(
        user: response.data,
        isAuthenticated: response.data!.isLoggedIn,
        status: Status.loaded
      ));
    }
    catch(e){
      emit(state.copyWith(

          isAuthenticated: false,
          status: Status.error
      ));
    }

  }

  FutureOr<void> _forgotPasswordRequested(
    ForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));

    try {
      final response = await authRepository.forgotPassword(event.emailId);
      emit(
        state.copyWith(
          successMessage: response.message,
          status: Status.loaded,
          error: "",
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          successMessage: "",
          error: e.toString(),
          status: Status.error,
        ),
      );
    }
  }

  FutureOr<void> _verifyOtpRequested(
    VerifyOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));

    try {
      final response = await authRepository.verifyOtp(event.email, event.code);
      emit(
        state.copyWith(
          successMessage: response.message,
          status: Status.loaded,
          error: "",
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          successMessage: "",
          error: e.toString(),
          status: Status.error,
        ),
      );
    }
  }

  FutureOr<void> _resetPasswordRequested(
    ResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final response = await authRepository.resetPassword(
        event.email,
        event.password,
        event.confirmPassword,
      );
      emit(
        state.copyWith(
          successMessage: response.message,
          status: Status.loaded,
          error: "",
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          successMessage: "",
          error: e.toString(),
          status: Status.error,
        ),
      );
    }
  }

  FutureOr<void> _resendOtpRequested(
    ResendOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(resendStatus: ResendStatus.sending));

    try {
      final response = await authRepository.resendOtp(event.emailId);
      emit(
        state.copyWith(
          successMessage: response.message,
          resendStatus: ResendStatus.sent,
          error: "",
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          successMessage: "",
          error: e.toString(),
          resendStatus: ResendStatus.error,
        ),
      );
    }
  }

  FutureOr<void> _emailChanged(EmailChanged event, Emitter<AuthState> emit) {
      final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
      final isValid = emailRegex.hasMatch(event.email.trim());
      emit(state.copyWith(isEmailValid: isValid));
  }


}
