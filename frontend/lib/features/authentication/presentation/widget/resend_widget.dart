import 'package:flutter/gestures.dart' show TapGestureRecognizer;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocProvider, BlocBuilder, ReadContext;
import 'package:frontend/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:frontend/features/authentication/presentation/bloc/auth_event.dart' show ResendOtpRequested;
import 'package:frontend/features/authentication/presentation/cubit/otp_cubit.dart' show ResendOtpCubit, ResendOtpState;

class ResendWidget extends StatelessWidget {
  final String email;
  const ResendWidget({super.key,required this.email});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ResendOtpCubit(),
      child: BlocBuilder<ResendOtpCubit, ResendOtpState>(
        builder: (context, timerState) {
          final minutes = (timerState.timeLeft ~/ 60).toString().padLeft(2, '0');
          final seconds = (timerState.timeLeft % 60).toString().padLeft(2, '0');

          return Align(
            alignment: Alignment.center,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Email not received? ",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  TextSpan(
                    text: timerState.canResend
                        ? "Resend?"
                        : "Resend in  $minutes:$seconds",
                    recognizer: timerState.canResend
                        ? (TapGestureRecognizer()
                      ..onTap = () {
                        context.read<AuthBloc>().add(
                          ResendOtpRequested(emailId: email),
                        );
                        context.read<ResendOtpCubit>().resetTimer();
                      })
                        : null,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: timerState.canResend
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
