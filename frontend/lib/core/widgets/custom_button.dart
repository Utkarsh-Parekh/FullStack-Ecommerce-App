import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final Function()? onPressed;
  final String text;
  final Color backgroundColor;
  final Color foregroundColor;
  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    this.backgroundColor = Colors.black,
    this.foregroundColor = Colors.white,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed == null
            ? null
            : () async {
                await onPressed?.call();
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16)
        ),
        child: Text(text),
      ),
    );
  }
}
