import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class ResendOtpState extends Equatable {
  final int timeLeft;
  final bool canResend;

  const ResendOtpState({required this.timeLeft, required this.canResend});

  @override
  List<Object?> get props => [timeLeft, canResend];
}

class ResendOtpCubit extends Cubit<ResendOtpState> {
  ResendOtpCubit() : super(const ResendOtpState(timeLeft: 120, canResend: false)) {
    startTimer();
  }

  Timer? _timer;

  void startTimer() {
    _timer?.cancel();
    emit(const ResendOtpState(timeLeft: 120, canResend: false));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timeLeft > 0) {
        emit(ResendOtpState(timeLeft: state.timeLeft - 1, canResend: false));
      } else {
        emit(const ResendOtpState(timeLeft: 0, canResend: true));
        _timer?.cancel();
      }
    });
  }

  void resetTimer() {
    startTimer();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}