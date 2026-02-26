import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/core/services/storage_service.dart';
import 'package:frontend/core/utils/app_messenger.dart';
import 'package:frontend/features/authentication/domain/auth_repository.dart';
import 'package:frontend/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:frontend/features/authentication/presentation/bloc/auth_event.dart';

import 'config/themes/app_theme.dart';
import 'core/wrapper/dio_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => StorageService()),
        RepositoryProvider(
          create: (context) {
            final storageService = context.read<StorageService>();
            final dioClient = DioClient(storageService);
            return AuthRepository(storageService, dioClient.dio);
          },
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
            AuthBloc(context.read<AuthRepository>())..add(CheckAuthStatus()),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: AppMessenger.scaffoldMessengerKey,
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: AppRouter.routes,
    );
  }
}
