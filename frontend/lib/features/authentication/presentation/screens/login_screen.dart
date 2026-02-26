import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/utils/app_messenger.dart';
import 'package:frontend/core/utils/app_validators.dart';
import 'package:frontend/core/widgets/custom_button.dart' show CustomElevatedButton;
import 'package:frontend/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:frontend/features/authentication/presentation/bloc/auth_event.dart';
import 'package:frontend/features/authentication/presentation/bloc/auth_state.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isObscure = false;
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }


  void _handleRegisterNowTap() {
    context.read<AuthBloc>().add(AuthReset());
    context.goNamed("register");
    print('Register Now tapped');
  }

  Future<void> loginUser() async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginRequested(
          emailId: emailController.text.trim(),
          password: passwordController.text.trim(),
        ),
      );
    }
    print("login success");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.status == Status.loaded && state.isAuthenticated) {
              AppMessenger.success(state.successMessage);
              context.goNamed("dashboard");
            } else if (state.status == Status.error) {
              AppMessenger.failure(state.error);

            }
          },
          builder: (context, state) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppConstants.loginHeader,
                            style: Theme.of(context).textTheme.headlineLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            AppConstants.loginSubHeader,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge!.copyWith(),
                          ),
                          SizedBox(height: 40),
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                  validator: AppValidators.emailValidator,
                                ),
                                SizedBox(height: 15),
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
                                GestureDetector(
                                  onTap: (){
                                    context.push("/forgot-password");
                                    print("forgot password tapped");
                                  },
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      "Forgot Password?",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),

                                CustomElevatedButton(
                                  onPressed: state.status == Status.loading
                                      ? null
                                      : loginUser,
                                  text: "Login",
                                  isLoading: state.status == Status.loading,
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodyLarge,
                          children: [
                            TextSpan(
                              text: "${AppConstants.doNotHaveAccountText} ",
                            ),
                            TextSpan(
                              text: "Register Now",
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  _handleRegisterNowTap();
                                },
                              style: Theme.of(context).textTheme.bodyLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
