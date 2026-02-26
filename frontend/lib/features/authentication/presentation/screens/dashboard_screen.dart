import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/widgets/custom_button.dart';
import 'package:frontend/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:frontend/features/authentication/presentation/bloc/auth_event.dart';
import 'package:frontend/features/authentication/presentation/bloc/auth_state.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: BlocConsumer<AuthBloc, AuthState>(
        builder: (context, state) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.user!.emailId),
                Text(state.user!.username),
                Text(state.user!.id),

                CustomElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(LogoutRequested());
                  },
                  text: "Log Out",
                ),
              ],
            ),
          );
        }, listener: (BuildContext context, AuthState state) {
          if(!state.isAuthenticated){
            context.goNamed("login");
          }
      },
      ),
    );
  }
}
