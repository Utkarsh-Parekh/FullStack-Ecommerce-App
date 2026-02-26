import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/utils/app_messenger.dart';
import 'package:frontend/core/utils/app_validators.dart';
import 'package:frontend/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:frontend/features/authentication/presentation/bloc/auth_event.dart';
import 'package:frontend/features/authentication/presentation/bloc/auth_state.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_textfield.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool isObscure = false;
  bool isConfirmPasswordObscure = false;
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.status == Status.loaded) {
              AppMessenger.success(state.successMessage);
              context.goNamed("login");
            } else if (state.status == Status.error) {
              AppMessenger.failure(state.error);
            }
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Reset Password",
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Set the new password for your account so you can login and access the features.",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        SizedBox(height: 30),
                        Text(
                          "Password",
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                        CustomTextField(
                          controller: passwordController,
                          hintText: AppConstants.passwordHintText,
                          obscureText: !isObscure,
                          focusNode: _passwordFocus,
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isObscure = !isObscure;
                              });
                            },
                            icon: Icon(
                              isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                          validator: AppValidators.passwordValidator,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Password",
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                        CustomTextField(
                          controller: confirmPasswordController,
                          hintText: AppConstants.confirmPasswordHintText,
                          obscureText: !isConfirmPasswordObscure,
                          focusNode: _confirmPasswordFocus,
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isConfirmPasswordObscure =
                                    !isConfirmPasswordObscure;
                              });
                            },
                            icon: Icon(
                              isConfirmPasswordObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                          validator: AppValidators.passwordValidator,
                        ),
                      ],
                    ),
                  ),
                ),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final isLoading = state.status == Status.loading;
                    return CustomElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              context.read<AuthBloc>().add(
                                    ResetPasswordRequested(
                                      email: widget.email,
                                      password: passwordController.text.trim(),
                                      confirmPassword:
                                          confirmPasswordController.text.trim(),
                                    ),
                                  );
                            },
                      text: "Continue",
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
    );
  }
}
