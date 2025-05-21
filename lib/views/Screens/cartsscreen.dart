import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mad1_thefusionfork/views/Screens/cart_manager.dart';

class CartPage extends StatefulWidget {
  final Map<String, dynamic> item;

  const CartPage({super.key, required this.item});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String? selectedPayment = 'cod';
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      emailController.text = user.email ?? '';
    }
  }

  Future<void> placeOrder() async {
    final items = CartManager.items;
    if (items.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Your cart is empty!')));
      return;
    }

    if (emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    final itemIds = items.map((e) => e['id'].toString()).join(',');
    final quantities = List.filled(items.length, '1').join(',');
    final itemList = jsonEncode(items);

    final Map<String, dynamic> body = {
      'email': emailController.text,
      'mobile_number': phoneController.text,
      'first_name': firstNameController.text,
      'last_name': lastNameController.text,
      'address': addressController.text,
      'country': 'Sri Lanka',
      'city': 'Colombo',
      'payment_method': selectedPayment ?? 'cod',
      'amount': CartManager.totalPrice,
      'vat_amount': 0.0,
      'shipping_fee': 0.0,
      'order_total': CartManager.totalPrice,
      'item_ids': itemIds,
      'quantities': quantities,
      'items': itemList,
    };

    if (selectedPayment == 'card') {
      body.addAll({
        'card_number': '4111111111111111',
        'card_holder_name':
            '${firstNameController.text} ${lastNameController.text}',
        'expiry_month': '12',
        'expiry_year': '2026',
      });
    }

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/add-order'), // Emulator IP
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        CartManager.clearCart();
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? 'Order placed')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? 'Order failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = CartManager.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Items',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...items.map((item) => _buildCartItem(item)),
            const SizedBox(height: 20),
            Text(
              'Total: \$${CartManager.totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField('First Name', firstNameController),
            _buildTextField('Last Name', lastNameController),
            _buildTextField(
              'Email',
              emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            _buildTextField(
              'Contact Number',
              phoneController,
              keyboardType: TextInputType.phone,
            ),
            _buildTextField('Shipping Address', addressController, maxLines: 2),
            const SizedBox(height: 20),
            const Text(
              'Payment Method:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _buildPaymentOption('Credit/Debit Card', 'card', Icons.credit_card),
            _buildPaymentOption(
              'Wallet',
              'wallet',
              Icons.account_balance_wallet,
            ),
            _buildPaymentOption('Cash on Delivery', 'cod', Icons.money),
            _buildPaymentOption(
              'KOKO: Buy Now Pay Later',
              'koko',
              Icons.watch_later,
            ),
            _buildPaymentOption(
              'Split or Group Payment',
              'spg',
              Icons.splitscreen,
            ),
            _buildPaymentOption('Mintpay', 'mint', Icons.energy_savings_leaf),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: placeOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Place Order',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item) {
    final price = double.tryParse(item['price'].toString()) ?? 0.0;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Image.network(
              'http://10.0.2.2:8000${item['image']}',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => const Icon(Icons.fastfood),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'] ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Qty: 1',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      CartManager.removeItem(item);
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
            Text(
              '\$${price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String title, String value, IconData icon) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon),
          title: Text(title),
          trailing: Radio<String>(
            value: value,
            groupValue: selectedPayment,
            onChanged: (val) {
              setState(() => selectedPayment = val);
            },
          ),
        ),
        const Divider(),
      ],
    );
  }
}
