import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'update_screen.dart';
import 'login.dart';
import 'call_center.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<Map<String, dynamic>> _products = [
    {
      'name': 'Blangkon Pakis',
      'image': 'assets/blangkon1.jpeg',
      'price': 50000,
      'description': 'Blangkon by Pakis'
    },
    {
      'name': 'Blangkon Jarit Jogja',
      'image': 'assets/blangkon2.jpeg',
      'price': 55000,
      'description': 'Blangkon Jogja'
    },
    {
      'name': 'Blangkon Jarit Jogja',
      'image': 'assets/blangkon3.jpeg',
      'price': 60000,
      'description': 'Blangkon Jogja'
    },
    {
      'name': 'Blangkon Jarit Jogja',
      'image': 'assets/blangkon4.jpeg',
      'price': 60000,
      'description': 'Blangkon Jogja'
    },
    {
      'name': 'Blangkon Jawa Timur',
      'image': 'assets/blangkon5.jpeg',
      'price': 55000,
      'description': 'Blangkon Khas Jawa Timur'
    },
    {
      'name': 'Blangkon Solo',
      'image': 'assets/blangkon6.jpeg',
      'price': 55000,
      'description': 'Blangkon Surakarta Motif Batik Jebeh'
    },
    {
      'name': 'Blangkon Alusan Jogja',
      'image': 'assets/blangkon7.jpeg',
      'price': 70000,
      'description': 'Blangkon Jogja Alusan'
    },
    {
      'name': 'Blangkon Jarit Surakarta',
      'image': 'assets/blangkon8.jpeg',
      'price': 65000,
      'description': 'Blangkon Jarit Solo/Surakarta'
    },
    {
      'name': 'Blangkon Jogja',
      'image': 'assets/blangkon9.jpeg',
      'price': 55000,
      'description': 'Blangkon Jogja Motif Jebeh'
    },
    {
      'name': 'Blangkon Surakarta',
      'image': 'assets/blangkon10.jpeg',
      'price': 75000,
      'description': 'Blangkon Khas Solo Alusan'
    },
  ];
  final List<Map<String, dynamic>> _cart = [];
  double _totalSales = 0;
  void _addToCart(Map<String, dynamic> product) {
    setState(() {
      _cart.add(product);
      _totalSales += product['price'];
    });
  }

  void _showProductDetails(BuildContext context, Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(product['name']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(product['image'], fit: BoxFit.cover),
            const SizedBox(height: 10),
            Text(product['description']),
          ],
        ),
      ),
    );
  }

  void _showPaymentForm() async {
    final result = await Navigator.pushNamed(
      context,
      '/payment',
      arguments: {'total': _totalSales, 'cart': _cart},
    );
    if (result == true) {
      setState(() {
        _cart.clear();
        _totalSales = 0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pembayaran Berhasil!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void onWAPressed() async {
    final Uri url = Uri.parse(
      'https://wa.me/6285700704667?text=Halo%20Blangkis,%20saya%20ingin%20memesan%20blangkon');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  Future<void> _launchMap() async {
    final Uri mapUri = Uri.parse(
        'https://www.google.com/maps/place/Blangkon+Pakis/@-7.2466669,110.5318773,21z/data=!4m6!3m5!1s0x2e709de406db7395:0x1b474cc91fd62457!8m2!3d-7.2466476!4d110.5319249!16s%2Fg%2F11sbwpxv35?entry=ttu&g_ep=EgoyMDI0MTAyOS4wIKXMDSoASAFQAw%3D%3D');
    await launchUrl(mapUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Daftar Produk', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 119, 100, 25),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Call') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CallCenterScreen(),
                  ),
                );
              } else if (value == 'SMS') {
                onWAPressed();
              } else if (value == 'Map') {
                _launchMap();
              } else if (value == 'Update') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UpdateScreen(),
                  ),
                );
              } else if (value == 'Logout') {
                _logout();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'Call', child: Text('Call Center')),
              const PopupMenuItem(value: 'SMS', child: Text('SMS Center')),
              const PopupMenuItem(value: 'Map', child: Text('Lokasi/Maps')),
              const PopupMenuItem(
                  value: 'Update', child: Text('Update User & Password')),
              const PopupMenuItem(value: 'Logout', child: Text('Logout')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 2 / 2.5,
              ),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 3,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => _addToCart(product),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            product['image'],
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 100,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: GestureDetector(
                          onTap: () => _showProductDetails(context, product),
                          child: SizedBox(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  product['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                  textAlign: TextAlign.left,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Harga: Rp ${product['price']}',
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 12),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[200],
            child: GestureDetector(
              onTap: _totalSales > 0 ? _showPaymentForm : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Pembelian: Rp ${_totalSales.toStringAsFixed(0)}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
