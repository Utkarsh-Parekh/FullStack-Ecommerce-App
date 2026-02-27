import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:frontend/core/wrapper/api_exception_wrapper.dart';
import 'package:frontend/core/wrapper/api_response_wrapper.dart';
import 'package:frontend/features/authentication/data/user_model.dart';
import '../../../core/services/storage_service.dart';

class AuthRepository {
  final StorageService storageService;
  final Dio dio;

  AuthRepository(this.storageService, this.dio);

  Future<ApiResponse<UserModel>> register(
    String userName,
    String userEmailId,
    String userPassword,
  ) async {
    try {
      final response = await dio.post(
        "/register",
        data: {
          'username': userName,
          'emailId': userEmailId,
          'password': userPassword,
        },
      );

      final responseBody = response.data;

      final user = UserModel.fromJson(responseBody["user"]);
      return ApiResponse<UserModel>(
        data: user,
        message: responseBody["message"] ?? "Registered Successfully",
        statusCode: response.statusCode!,
        isSuccess: true,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<ApiResponse<UserModel>> login(
    final String emailId,
    final String password,
  ) async {
    try {
      final response = await dio.post(
        "/login",
        data: {'emailId': emailId, 'password': password},
      );

      final responseBody = response.data;
      print("response body is ${responseBody}");

      final user = UserModel.fromLoginJson(responseBody);

      await storageService.saveRefreshToken(user.refreshToken);
      await storageService.saveAccessToken(responseBody["accessToken"]);
      await storageService.saveUserJson(jsonEncode(user.toMap()));

      print("💾 Saving token: ${user.refreshToken}");
      print("saving accessToken: ${responseBody["accessToken"]}");

      return ApiResponse(
        data: user,
        message: responseBody["message"],
        statusCode: response.statusCode!,
        isSuccess: user.isLoggedIn,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<ApiResponse<String>> forgotPassword(String email) async {
    try {
      final response = await dio.post(
        "/forgot-password",
        data: {"emailId": email},
      );

      final data = response.data;
      String message = data["message"];
      return ApiResponse(
        message: message,
        statusCode: response.statusCode!,
        isSuccess: true,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<ApiResponse<String>> resendOtp(String email) async {
    try {
      final response = await dio.post('/resend-Otp', data: {"emailId": email});

      final data = response.data;

      String message = data["message"];
      return ApiResponse(
        message: message,
        statusCode: response.statusCode!,
        isSuccess: true,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<ApiResponse<String>> verifyOtp(String email, String code) async {
    try {
      final response = await dio.post(
        '/verify-otp',
        data: {"email": email, "otp": int.parse(code)},
      );

      final data = response.data;
      String message = data["message"];
      return ApiResponse(
        message: message,
        statusCode: response.statusCode!,
        isSuccess: true,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<ApiResponse<String>> resetPassword(
    String email,
    String password,
    String confirmPassword,
  ) async {
    try {
      final response = await dio.post(
        '/reset-otp',
        data: {
          "email": email,
          "password": password,
          "confirmPassword": confirmPassword,
        },
      );

      final data = response.data;
      String message = data["message"];
      return ApiResponse(
        message: message,
        statusCode: response.statusCode!,
        isSuccess: true,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<ApiResponse<UserModel>> getCurrentUser() async {
    try {
      final response = await dio.get("/currentUser");

      final data = response.data;

      final user = UserModel.fromJson(data["user"]);

      // Keep a fresh copy of user data in secure storage.
      await storageService.saveUserJson(jsonEncode(user.toMap()));

      return ApiResponse(
        data: user,
        message: "",
        statusCode: response.statusCode!,
        isSuccess: true,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> logout() async {
    try {
      await dio.post("/logOut");
      await storageService.deleteAccessToken();
      await storageService.deleteRefreshToken();
      await storageService.deleteUser();
    } on DioException catch (e) {
     throw _handleDioError(e);
    }
  }

  Future<String?> getToken() async {
    return await storageService.getAccessToken();
  }

  Future<UserModel?> getCachedUser() async {
    final json = await storageService.getUserJson();
    if (json == null) return null;
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return UserModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }
}

Exception _handleDioError(DioException e) {
  final message = e.response?.data["message"] ?? "Something went wrong";

  switch (e.response?.statusCode) {
    case 400:
      return BadRequestException(message);
    case 401:
      return UnauthorizedException(message);
    case 403:
      return ForbiddenException(message);
    case 404:
      return NotFoundException(message);
    case 500:
      return ServerException(message);
    default:
      return UnknownException(message);
  }
}
