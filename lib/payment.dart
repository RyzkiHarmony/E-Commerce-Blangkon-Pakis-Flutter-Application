import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  final double total;
  final List<Map<String, dynamic>> cart;
  const PaymentScreen({super.key, required this.total, required this.cart});
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _paymentController = TextEditingController();
  double? _change;
  void _confirmPayment() {
    if (_nameController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _paymentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Nama, alamat, dan jumlah pembayaran tidak boleh kosong!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    final double paymentAmount = double.tryParse(_paymentController.text) ?? 0;
    if (paymentAmount < widget.total) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jumlah pembayaran tidak cukup untuk total pembelian!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() {
      _change = paymentAmount - widget.total;
    });
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Pembayaran'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Nama: ${_nameController.text}'),
            Text('Alamat: ${_addressController.text}'),
            Text('Total Pembayaran: Rp ${widget.total.toStringAsFixed(0)}'),
            Text('Jumlah Uang: Rp ${paymentAmount.toStringAsFixed(0)}'),
            Text('Kembalian: Rp ${_change?.toStringAsFixed(0) ?? '0'}'),
            const SizedBox(height: 10),
            const Text('Detail Produk:'),
            Column(
              children: widget.cart.map((product) {
                return ListTile(
                  title: Text(product['name']),
                  subtitle: Text('Harga: Rp ${product['price']}'),
                );
              }).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showSuccessMessage();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessMessage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pembayaran Berhasil'),
        content: const Text('Terima kasih, pembayaran Anda telah berhasil.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(true);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _cancelTransaction() {
    Navigator.of(context).pop(
        'cancel'); // Mengirim nilai 'cancel' saat kembali ke DashboardScreen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Pembayaran',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 136, 111, 12),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Alamat',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Produk yang Dibeli:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.cart.length,
                itemBuilder: (context, index) {
                  final product = widget.cart[index];
                  return ListTile(
                    leading: Image.asset(
                      product['image'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(product['name']),
                    subtitle: Text('Harga: Rp ${product['price']}'),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Total Pembayaran: Rp ${widget.total.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _paymentController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Jumlah Uang',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            if (_change != null)
              Text(
                'Kembalian: Rp ${_change?.toStringAsFixed(0)}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 20),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _cancelTransaction,
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: _confirmPayment,
                    child: const Text('Bayar Sekarang'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
