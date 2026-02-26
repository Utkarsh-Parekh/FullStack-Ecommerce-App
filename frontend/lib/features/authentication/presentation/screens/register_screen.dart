import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/utils/app_validators.dart';
import 'package:frontend/core/widgets/custom_button.dart';
import 'package:frontend/core/widgets/custom_textfield.dart';
import 'package:frontend/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:frontend/features/authentication/presentation/bloc/auth_event.dart';
import 'package:frontend/features/authentication/presentation/bloc/auth_state.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/app_messenger.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isObscure = false;
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _nameFocus = FocusNode();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    _nameFocus.dispose();
    _passwordFocus.dispose();
    _emailFocus.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }



  void _handleRegisterNowTap() {
    context.read<AuthBloc>().add(AuthReset());
    context.goNamed("login");
    print('Register Now tapped');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.status == Status.loaded && state.isAuthenticated) {
              AppMessenger.success(state.successMessage);
              context.goNamed("login");
            } else if (state.status == Status.error) {
              AppMessenger.failure(state.error);

            }
          },
          builder: (context, state) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppConstants.registerHeader,
                            style: Theme.of(context).textTheme.headlineLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            AppConstants.registerSubHeader,
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
                                  "Full Name",
                                  style: Theme.of(context).textTheme.bodyLarge!
                                      .copyWith(fontWeight: FontWeight.w500),
                                ),
                                CustomTextField(
                                  controller: nameController,
                                  textInputType: TextInputType.text,
                                  hintText: AppConstants.nameHintText,
                                  prefixIcon: Icon(Icons.person),
                                  validator: AppValidators.nameValidator,
                                  focusNode: _nameFocus,
                                ),
                                SizedBox(height: 15),
                                Text(
                                  "Email",
                                  style: Theme.of(context).textTheme.bodyLarge!
                                      .copyWith(fontWeight: FontWeight.w500),
                                ),
                                CustomTextField(
                                  controller: emailController,
                                  textInputType: TextInputType.emailAddress,
                                  hintText: AppConstants.emailHintText,
                                  prefixIcon: Icon(Icons.email),
                                  validator: AppValidators.emailValidator,
                                  focusNode: _emailFocus,
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
                                  focusNode: _passwordFocus,
                                  validator: AppValidators.passwordValidator,
                                ),
                                SizedBox(height: 20),
                                CustomElevatedButton(
                                  onPressed: state.status == Status.loading
                                      ? null
                                      : () {
                                          FocusScope.of(context).unfocus();
                                          if (_formKey.currentState!
                                              .validate()) {
                                            context.read<AuthBloc>().add(
                                                  RegisterRequested(
                                                    username: nameController
                                                        .text
                                                        .trim(),
                                                    emailId: emailController.text
                                                        .trim(),
                                                    password: passwordController
                                                        .text
                                                        .trim(),
                                                  ),
                                                );
                                          }
                                        },
                                  text: "Create an Account",
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
                              text: "${AppConstants.alreadyHaveAccountText} ",
                            ),
                            TextSpan(
                              text: "Log In",
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
