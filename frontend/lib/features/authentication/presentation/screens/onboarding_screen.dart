import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/custom_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Define ",
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: Colors.black,
                      fontSize: 48,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    "yourself in",
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: Colors.black,
                      fontSize: 48,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    "your unique",
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: Colors.black,
                      fontSize: 48,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    "way",
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: Colors.black,
                      fontSize: 48,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 55,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                child: Image.asset(
                  "assets/logo/Image.webp",
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                // decoration: BoxDecoration(color: Colors.white),
                child: CustomElevatedButton(
                  onPressed: () {
                    context.go("/register");
                    },
                  text: "Get Started",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
