import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/utils/app_validators.dart';
import 'package:frontend/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:frontend/features/authentication/presentation/bloc/auth_event.dart';
import 'package:frontend/features/authentication/presentation/bloc/auth_state.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/app_messenger.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_textfield.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailFocus = FocusNode();
  final TextEditingController emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthReset());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listenWhen: (previous, current) {
            if (previous.status == Status.loading && current.status == Status.loaded) {
              return true;
            }
            if (current.status == Status.error) {
              return true;
            }
            return false;
          },
          listener: (context, state) {
            if (state.status == Status.loaded) {
              AppMessenger.success(state.successMessage);
              context.pushNamed(
                'forgot-password-verification',
                extra: emailController.text.trim(),
              );
            } else if (state.status == Status.error) {
              AppMessenger.failure(state.error);
            }
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            "assets/logo/forgot-password.png",
                            height: MediaQuery.of(context).size.height * 0.4,
                            width: MediaQuery.of(context).size.width,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                          Text(
                            "Forgot Password",
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Enter your email for the verification process.We will send you 6 digits code to your email",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          SizedBox(height: 30),
                          Text(
                            "Email",
                            style: Theme.of(context).textTheme.bodyLarge!
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                          CustomTextField(
                            controller: emailController,
                            focusNode: _emailFocus,
                            textInputType: TextInputType.emailAddress,
                            hintText: AppConstants.emailHintText,
                            prefixIcon: Icon(Icons.email),
                            onChanged: (value) {
                              context.read<AuthBloc>().add(EmailChanged(value));
                            },
                            validator: AppValidators.emailValidator,
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  BlocBuilder<AuthBloc, AuthState>(
                    buildWhen: (previous, current) =>
                        previous.isEmailValid != current.isEmailValid ||
                        previous.status != current.status,
                    builder: (context, state) {
                      final isLoading = state.status == Status.loading;
                      final canSubmit = state.isEmailValid && !isLoading;

                      return CustomElevatedButton(
                        onPressed: canSubmit
                            ? () {
                                context.read<AuthBloc>().add(
                                      ForgotPasswordRequested(
                                        emailId: emailController.text.trim(),
                                      ),
                                    );
                              }
                            : null,
                        text: "Send Code",
                        isLoading: isLoading,
                        backgroundColor: Theme.of(context).primaryColor,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
