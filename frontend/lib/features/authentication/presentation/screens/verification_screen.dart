import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/utils/app_messenger.dart';
import 'package:frontend/features/authentication/presentation/bloc/auth_state.dart';
import 'package:frontend/features/authentication/presentation/widget/resend_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';

class ForgotPasswordVerificationScreen extends StatefulWidget {
  final String email;
  const ForgotPasswordVerificationScreen({super.key, required this.email});

  @override
  State<ForgotPasswordVerificationScreen> createState() =>
      _ForgotPasswordVerificationScreenState();
}

class _ForgotPasswordVerificationScreenState
    extends State<ForgotPasswordVerificationScreen> {
  final TextEditingController pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listenWhen: (previous, current) =>
          previous.status != current.status ||
              previous.resendStatus != current.resendStatus,
          listener: (context, state) {
            // OTP verification
            if (state.status == Status.loaded) {
              AppMessenger.success(state.successMessage);
              context.go('/reset-password', extra: widget.email);
            } else if (state.status == Status.error) {
              AppMessenger.failure(state.error);
              pinController.clear();
            }

            if (state.resendStatus == ResendStatus.sent && state.successMessage.isNotEmpty) {
              AppMessenger.success(state.successMessage);
            } else if (state.resendStatus == ResendStatus.error && state.error.isNotEmpty) {
              AppMessenger.failure(state.error);

            }
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/logo/security.png",
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
                SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          "Enter 6 Digit Code",
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Enter 6 digit code that you received on your email",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        SizedBox(height: 30),
                        Pinput(
                          length: 6,
                          controller: pinController,
                          keyboardType: TextInputType.number,
                          onCompleted: (pin) {
                            context.read<AuthBloc>().add(
                              VerifyOtpRequested(
                                email: widget.email,
                                code: pin,
                              ),
                            );
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "OTP is required";
                            }
                            if (value.length < 6) {
                              return "Enter complete 6 digit code";
                            }
                            return null;
                          },
                          errorBuilder: (errorText, pin) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                errorText ?? "",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                ),
                              ),
                            );
                          },
                          showCursor: true,
                          cursor: Container(
                            width: 2,
                            height: 20,
                            color: Theme.of(context).primaryColor,
                          ),

                          defaultPinTheme: PinTheme(
                            width: 50,
                            height: 56,
                            textStyle: Theme.of(
                              context,
                            ).textTheme.headlineMedium,
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),

                          focusedPinTheme: PinTheme(
                            width: 50,
                            height: 56,
                            textStyle: Theme.of(
                              context,
                            ).textTheme.headlineMedium,
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        ResendWidget(email: widget.email)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
