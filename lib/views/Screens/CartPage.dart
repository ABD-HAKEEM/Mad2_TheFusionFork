import 'package:flutter/material.dart';
import 'package:mad1_thefusionfork/views/Screens/cartsscreen.dart';
import 'package:mad1_thefusionfork/views/Screens/menupage.dart';

import 'cart_manager.dart';

class Cart extends StatefulWidget {
  const Cart({super.key, required Map item});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    final cartItems = CartManager.items;

    if (cartItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Checkout'),
          backgroundColor: Colors.orange,
        ),
        body: const Center(child: Text('Your cart is empty!')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];

          void removeItem() {
            setState(() {
              CartManager.removeItem(item);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${item['name']} removed from cart'),
                duration: const Duration(seconds: 2),
              ),
            );
          }

          return ListTile(
            leading: Image.network(
              'http://10.0.2.2:8000${item['image']}',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => const Icon(Icons.fastfood),
            ),
            title: Text(item['name'] ?? ''),
            subtitle: Text('Price: \$${item['price']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('\$${item['price']}'),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: removeItem,
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total: \$${CartManager.totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Place Order'),
              onPressed: () {
                var item = cartItems[0];
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartPage(item: item)),
                );
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Clear Cart'),
              onPressed: () {
                setState(() {
                  CartManager.clearCart();
                });
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MenuPage()),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cart cleared!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
