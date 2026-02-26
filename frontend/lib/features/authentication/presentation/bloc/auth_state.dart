import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:frontend/features/authentication/data/user_model.dart';

enum Status {
  initial,
  loading,
  loaded,
  error
}

enum ResendStatus {
  initial,
  sending,
  sent,
  error
}


class AuthState extends Equatable {
  final UserModel? user;
  final String error;
  final String successMessage;
  final Status status;
  final bool isAuthenticated;
  final bool isEmailValid;
  final ResendStatus resendStatus;

  const AuthState({
    this.user,
    this.error = "",
    this.successMessage = "",
    this.status = Status.initial,
    this.isAuthenticated = false,
    this.isEmailValid = false,
    this.resendStatus = ResendStatus.initial,
  });

  AuthState copyWith({
    UserModel? user,
    String? error,
    String? successMessage,
    Status? status,
    bool? isAuthenticated,
    bool? isEmailValid,
    ResendStatus? resendStatus,
}){
    return AuthState(user: user ?? this.user,
    error: error ?? this.error,
      successMessage:  successMessage ?? this.successMessage,
      status: status ?? this.status,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      resendStatus: resendStatus ?? this.resendStatus,
      isEmailValid: isEmailValid ?? this.isEmailValid,
    );
  }

  @override
  List<Object?> get props => [
    user,
    successMessage,
    error,
    status,
    isAuthenticated,
    resendStatus,
    isEmailValid,
  ];


}