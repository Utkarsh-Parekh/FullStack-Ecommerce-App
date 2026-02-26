class ApiResponse<T> {
  final T? data;
  final String message;
  final int statusCode;
  final bool isSuccess;

  ApiResponse({this.data, required this.message, required this.statusCode, required this.isSuccess});


}