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
        title: const Text(
          'Daftar Produk',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        backgroundColor: Color(0xFF8B4513),
        elevation: 0,
        actions: [
          Theme(
            data: Theme.of(context).copyWith(
              popupMenuTheme: PopupMenuThemeData(
                color: Colors.white,
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.white),
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
                _buildPopupMenuItem('Call Center', 'Call', Icons.call),
                _buildPopupMenuItem('SMS Center', 'SMS', Icons.message),
                _buildPopupMenuItem('Lokasi/Maps', 'Map', Icons.location_on),
                _buildPopupMenuItem(
                    'Update User & Password', 'Update', Icons.update),
                _buildPopupMenuItem('Logout', 'Logout', Icons.logout),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF8B4513).withOpacity(0.1), Colors.white],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: _products.length,
                itemBuilder: (context, index) =>
                    _buildProductCard(_products[index]),
              ),
            ),
            _buildTotalBar(),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(
      String text, String value, IconData icon) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 20, color: Color(0xFF8B4513)),
          const SizedBox(width: 12),
          Text(text),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () => _showProductDetails(context, product),
        borderRadius: BorderRadius.circular(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              child: Stack(
                children: [
                  Image.asset(
                    product['image'],
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: CircleAvatar(
                      backgroundColor: Color(0xFF8B4513),
                      radius: 18,
                      child: IconButton(
                        icon: const Icon(Icons.add_shopping_cart,
                            size: 18, color: Colors.white),
                        onPressed: () => _addToCart(product),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rp ${product['price']}',
                    style: TextStyle(
                      color: Color(0xFF8B4513),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Total Pembelian',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Rp ${_totalSales.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B4513),
                    ),
                  ),
                ],
              ),
            ),
            if (_totalSales > 0)
              ElevatedButton(
                onPressed: _showPaymentForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF8B4513),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Bayar Sekarang',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
