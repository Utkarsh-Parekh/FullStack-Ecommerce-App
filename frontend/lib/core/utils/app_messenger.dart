import 'package:flutter/material.dart';

class AppMessenger {
  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  static void _show({
    required String message,
    Color? bg,
    IconData? icon,
    Duration? duration,
    SnackBarAction? action,
  }) {
    final state = scaffoldMessengerKey.currentState;
    if (state == null) return;

    state.clearSnackBars();
    state.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: bg ?? Colors.grey.shade900,
        duration: duration ?? const Duration(seconds: 3),
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 20,
              ),
              SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600
                )
              ),
            ),
          ],
        ),
        action: action,
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }

  static void failure(String message, {Duration? duration}) => _show(
    message: message,
    icon: Icons.error_rounded,
    bg: Colors.red,
    duration: duration,
  );

  static void success(String message, {Duration? duration}) => _show(
    message: message,
    icon: Icons.check_circle_rounded,
    bg: Colors.green,
    duration: duration,
  );

  static void info(String message, {Duration? duration}) => _show(
    message: message,
    icon: Icons.info_rounded,
    bg: const Color(0xFF1565C0),
    duration: duration,
  );
}
