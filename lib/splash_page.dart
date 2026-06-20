import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 800), () {
      Navigator.pushReplacementNamed(context, '/login');
    });

    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset('assets/images/splash_logo.png', fit: BoxFit.cover),
      ),
    );
  }
}
