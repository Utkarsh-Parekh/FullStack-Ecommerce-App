

abstract class AuthEvent {}


class EmailChanged extends AuthEvent {
  final String email;
  EmailChanged(this.email);
}

class RegisterRequested extends AuthEvent{
  final String username;
  final String emailId;
  final String password;

  RegisterRequested({required this.username, required this.emailId, required this.password});

}

class LoginRequested extends AuthEvent{
  final String emailId;
  final String password;

  LoginRequested({required this.emailId, required this.password});

}

class ForgotPasswordRequested extends AuthEvent{
  final String emailId;
  ForgotPasswordRequested({required this.emailId});
}

class ResendOtpRequested extends AuthEvent{
  final String emailId;
  ResendOtpRequested({required this.emailId});
}

class VerifyOtpRequested extends AuthEvent{
  final String email;
  final String code;
  VerifyOtpRequested({required this.email,required this.code});
}



class ResetPasswordRequested extends AuthEvent{
  final String email;
  final String password;
  final String confirmPassword;
  ResetPasswordRequested({required this.email,required this.password,required this.confirmPassword});

}
class CheckAuthStatus extends AuthEvent{}
class LogoutRequested extends AuthEvent{}
class AuthReset extends AuthEvent{}