import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SmsCenterScreen extends StatelessWidget {
  final String phoneNumber = "6285700704667";
  final String message = "Hallo, dengan Blangkon Pakis";
  void _sendSms() async {
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: {'body': message},
    );
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      debugPrint("Tidak bisa mengirim SMS.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SMS Center", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 136, 111, 12),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.webp',
              width: 80,
              height: 80,
            ),
            const SizedBox(height: 10),
            Text(
              'Nomor SMS Center: $phoneNumber',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendSms,
              child: const Text("Kirim SMS ke SMS Center"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 20.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
