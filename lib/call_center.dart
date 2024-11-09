import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CallCenterScreen extends StatelessWidget {
  final String phoneNumber = "6285700704667";
  Future<void> _callNumber() async {
    final Uri url = Uri.parse(
      'https://wa.me/6285700704667?text=Halo%20Blangkis,%20saya%20ingin%20memesan%20blangkon');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Tidak bisa Membuka Panggilan';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Call Center", style: TextStyle(color: Colors.white)),
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
              'Nomor Call Center: $phoneNumber',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _callNumber,
              child: const Text("Hubungi Call Center"),
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
