import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.webp', height: 100),
            const SizedBox(height: 20),
            const Text('Selamat Datang', style: TextStyle(fontSize: 20)),
            const Text('di', style: TextStyle(fontSize: 20)),
            const Text('Blangkis (Blangkon Pakis)',
                style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
