import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../services/storage_service.dart';

class DioClient {
  final Dio dio;
  final StorageService storageService;

  DioClient(this.storageService)
      : dio = Dio(BaseOptions(
    baseUrl: dotenv.env['BASE_URL']!,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  )) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await storageService.getAccessToken();
          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            final success = await _refreshToken();

            if (success) {
              final newToken = await storageService.getAccessToken();
              error.requestOptions.headers["Authorization"] =
              "Bearer $newToken";

              final clonedRequest = await dio.fetch(error.requestOptions);
              return handler.resolve(clonedRequest);
            } else {
              await storageService.deleteAccessToken();
              await storageService.deleteRefreshToken();
            }
          }

          return handler.next(error);
        },
      ),
    );
  }

  Future<bool> _refreshToken() async {
    try {
      print("calling refeshtoken");
      final refreshToken = await storageService.getRefreshToken();
      if (refreshToken == null) return false;

      final refreshDio = Dio(BaseOptions(
        baseUrl: dotenv.env['BASE_URL']!,
      ));

      final response = await refreshDio.post(
        "refresh-token",
        data: {"refreshToken": refreshToken},
      );

      final newAccessToken = response.data["accessToken"];
      print("NEW ACCESSS TOKEN IS ${newAccessToken}");
      await storageService.saveAccessToken(newAccessToken);

      return true;
    } catch (e) {
      return false;
    }
  }
}