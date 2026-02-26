import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/authentication/presentation/screens/forgot_password_screen.dart';
import 'package:frontend/features/authentication/presentation/screens/onboarding_screen.dart';
import 'package:frontend/features/authentication/presentation/screens/reset_password_screen.dart';
import 'package:frontend/features/authentication/presentation/screens/splash_screen.dart';
import 'package:frontend/features/authentication/presentation/screens/verification_screen.dart';
import 'package:go_router/go_router.dart';
import '../../features/authentication/presentation/screens/dashboard_screen.dart';
import '../../features/authentication/presentation/screens/login_screen.dart';
import '../../features/authentication/presentation/screens/register_screen.dart';

class AppRouter {
  static final GoRouter routes = GoRouter(
    initialLocation: '/',

    routes: [
      GoRoute(
        path: "/",
        name: "splash",
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: "/onboarding",
        name: "onboarding",
        builder: (context, state) => OnboardingScreen(),
      ),
      GoRoute(
        path: "/login",
        name: "login",
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: "/register",
        name: "register",
        builder: (context, state) => RegisterScreen(),
      ),
      GoRoute(
        path: "/forgot-password",
        name: "forgot-password",
        builder: (context, state) => ForgotPasswordScreen(),
      ),
      GoRoute(
        path: "/forgot-password-verification",
        name: "forgot-password-verification",
        builder: (context, state) {
          final email = state.extra as String;
          return ForgotPasswordVerificationScreen(email: email,);
        },
      ),
      GoRoute(
        path: "/reset-password",
        name: "reset-password",
        builder: (context, state) {
          final email = state.extra as String;
          return ResetPasswordScreen(email: email,);
        },
      ),
      GoRoute(
        path: "/dashboard",
        name: "dashboard",
        builder: (context, state) => DashboardScreen(),
      ),
    ],
  );
}
